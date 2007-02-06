Return-Path: <linux-kernel-owner+w=401wt.eu-S965578AbXBFWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbXBFWmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXBFWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:42:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965578AbXBFWmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:42:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm] swsusp: Fix possible oops in userland interface
Date: Tue, 6 Feb 2007 23:41:59 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Pavel Machek <pavel@ucw.cz>, Stefan Seyfried <seife@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702062342.00269.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SNAPSHOT_PMOPS and SNAPSHOT_S2RAM ioctls can Oops if they are called from
a kernel that doesn't set pm_ops (eg. non-ACPI kernel on a PC).  Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/user.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6.20-rc6-mm3/kernel/power/user.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/kernel/power/user.c	2007-02-04 18:36:21.000000000 +0100
+++ linux-2.6.20-rc6-mm3/kernel/power/user.c	2007-02-04 18:56:53.000000000 +0100
@@ -341,6 +341,11 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_S2RAM:
+		if (!pm_ops) {
+			error = -ENOSYS;
+			break;
+		}
+
 		if (!data->frozen) {
 			error = -EPERM;
 			break;
@@ -383,8 +388,12 @@ static int snapshot_ioctl(struct inode *
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			data->platform_suspend = 1;
-			error = 0;
+			if (pm_ops && pm_ops->enter) {
+				data->platform_suspend = 1;
+				error = 0;
+			} else {
+				error = -ENOSYS;
+			}
 			break;
 
 		case PMOPS_ENTER:
