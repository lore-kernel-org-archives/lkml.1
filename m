Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYKGWdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYKGWdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYKGWdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:33:15 -0500
Received: from kroah.org ([198.145.64.141]:39777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279AbYKGWdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:33:14 -0500
Subject: patch acpi-dock-avoid-check-_sta-method.patch added to 2.6.25-stable tree
To: shaohua.li@intel.com, gregkh@suse.de, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Fri, 07 Nov 2008 14:19:53 -0800
In-Reply-To: <alpine.LFD.2.00.0811061417380.3106@localhost.localdomain>
Message-Id: <20081107223313.81FA048D65@coco.kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: ACPI: dock: avoid check _STA method

to the 2.6.25-stable tree.  Its filename is

    acpi-dock-avoid-check-_sta-method.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From lenb@kernel.org  Fri Nov  7 14:08:55 2008
From: Shaohua Li <shaohua.li@intel.com>
Date: Thu, 06 Nov 2008 14:18:55 -0500 (EST)
Subject: ACPI: dock: avoid check _STA method
To: stable@kernel.org
Cc: linux-acpi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Shaohua Li <shaohua.li@intel.com>
Message-ID: <alpine.LFD.2.00.0811061417380.3106@localhost.localdomain>

From: Shaohua Li <shaohua.li@intel.com>

commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db upstream.

ACPI: dock: avoid check _STA method

In some BIOSes, every _STA method call will send a notification again,
this cause freeze. And in some BIOSes, it appears _STA should be called
after _DCK. This tries to avoid calls _STA, and still keep the device
present check.

http://bugzilla.kernel.org/show_bug.cgi?id=10431

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/dock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -599,14 +599,17 @@ static int handle_eject_request(struct d
 static void dock_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct dock_station *ds = data;
+	struct acpi_device *tmp;
 
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
-		if (!dock_in_progress(ds) && dock_present(ds)) {
+		if (!dock_in_progress(ds) && acpi_bus_get_device(ds->handle,
+		   &tmp)) {
 			begin_dock(ds);
 			dock(ds);
 			if (!dock_present(ds)) {
 				printk(KERN_ERR PREFIX "Unable to dock!\n");
+				complete_dock(ds);
 				break;
 			}
 			atomic_notifier_call_chain(&dock_notifier_list,


Patches currently in stable-queue which might be from shaohua.li@intel.com are

queue-2.6.25/acpi-dock-avoid-check-_sta-method.patch
