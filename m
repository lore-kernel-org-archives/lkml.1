Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbYEAABg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbYEAABg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764317AbYD3X6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765044AbYD3X63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/11] kobject: do not copy vargs, just pass them around
Date: Wed, 30 Apr 2008 16:57:46 -0700
Message-Id: <1209599870-22919-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This prevents a few unneeded copies.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index fd78740..718e510 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -216,21 +216,12 @@ static int kobject_add_internal(struct kobject *kobj)
 static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	va_list aq;
-	char *name;
-
-	va_copy(aq, vargs);
-	name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	va_end(aq);
-
-	if (!name)
-		return -ENOMEM;
-
 	/* Free the old name, if necessary. */
 	kfree(kobj->name);
 
-	/* Now, set the new name */
-	kobj->name = name;
+	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
+	if (!kobj->name)
+		return -ENOMEM;
 
 	return 0;
 }
@@ -246,12 +237,12 @@ static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
  */
 int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 {
-	va_list args;
+	va_list vargs;
 	int retval;
 
-	va_start(args, fmt);
-	retval = kobject_set_name_vargs(kobj, fmt, args);
-	va_end(args);
+	va_start(vargs, fmt);
+	retval = kobject_set_name_vargs(kobj, fmt, vargs);
+	va_end(vargs);
 
 	return retval;
 }
@@ -301,12 +292,9 @@ EXPORT_SYMBOL(kobject_init);
 static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
 			    const char *fmt, va_list vargs)
 {
-	va_list aq;
 	int retval;
 
-	va_copy(aq, vargs);
-	retval = kobject_set_name_vargs(kobj, fmt, aq);
-	va_end(aq);
+	retval = kobject_set_name_vargs(kobj, fmt, vargs);
 	if (retval) {
 		printk(KERN_ERR "kobject: can not set name properly!\n");
 		return retval;
-- 
1.5.5.1

