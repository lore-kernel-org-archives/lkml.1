Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYH1QjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYH1QjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYH1QjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:39:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:39637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYH1QjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:39:02 -0400
Message-ID: <48B6D428.2020308@kernel.org>
Date: Thu, 28 Aug 2008 18:36:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] char_dev: add cdev->release() and convert cdev_alloc()
 to use it
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 16:38:11 +0000 (UTC)
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
This one is also for CUSE.  Oops, forgot lkml.  Resending.  Thanks.

 fs/char_dev.c        |   30 +++++++++++++-----------------
 include/linux/cdev.h |    1 +
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 3cb7cda..3d50199 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -478,26 +478,22 @@ void cdev_del(struct cdev *p)
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
@@ -506,10 +502,10 @@ static struct kobj_type ktype_cdev_dynamic = {
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
@@ -526,7 +522,7 @@ void cdev_init(struct cdev *cdev, const struct file_operations *fops)
 {
 	memset(cdev, 0, sizeof *cdev);
 	INIT_LIST_HEAD(&cdev->list);
-	kobject_init(&cdev->kobj, &ktype_cdev_default);
+	kobject_init(&cdev->kobj, &cdev_ktype);
 	cdev->ops = fops;
 }
 
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index fb45919..9c3b17e 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -16,6 +16,7 @@ struct cdev {
 	struct list_head list;
 	dev_t dev;
 	unsigned int count;
+	void (*release)(struct cdev *);
 };
 
 void cdev_init(struct cdev *, const struct file_operations *);
-- 
1.5.4.5

