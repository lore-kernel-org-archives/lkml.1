Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0BKXV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:21:58 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33899 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0BKXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:21:57 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] sysfs: Use one lockdep class per sysfs attribute.
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
	<m1ljezwean.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 15:21:53 -0800
In-Reply-To: <m1ljezwean.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 11 Feb 2010 15\:20\:00 -0800")
Message-ID: <m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acknowledge that the logical sysfs rwsem has one instance per
sysfs attribute with different locking depencencies for different
attributes.

There is a sysfs idiom where writing to one sysfs file causes the
addition or removal of other sysfs files.   Lumping all of the
sysfs attributes together in one lock class causes lockdep to
generate lots of false positives.

This introduces the requirement that non-static sysfs attributes
need to be initialized with sysfs_attr_init or sysfs_bin_attr_init.
Strictly speaking this requirement only exists when lockdep is
enabled, and when lockdep is enabled we get a bit fat warning
if this requirement is not met.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/sysfs.h      |    7 +++++--
 include/linux/sysfs.h |   18 ++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 7db6884..37e0e08 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -92,9 +92,12 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define sysfs_dirent_init_lockdep(sd)				\
 do {								\
-	static struct lock_class_key __key;			\
+	struct attribute *attr = sd->s_attr.attr;		\
+	struct lock_class_key *key = attr->key;			\
+	if (!key)						\
+		key = &attr->skey;				\
 								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
+	lockdep_init_map(&sd->dep_map, "s_active", key, 0);	\
 } while(0)
 #else
 #define sysfs_dirent_init_lockdep(sd) do {} while(0)
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cfa8308..c3048de 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <asm/atomic.h>
 
 struct kobject;
@@ -29,8 +30,23 @@ struct attribute {
 	const char		*name;
 	struct module		*owner;
 	mode_t			mode;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key	*key;
+	struct lock_class_key	skey;
+#endif
 };
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define sysfs_attr_init(attr)				\
+do {							\
+	static struct lock_class_key __key;		\
+							\
+	(attr)->key = &__key;				\
+} while(0)
+#else
+#define sysfs_attr_init(attr) do {} while(0)
+#endif
+
 struct attribute_group {
 	const char		*name;
 	mode_t			(*is_visible)(struct kobject *,
@@ -74,6 +90,8 @@ struct bin_attribute {
 		    struct vm_area_struct *vma);
 };
 
+#define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&bin_attr->attr)
+
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
-- 
1.6.5.2.143.g8cc62

