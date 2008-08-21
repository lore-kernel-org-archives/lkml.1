Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbYHUVSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbYHUVSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYHUVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:18:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYHUVSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:18:39 -0400
Message-Id: <24565067.73831219353513508.JavaMail.servlet@kundenserver>
From: Kay Sievers <kay.sievers@vrfy.org>
To: <bjorn.helgaas@hp.com>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Cc: <ambx1@neo.rr.com>
Cc: <elendil@planet.nl>
Cc: <trenn@suse.de>
Cc: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <tpm@selhorst.net>
Cc: <rjw@sisk.pl>
Cc: <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-Binford: 6100 (more power)
X-Mailer: Webmail
X-Originating-From: 27589459
X-Routing: DE
X-Message-Id: <27589459$1219353513460172.23.4.15818718790@pustefix158.kundenserver.de-2063773763>
Date: Thu, 21 Aug 2008 23:18:33 +0200
X-Provags-ID: V01U2FsdGVkX198U/p6TrGqIw2e9FwvxAh71+U3ukz//QBULWJ
 JRekDkVrRe3lfz+bAdoqdBirhx7GzjGOO2/UzCPdAnpcm5Yabq
 YOBp7YqzuPq/F3p8/Bh8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
>On Thursday 21 August 2008 09:38:25 am Kay Sievers wrote:
>> On Thu, 2008-08-21 at 09:14 -0600, Bjorn Helgaas wrote:
>> > Can somebody elaborate on why we need to add "acpi*" aliases for all
>> > PNP devices?  That broadens the kernel/user interface, so I'd like
>> > to understand why we need it.
>
>Sorry, I should have prefaced my question with "I'm completely ignorant
>of this modalias stuff."

:)

>Is there a "complete idiot's guide to modules
>and udev"?  There's precious little in Documentation/ other than a bunch
>of sample rules for various subsystems.

I don't know of any specific documentation, but it's pretty easy:
Devices, any kind of device, can export a match, based on specific
properties of the subsystem it belongs to. In most cases its the same
propery/id that is used inside the kernel, to find a (already loaded)
driver which will bind this device. 

Any unique string, hardware ID's, whatever, are stuffed into a modalias,
prefixed by "<subsystem>:" to be unique.

PCI and USB are pretty obvious, they just stuff all their hardware ID'S
into a string, in a defined order, and let every device export that value
to userspace by MODALIAS environment key and the "modalias" sysfs file.
Other subsystem may have simple strings to match, they define
themselves.

Now, the drivers contain "match id tables" which are used by the core
to bind devices to drivers. These tables area made available to
file2alias.c in the module postprocessing, and will end up in the
module file itself. The string is mangled to contain wildcards, so
they can just be fnmatch()'d against the modalias value, which the
devices export.

The string embedded in the modules are extracted by depmod, and put
into the modules.aliases file in /lib/modules/. Every time modprobe
is called with an alias, it searches through this file and loads all
modules which contained a matching alias string.

Udev does nothing but stupidly running modprobe for every device which
contains MODALIAS in the event environment, and passes $MODALIAS as
an argument to modprobe.

That's basically the whole module autoloading today. :)

>> We already do ACPI module autoloading by MODALIAS for other things than
>> pnp. ACPI exports the pnp devices with modalias, but the modules do not
>> have a matching alias, this add them.
>
>I'm guessing this has something to do with acpi_device_uevent().

That's where the MODALIAS environment value is composed, yes.

>> PNP has no MODALIAS support at all, and the current pnp-aliases would
>> not work for the standard modalias method, they would need to change
>> their format.
>
>pnp_bus_type has no .uevent method.  What if I added one?  Would that
>help this situation?

Only if we would change the format of the aliases.

>It seems wrong for file2alias.c to take every PNP device (even if it's
>an ISAPNP or PNPBIOS device) and add "acpi*" aliases for it.

Yeah, they are all exported by acpi too.

>> The plan is to replace the current pnp modprobe shell script hack in
>> udev, when ACPI devices load the right modules without any special
>> userspace mangling.
>
>Is this the shell hack you mean (from etc/udev/rules.d/80-drivers.rules
>in udev-117)?
>
>  SUBSYSTEM=="pnp", DRIVER!="?*", ENV{MODALIAS}!="?*", \
>    RUN{ignore_error}+="/bin/sh -c '/sbin/modprobe -a $$(while read id; do 
>echo pnp:d$$id; done < /sys$devpath/id)'"
>
>I agree that's gross.

Yeah, that's what we want to kill. :)

>Could I fix this by implementing pnp_device_uevent()?

Only if we change the format of the current pnp device aliases
to something like:
  pnp*:XYZ2324:*
  pnp*:ABC1234:*

and create a "modalias" file at every pnp device, and add MODALIAS to
the uevent. The modalias must contains all ID's which belong to that
device in one single string, separated and terminated by a special
character, something like:
  pnp:ABC1234:XYZ2324:RST3445:

That's how acpi should work with this patch now.

Kay
