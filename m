Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYFVNPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYFVNPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 09:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYFVNOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 09:14:49 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:45585 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYFVNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 09:14:46 -0400
Message-ID: <485E505F.8010306@keyaccess.nl>
Date: Sun, 22 Jun 2008 15:15:11 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [REGRESSION, ABI] Re: [lm-sensors] LMSENSORS: 2.6.26-rc, enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl>
In-Reply-To: <485DFF35.6080008@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-06-08 09:28, Hans de Goede wrote:

This is an ABI breakage issue and an unfortunate one at that:

> Rene Herman wrote:

>> On 2.6.26-rc and perhaps earlier, when I enable the ACPI Thermal Zone 
>> support (CONFIG_ACPI_THERMAL) I see in dmesg:

Note, 2.6.25-rc7 works fine with it enabled.

>> ACPI: LNXTHERM:01 is registered as thermal_zone0
>> ACPI: Thermal Zone [THRM] (56 C)
>>
>> My /sys/class/hwmon/hwmon0 (a W83782D chip) becomes hwmon1, there's a 
>> new /sys/class/hwmon/hwmon0 and "sensors -s" craps out with:
>>
>> # sensors -s
>> Can't access procfs/sysfs file
>> Kernel interface access error
>> For 2.6 kernels, make sure you have mounted sysfs and libsensors
>> was compiled with sysfs support!
>>
>> # sensors --version
>> sensors version 2.10.6 with libsensors version 2.10.6
>>
>> This is the slackware 12.1 (recent) standard version. What's wrong?
>>
>> In case it's useful, my /etc/sensors.conf is at:
>>
>> http://members.home.nl/rene.herman/sensors.conf
> 
> I'm pretty sure this caused by your lm_sensors using space being to old 
> to support the new thermalzone stuff. You need atleast 3.0.2 to support 
> the thermalzone driver.

I see. I was about to mark this up as Volkerding doing his usual "if it 
has a lower version number it must be better" thing but in this case it 
seems it's hwmon or ACPI which is to blame.

Firstly -- with CONFIG_ACPI_THERMAL selected my sensors work fine on 
2.6.25-rc7 with the above 2.10.6 lm_sensors userspace. Now, with 
2.6.26-rc (*) they do not as per above.

This is ABI breakage. I wouldn't care if my older lm_sensors userspace 
couldn't handle the ACPI Thermal Zone, but I do care that even having it 
breaks my other sensors; especially given the CONFIG_ACPI_THERMAL help 
text which can not be read as recommending to disable it:

   This driver adds support for ACPI thermal zones.  Most mobile and
   some desktop systems support ACPI thermal zones.  It is HIGHLY
   recommended that this option be enabled, as your processor(s)
   may be damaged without it.

Now, I'm actually usally a big fan of not dragging around old gunk 
forever, ABI be damned, but in this case this really won't do. 2.6.10 is 
a recent maintenance release and I see for the new 3.0 branch:

http://www.lm-sensors.org/wiki/Download

===
Most third party monitoring applications do not yet work with the 
library in this package. We are encouraging authors to port their 
applications to the new library. We already have patches for xsensors 
0.60, gkrellm-2.3.0, net-snmp-5.4.1 (configure with 
--with-mib-modules="ucd-snmp/lmsensorsMib" --with-ldflags="-lsensors"), 
xfce4-sensors-plugin-0.10.99.2, kdebase-3.5.8(ksysguard), 
sensors-applet-1.8.1 and ksensors-0.7.3-fedora-14.tar.gz (upstream is 
dead this tarbal contains a version with all Debian's changes + 2 
patches from Fedora, including lm_sensors-3.x support).
===

So it seems we have here a change to the kernel requiring a userspace 
basically noone is ready for and which at least the (again, recent) 
slackware 12.1 doesn't ship as a result. This is ABI breakage of the 
really bad kind.

If there's not just something I'm missing, could someone please get 
Linus a patch ASAP making whatever breaks lm_sensors 2 optional, 
disabled by default and with a help text that warns that enabling it 
requires a new lm_sensors userspace?

I haven't seen other complaints about this and would've expected them so 
it might ofcourse be possible that I'm just missing something and have a 
very specific problem; if in that case someone could advice what it 
might be -- please do.

But if not, .26 is around the corner and requiring libsensors-3.0 must 
really not be.

(*) 2.6.26-rc7 at least. I actually noticed this early in the -rc stage 
but had too many other breakage at that point to worry about this one. I 
just disabled the ACPI Thermal Zone support and forgot about it upto 
this point.

Rene.
