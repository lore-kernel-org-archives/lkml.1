Return-Path: <linux-kernel-owner+w=401wt.eu-S1763759AbYJKHAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763759AbYJKHAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbYJKGkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:43 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52462 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYJKGg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:58 -0400
Date: Sat, 11 Oct 2008 02:35:48 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 28/85] ACPI: dock: avoid check _STA method
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <8b59560a3baf2e7c24e0fb92ea5d09eca92805db.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

In some BIOSes, every _STA method call will send a notification again,
this cause freeze. And in some BIOSes, it appears _STA should be called
after _DCK. This tries to avoid calls _STA, and still keep the device
present check.

http://bugzilla.kernel.org/show_bug.cgi?id=10431

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 7d2edf1..25d2161 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -604,14 +604,17 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
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
-- 
1.5.5.1

