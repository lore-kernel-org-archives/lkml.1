Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYAYH0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYAYH0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbYAYHQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:21 -0500
Received: from ns1.suse.de ([195.135.220.2]:52628 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775AbYAYHQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 037/196] kobject: fix up kobject_set_name to use kvasprintf
Date: Thu, 24 Jan 2008 23:09:35 -0800
Message-Id: <1201245134-4876-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay pointed out that kobject_set_name was being very stupid, doing two
allocations for every call, when it should just be using the kernel
function kvasprintf() instead.

This change adds the internal kobject_set_name_vargs() function, which
other follow-on patches will be using.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   71 +++++++++++++++++++++++++-------------------------------
 1 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 9500339..4a310e5 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -232,60 +232,53 @@ int kobject_register(struct kobject * kobj)
 	return error;
 }
 
+/**
+ * kobject_set_name_vargs - Set the name of an kobject
+ * @kobj: struct kobject to set the name of
+ * @fmt: format string used to build the name
+ * @vargs: vargs to format the string.
+ */
+static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
+				  va_list vargs)
+{
+	va_list aq;
+	char *name;
+
+	va_copy(aq, vargs);
+	name = kvasprintf(GFP_KERNEL, fmt, vargs);
+	va_end(aq);
+
+	if (!name)
+		return -ENOMEM;
+
+	/* Free the old name, if necessary. */
+	kfree(kobj->k_name);
+
+	/* Now, set the new name */
+	kobj->k_name = name;
+
+	return 0;
+}
 
 /**
  * kobject_set_name - Set the name of a kobject
- * @kobj: kobject to name
+ * @kobj: struct kobject to set the name of
  * @fmt: format string used to build the name
  *
  * This sets the name of the kobject.  If you have already added the
  * kobject to the system, you must call kobject_rename() in order to
  * change the name of the kobject.
  */
-int kobject_set_name(struct kobject * kobj, const char * fmt, ...)
+int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 {
-	int error = 0;
-	int limit;
-	int need;
 	va_list args;
-	char *name;
+	int retval;
 
-	/* find out how big a buffer we need */
-	name = kmalloc(1024, GFP_KERNEL);
-	if (!name) {
-		error = -ENOMEM;
-		goto done;
-	}
 	va_start(args, fmt);
-	need = vsnprintf(name, 1024, fmt, args);
+	retval = kobject_set_name_vargs(kobj, fmt, args);
 	va_end(args);
-	kfree(name);
 
-	/* Allocate the new space and copy the string in */
-	limit = need + 1;
-	name = kmalloc(limit, GFP_KERNEL);
-	if (!name) {
-		error = -ENOMEM;
-		goto done;
-	}
-	va_start(args, fmt);
-	need = vsnprintf(name, limit, fmt, args);
-	va_end(args);
-
-	/* something wrong with the string we copied? */
-	if (need >= limit) {
-		kfree(name);
-		error = -EFAULT;
-		goto done;
-	}
-
-	/* Free the old name, if necessary. */
-	kfree(kobj->k_name);
-
-	/* Now, set the new name */
-	kobj->k_name = name;
-done:
-	return error;
+	return retval;
 }
 EXPORT_SYMBOL(kobject_set_name);
 
-- 
1.5.3.8

