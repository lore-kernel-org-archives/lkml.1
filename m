Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXGMM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXGMM6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbXGMM62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:58:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXGMM61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:58:27 -0400
Subject: [PATCH - 0/2] Identify native drivers and ACPI subsystem accessing
	the same resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 14:58:12 +0200
Message-Id: <1184331492.3960.100.camel@d88.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(after review and some discussion) this is meant for -mm.

In the recent past more and more cases appeared where (mainly
hwmon/sensors) drivers interfered with ACPI subsystem.

Such interference can show up in all kind of bugs (messed up
temperature, thermal management which is rather sever,..), that
are hard to identify -> Remove potential drivers and wait ...

This patch should:
a) Identify machines where potentially ACPI interference can happen and
   tell the user which legacy drivers are affected.
b) Identify drivers/HW where we might need an ACPI driver in future
c) If it works out (if not too much important drivers are affected)
   enforce that native, non-ACPI drivers using the same IO/System
   memory addresses as declared in ACPI namespace fail to load.


There are two kind of IO/System memory declarations in ACPI ASL
language: general variables and device specific resource
declarations.
The latter is already handled by pnpacpi and resources get requested 
from pnpacpi already. These resources can (with this patch) partly
already be requested by the general ACPI declarations and this patch
should handle this gracefully.

ACPI drivers (e.g. pnpacpi and others) are allowed to request these
resources (marked IORESOURCE_SHARED) through acpi_request_region().
Depending on strict, lax, no(default) others (drivers not using ACPI)
requesting ACPI variable resources will:
  strict: fail to request the resource -> driver normally will not load
  lax:    you get a syslog entry which resource might conflict with a
          "shared resource" and a "System might run unstable.." warning.
  no:     same behaviour as without the patch


strict and no params should work as described.
Unfortunately there is one unresolved problem with the lax option:

Here two examples of not nice things that could happen with lax option:

 a) legacy drivers (in this case arch/x86_64/setup.c) request resources
    before ACPI variables (shared resources) are requested:
(/proc/ioports):
0080-008f : dma page reg
  0080-0080 : ACPI DEB0*
    In this case it's working as "dma page reg" includes the ACPI 
    SystemIO variable's space. If the ACPI variable is bigger, I expect
    the ACPI variable would not get inserted...

 b) A legacy driver requests resources bigger than the ACPI SystemIO 
    variable, but the ACPI resource variable lies within the requested
    space. Example:
(/proc/ioports):
0070-0071 : rtc0
0072-0073 : ACPI KSB0*
(syslog):
IO region [rtc] conflicts with [ACPI KSB0].  Ignoring.., system might
run unstable.
rtc: I/O resource 70 is not free.

    The rtc driver seems to request the whole rtc space (0x70-0x77)
    which fails because 0x72-0x73 has already been requested SHARED by
    an ACPI SystemIO variable. At least parts of the rtc space got
    requested (rtc0), I haven't checked whether the device was working
    correctly...
    This is the case where lax would not behave as expected, which is
    kind of sad, because lax was my favorite default option.
    I have no idea how this issue could get addressed cleanly..., maybe
    someone has an idea...


Another issue that needs fix up is that the motherboad driver is not
requesting it's resources anymore (which it still did with 2.6.18 - I
didn't dig here anymore, maybe someone can comment why this has changed)
Example:
2.6.22.1:
(syslog with lax option):
IO region [amd756_smbus] conflicts with [ACPI PMIO].  Ignoring.., system
might run unstable.
(/proc/ioports)
5000-50fe : ACPI PMIO*
  5000-5003 : ACPI PM1a_EVT_BLK
  5004-5005 : ACPI PM1a_CNT_BLK
  5008-500b : ACPI PM_TMR
  5020-5023 : ACPI GPE0_BLK
  50b0-50b7 : ACPI GPE1_BLK
  50e0-50ef : amd756_smbus       # with strict this one must not be here

This is because the non-acpi driver amd756_smbus tries to request from
an ACPI reserved region -> this is what we try to find and eliminate.
In 2.6.18 a motherboard ACPI driver reserved space via acpipnp which
would look like this then (which is what we want):
5000-50fe : ACPI PMIO*          # ACPI SystemIO variable
..
  50e0-50ff : motherboard       # PNP0C02 motherboard driver reserves region via acpipnp shared
    50e0-50ef : amd756_smbus    # amd756_smbus allowed to get resources from motherboard driver
..


One example DSDT and bugreport of ACPI interfering with hwmon driver is
here (with strict there the it87 module, trying to access 0x29[56] would
not load. We also would get a pointer that on this one an ACPI driver is
needed to control this device -> there are some vendor/BIOS specific
ACPI functions providing functionality for this device like: SFAN, FON,
FOFF, RTMP, STHY, STOS, SCFG):
https://bugzilla.novell.com/show_bug.cgi?id=259992


Summary:
  - IMO good enough for -mm, no functional change with default param
    -> Would be nice if more people test, this one is very machine
       specific, especially that if not activated (no param or
       acpi_enforce_resources=no) nothing changes.
  - motherboard driver not reserving _CRS resources currently, needs
    to be addressed so that the patch does not throw false positive
    interference on motherboard subdrivers.
  - Not fixable (maybe someone has an idea): If ACPI IO region declares
    a smaller IO part than the later native driver (e.g. example above
    with rtc driver), the partially overlapping resource cannot be
    registered and the native driver fails to load with strict and lax
    option.

Thanks,

   Thomas

