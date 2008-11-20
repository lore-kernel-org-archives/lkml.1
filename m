Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbYKTLqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbYKTLqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYKTLp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:45:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:36063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYKTLp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:45:56 -0500
Message-ID: <49254DE0.8040002@kernel.org>
Date: Thu, 20 Nov 2008 20:45:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH RESEND] char_dev: add cdev->release() and convert cdev_alloc()
 to use it
References: <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com> <491BEC4E.9030505@kernel.org> <492136F5.8010903@kernel.org> <20081117171717.GB31306@kroah.com> <49221CE8.1050402@kernel.org> <49221D23.8040904@kernel.org> <4922C6BB.5020203@panasas.com> <4922E622.50401@kernel.org> <20081120055450.GA10821@kroah.com> <4925039E.8020907@kernel.org>
In-Reply-To: <4925039E.8020907@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 11:45:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cdev->release() so that cdev can be considered in more involved
object lifetime management.  cdev_alloc() used a separate ktype for
auto-free release().  This patch converts it to use cdev->release() so
that there's no need for separate ktype and cdev_init() can be used
for auto-free variant too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/char_dev.c        |   30 +++++++++++++-----------------
 include/linux/cdev.h |    1 +
 2 files changed, 14 insertions(+), 17 deletions(-)

Index: work/fs/char_dev.c
===================================================================
--- work.orig/fs/char_dev.c
+++ work/fs/char_dev.c
@@ -482,26 +482,22 @@ void cdev_del(struct cdev *p)
 }
 
 
-static void cdev_default_release(struct kobject *kobj)
+static void cdev_release(struct kobject *kobj)
 {
 	struct cdev *p = container_of(kobj, struct cdev, kobj);
 	cdev_purge(p);
+	if (p->release)
+		p->release(p);
 }
 
-static void cdev_dynamic_release(struct kobject *kobj)
-{
-	struct cdev *p = container_of(kobj, struct cdev, kobj);
-	cdev_purge(p);
-	kfree(p);
-}
-
-static struct kobj_type ktype_cdev_default = {
-	.release	= cdev_default_release,
+static struct kobj_type cdev_ktype = {
+	.release	= cdev_release,
 };
 
-static struct kobj_type ktype_cdev_dynamic = {
-	.release	= cdev_dynamic_release,
-};
+static void cdev_alloc_release(struct cdev *cdev)
+{
+	kfree(cdev);
+}
 
 /**
  * cdev_alloc() - allocate a cdev structure
@@ -510,10 +506,10 @@ static struct kobj_type ktype_cdev_dynam
  */
 struct cdev *cdev_alloc(void)
 {
-	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
+	struct cdev *p = kmalloc(sizeof(struct cdev), GFP_KERNEL);
 	if (p) {
-		INIT_LIST_HEAD(&p->list);
-		kobject_init(&p->kobj, &ktype_cdev_dynamic);
+		cdev_init(p, NULL);
+		p->release = cdev_alloc_release;
 	}
 	return p;
 }
@@ -530,7 +526,7 @@ void cdev_init(struct cdev *cdev, const
 {
 	memset(cdev, 0, sizeof *cdev);
 	INIT_LIST_HEAD(&cdev->list);
-	kobject_init(&cdev->kobj, &ktype_cdev_default);
+	kobject_init(&cdev->kobj, &cdev_ktype);
 	cdev->ops = fops;
 }
 
Index: work/include/linux/cdev.h
===================================================================
--- work.orig/include/linux/cdev.h
+++ work/include/linux/cdev.h
@@ -16,6 +16,7 @@ struct cdev {
 	struct list_head list;
 	dev_t dev;
 	unsigned int count;
+	void (*release)(struct cdev *);
 };
 
 void cdev_init(struct cdev *, const struct file_operations *);
