Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0BOKdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 05:33:22 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:40494 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab0BOKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 05:33:20 -0500
X-Greylist: delayed 7071 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 05:33:20 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IdDD7K6ZsjM0c7zVqGpoXFn8q+N3fCTklBSUiBdSUjntKuUz3Pq7EqF50v/TDqdn4F
         6+29awH2LW5frsOAxvcUVPjU1vN5i44gqm+6u7xkYJpTZ/fw3wtudhZR1HZqSbnYP3LK
         Rw9OaVR/qUuRBOzHfkJwfWc8XtcASpZDN1gxU=
Date: Mon, 15 Feb 2010 18:35:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] sysfs: Use one lockdep class per sysfs attribute.
Message-ID: <20100215103557.GJ12076@hack.private>
References: <m1vde57c11.fsf@fess.ebiederm.org> <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org> <20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org> <4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org> <m14olnxt3s.fsf_-_@fess.ebiederm.org> <m1ljezwean.fsf_-_@fess.ebiederm.org> <m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:21:53PM -0800, Eric W. Biederman wrote:
>
>Acknowledge that the logical sysfs rwsem has one instance per
>sysfs attribute with different locking depencencies for different
>attributes.
>
>There is a sysfs idiom where writing to one sysfs file causes the
>addition or removal of other sysfs files.   Lumping all of the
>sysfs attributes together in one lock class causes lockdep to
>generate lots of false positives.
>
>This introduces the requirement that non-static sysfs attributes
>need to be initialized with sysfs_attr_init or sysfs_bin_attr_init.
>Strictly speaking this requirement only exists when lockdep is
>enabled, and when lockdep is enabled we get a bit fat warning
>if this requirement is not met.

Since there are fewer non-static attributes, this will not
waste much space.

>
>Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> fs/sysfs/sysfs.h      |    7 +++++--
> include/linux/sysfs.h |   18 ++++++++++++++++++
> 2 files changed, 23 insertions(+), 2 deletions(-)
>
>diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
>index 7db6884..37e0e08 100644
>--- a/fs/sysfs/sysfs.h
>+++ b/fs/sysfs/sysfs.h
>@@ -92,9 +92,12 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
> #ifdef CONFIG_DEBUG_LOCK_ALLOC
> #define sysfs_dirent_init_lockdep(sd)				\
> do {								\
>-	static struct lock_class_key __key;			\
>+	struct attribute *attr = sd->s_attr.attr;		\
>+	struct lock_class_key *key = attr->key;			\
>+	if (!key)						\
>+		key = &attr->skey;				\
> 								\
>-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
>+	lockdep_init_map(&sd->dep_map, "s_active", key, 0);	\
> } while(0)
> #else
> #define sysfs_dirent_init_lockdep(sd) do {} while(0)
>diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
>index cfa8308..c3048de 100644
>--- a/include/linux/sysfs.h
>+++ b/include/linux/sysfs.h
>@@ -15,6 +15,7 @@
> #include <linux/compiler.h>
> #include <linux/errno.h>
> #include <linux/list.h>
>+#include <linux/lockdep.h>
> #include <asm/atomic.h>
> 
> struct kobject;
>@@ -29,8 +30,23 @@ struct attribute {
> 	const char		*name;
> 	struct module		*owner;
> 	mode_t			mode;
>+#ifdef CONFIG_DEBUG_LOCK_ALLOC
>+	struct lock_class_key	*key;
>+	struct lock_class_key	skey;
>+#endif
> };
> 
>+#ifdef CONFIG_DEBUG_LOCK_ALLOC
>+#define sysfs_attr_init(attr)				\
>+do {							\
>+	static struct lock_class_key __key;		\
>+							\
>+	(attr)->key = &__key;				\
>+} while(0)
>+#else
>+#define sysfs_attr_init(attr) do {} while(0)
>+#endif
>+
> struct attribute_group {
> 	const char		*name;
> 	mode_t			(*is_visible)(struct kobject *,
>@@ -74,6 +90,8 @@ struct bin_attribute {
> 		    struct vm_area_struct *vma);
> };
> 
>+#define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&bin_attr->attr)
>+
> struct sysfs_ops {
> 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
> 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
>-- 
>1.6.5.2.143.g8cc62
>

-- 
Live like a child, think like the god.
 
