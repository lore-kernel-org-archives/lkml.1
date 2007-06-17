Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXFQUYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXFQUYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbXFQUX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:23:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:53656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880AbXFQUX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:23:57 -0400
Subject: [PATCH 0/3] ACPI autoloading
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Kay Sievers <kasievers@suse.de>
Content-Type: multipart/mixed; boundary="=-IISBTvarbZl6kMQOKne3"
Date: Sun, 17 Jun 2007 22:22:04 +0200
Message-Id: <1182111724.4204.0.camel@noname>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IISBTvarbZl6kMQOKne3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch series enables ACPI modules to get loaded automatically via
module aliases.

Thanks to Kay I got help with the udev strings and this got already some
testing and review.

There are some minor problems left, but this should be mm ready and it
would be great if you can add these to your acpi-test tree, Len (patches
clean against 2.6.22-rc4, the last patch has some offset/fuzz against
acpi-test, but should patch correctly without modifications).

The known problems are:


A) Cannot pass acpi_device_id through ops.add (probe equivalent func)
---------------------------------------------------------------------

int acpi_match_device_ids(..)
should be:
const acpi_device_id *acpi_match_device_ids
and the matching device id should get passed to the acpi driver's .add
function.
This would ease up the code in the ACPI driver a lot (e.g. see button.c,
it is compared again which device (HID) has been found. Theoretically
the drivers also needs to check CIDs...).

The problem is that in scan.c ACPI driver is abstracted to use .match
and .probe "struct bus_type" functions and I have no idea how the
matching acpi_device_id should get passed or stored from
acpi_match_device_ids (.match) to ops.add (invoked in .probe).
Currently:
        kernel_ulong_t driver_data;
of acpi_device_id got added, but is not used at all atm.


B) Thermal module always gets loaded
------------------------------------

This is because _TZ_ (scope?!?) always gets added, but is declared as a
device or at least pops up as a thermal device.
This is in drivers/acpi/utilities/utglobal.c:

/*
 * Predefined ACPI Names (Built-in to the Interpreter)
 *
 * NOTES:
 * 1) _SB_ is defined to be a device to allow \_SB_._INI to be run
 *    during the initialization sequence.
 * 2) _TZ_ is defined to be a thermal zone in order to allow ASL code to
 *    perform a Notify() operation on it.
 */

Any idea how to get rid of that is very welcome.
Is this to be able to process buggy ASL code of this kind?:
"Notify ("_TZ_", 0x80)"
While _TZ_ is not a real device, but a scope operator and gets
statically declared as a device here to solve such things?


C) Renaming/Unifying of HID strings
-----------------------------------

This shouldn't be a problem. Consequence is that the new ACPI sysfs
structure will show other names, but as it got introduced recently this
shouldn't hurt anyone?

For better readability we could map all HIDs to a device name through a
HID <-> Device Name - enum and table. And then export "battery" again
through /sys instead of "PNP0C0A".
This was a bit mixed up. If, this should get implemented soon as the
sysfs structure should not get altered that often...
If wanted, I can send an on top patch later...

D) Why renaming struct acpi_device_id to struct __acpi_device_id

Not a problem, just for understanding why I have done this:
struct acpi_device_id already exists in ACPICA. The module aliasing
interface requires that struct "SUBSYSTEM"_device_id is used as name.
This is not that obvious (include/linux/module.h):
#define MODULE_GENERIC_TABLE(gtype,name) and
#define MODULE_DEVICE_TABLE(type,name)

-------------------------


For SUSE users who want to test this, you also need a minor change in
userspace (AFAIK this additionally abstraction vanishes soon...
hopefully), the change is attached. Theoretically ACPI modules should
now get autoloaded via udev out of the box...

Any comments, corrections, ideas, etc. very welcome.

Thanks,

     Thomas

--=-IISBTvarbZl6kMQOKne3
Content-Disposition: attachment; filename=acpi_autoload_userspace_suse.patch
Content-Type: text/x-patch; name=acpi_autoload_userspace_suse.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: /etc/udev/rules.d/80-sysconfig.rules
===================================================================
--- .orig/etc/udev/rules.d/80-sysconfig.rules
+++ /etc/udev/rules.d/80-sysconfig.rules
@@ -15,5 +15,6 @@ SUBSYSTEM=="pnp", ACTION=="add", RUN+="/
 SUBSYSTEM=="ide", ACTION=="add", RUN+="/sbin/hwup ide-devpath-%p -o hotplug"
 SUBSYSTEM=="input", KERNEL=="input[0-9]*", ACTION=="add", RUN+="/sbin/hwup input-devpath-%p -o hotplug"
 SUBSYSTEM=="platform", ACTION=="add", RUN+="/sbin/hwup platform-devpath-%p -o hotplug"
+SUBSYSTEM=="acpi", ACTION=="add", RUN+="/sbin/hwup acpi-devpath-%p -o hotplug"
 
 LABEL="sysconfig_end"
Index: /sbin/hwup
===================================================================
--- .orig/sbin/hwup
+++ /sbin/hwup
@@ -65,6 +65,7 @@ get_config_getcfg() {
 
 is_known_subsystem() {
 	case "$1" in
+		acpi)             return 0 ;;
 		ccw)              return 0 ;;
 		ccwgroup)         return 0 ;;
 		iucv)             return 0 ;;

--=-IISBTvarbZl6kMQOKne3--

