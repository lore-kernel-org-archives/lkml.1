Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXEYMvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXEYMvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXEYMvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:51:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbXEYMvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:51:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Hibernation: Prepare to enter the low power state
Date: Fri, 25 May 2007 14:56:47 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251456.47822.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

During hibernation we call hibernation_ops->prepare() before creating the image,
but then, before saving it, we cancel the power transition by calling
hibernation_ops->finish().  Thus prior to calling hibernation_ops->enter() we
should let the platform firmware know that we're going to enter the low power
state after all.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc2/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/disk.c	2007-05-19 11:25:56.000000000 +0200
+++ linux-2.6.22-rc2/kernel/power/disk.c	2007-05-19 12:43:52.000000000 +0200
@@ -205,12 +205,23 @@ int hibernation_restore(int platform_mod
 
 int hibernation_platform_enter(void)
 {
+	int error;
+
 	if (hibernation_ops) {
 		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-		return hibernation_ops->enter();
+		/*
+		 * We have cancelled the power transition by running
+		 * hibernation_ops->finish() before saving the image, so we
+		 * should let the firmware know that we're going to enter the
+		 * sleep state after all
+		 */
+		error = hibernation_ops->prepare();
+		if (!error)
+			error = hibernation_ops->enter();
 	} else {
-		return -ENOSYS;
+		error = -ENOSYS;
 	}
+	return error;
 }
 
 /**
