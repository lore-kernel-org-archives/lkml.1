Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXKEMm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXKEMm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXKEMmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:42:51 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:53014 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbXKEMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:42:50 -0500
Date: Mon, 5 Nov 2007 13:42:03 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
Message-ID: <20071105134203.1c078136@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1194047972-9850-34-git-send-email-gregkh@suse.de>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-34-git-send-email-gregkh@suse.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2007 16:59:12 -0700,
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Add kobj_sysfs_ops to replace subsys_sysfs_ops. There is no
> need for special kset operations, we want to be able to use
> simple attribute operations at any kobject, not only ksets.
> 
> The whole concept of any default sysfs attribute operations
> will go away with the upcoming removal of subsys_sysfs_ops.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  include/linux/kobject.h |   10 ++++++++++
>  lib/kobject.c           |   29 +++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 0 deletions(-)

How about adding some simple wrappers around the new kobj_attribute
structure? This makes the layering clearer.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/linux/kobject.h |    7 ++++++-
 lib/kobject.c           |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/kobject.h
===================================================================
--- linux-2.6.orig/include/linux/kobject.h	2007-11-05 11:12:49.000000000 +0100
+++ linux-2.6/include/linux/kobject.h	2007-11-05 13:24:55.000000000 +0100
@@ -126,7 +126,12 @@ struct kobj_attribute {
 	ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
 			 const char *buf, size_t count);
 };
-
+#define KOBJ_ATTR(_name,_mode,_show,_store)		\
+	struct kobj_attribute kobj_attr_##_name =	\
+		__ATTR(_name,_mode,_show,_store)
+extern int __must_check kobject_create_file(struct kobject *,
+					    struct kobj_attribute *);
+extern void kobject_remove_file(struct kobject *,struct kobj_attribute *);
 extern struct sysfs_ops kobj_sysfs_ops;
 
 /**
Index: linux-2.6/lib/kobject.c
===================================================================
--- linux-2.6.orig/lib/kobject.c	2007-11-05 11:12:49.000000000 +0100
+++ linux-2.6/lib/kobject.c	2007-11-05 13:36:45.000000000 +0100
@@ -577,6 +577,28 @@ struct sysfs_ops kobj_sysfs_ops = {
 	.store	= kobj_attr_store,
 };
 
+/**
+ * kobject_create_file() - create an attribute file for a kobject
+ * @kobj: kobject the attribute is created for
+ * @attr: attribute to be created
+ */
+int kobject_create_file(struct kobject *kobj, struct kobj_attribute *attr)
+{
+	return sysfs_create_file(kobj, &attr->attr);
+}
+EXPORT_SYMBOL_GPL(kobject_create_file);
+
+/**
+ * kobject_remove_file() - remove an attribute file from a kobject
+ * @kobj: kobject the attribute is removed from
+ * @attr: attribute to be removed
+ */
+void kobject_remove_file(struct kobject *kobj, struct kobj_attribute *attr)
+{
+	sysfs_remove_file(kobj, &attr->attr);
+}
+EXPORT_SYMBOL_GPL(kobject_remove_file);
+
 static void dir_release(struct kobject *kobj)
 {
 	kfree(kobj);
