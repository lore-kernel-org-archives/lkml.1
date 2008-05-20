Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbYETVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbYETVIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbYETVIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:08:10 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:34853 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761338AbYETVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x+XWPflk1Dn2H7XWBzl2YTPr8Pd0SF+xBW1js6+rEMumqq4+Ejozixuu14rB6/Y6MQy3XFytUrvIHPhELQ2VkSLk3pQ8zigTjgJjTwRWaUQ6cRI3Zz93bOT0PS2a/D7NBlWy5rcawbMx9EMjkE9t9uCoHlRkRdSQt6tJytMvL4o=
Message-ID: <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
Date: Tue, 20 May 2008 22:08:04 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <7b9198260805200836q6b9ad5f0x3b42c8f6c933fa21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211196126-7442-1-git-send-email-tspink@gmail.com>
	 <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
	 <20080520134306.GA28946@ZenIV.linux.org.uk>
	 <20080520135732.GA30349@infradead.org>
	 <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
	 <20080520153456.GN2638@parisc-linux.org>
	 <7b9198260805200836q6b9ad5f0x3b42c8f6c933fa21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Tom Spink <tspink@gmail.com>:
> 2008/5/20 Matthew Wilcox <matthew@wil.cx>:
>> On Tue, May 20, 2008 at 04:18:14PM +0100, Tom Spink wrote:
>>> +
>>> +     mutex_lock(&type->fs_supers_lock);
>>> +     if (list_empty(&type->fs_supers) && type->init) {
>>> +             err = type->init();
>>> +             if (err) {
>>> +                     mutex_unlock(&type->fs_supers_lock);
>>> +                     spin_unlock(&sb_lock);
>>> +                     destroy_super(s);
>>> +                     return ERR_PTR(err);
>>> +             }
>>> +     }
>>> +
>>> +     list_add(&s->s_instances, &type->fs_supers);
>>> +     mutex_unlock(&type->fs_supers_lock);
>>> +
>>>       s->s_type = type;
>>>       strlcpy(s->s_id, type->name, sizeof(s->s_id));
>>>       list_add_tail(&s->s_list, &super_blocks);
>>> -     list_add(&s->s_instances, &type->fs_supers);
>>> +
>>>       spin_unlock(&sb_lock);
>>
>> You can't take a mutex while holding a spinlock -- what if you had to
>> sleep to acquire the mutex?
>>
>> I imagine you also don't want to hold a spinlock while calling the
>> ->init or ->exit -- what if the fs wants to sleep in there (eg allocate
>> memory with GFP_KERNEL).
>>
>> --
>> Intel are signing my paycheques ... these opinions are still mine
>> "Bill, look, we understand that you're interested in selling us this
>> operating system, but compare it to ours.  We can't possibly take such
>> a retrograde step."
>>
>
> Oh no!  This is bad.  I really need to devise some script to stress
> test my code - and also make myself pay attention to what I'm doing.
> Sorry for the noise, guys.
>
> --
> Tom Spink
>

Hi Guys,

I've taken some more time to go over the locking semantics.  I wrote a
quick toy filesystem to simulate delays, blocking, memory allocation,
etc in the init and exit routines - and with an appropriately large
amount of printk's everywhere, I saw a quite a few interleavings.

I *think* I may have got it right, but please, let me know what you
think!  The only thing that I think may be wrong with this patch is
the
spin_lock/unlock at the end of sget, where the superblock is
list_add_tailed into the super_blocks list.  I believe this opens the
possibility for the same superblock being list_add_tailed twice... can
anyone else see this code-path, and is it a problem?

---

From: Tom Spink <tspink@gmail.com>
Date: Tue, 20 May 2008 16:04:51 +0100
Subject: [PATCH] Introduce on-demand filesystem initialisation

This patch adds on-demand filesystem initialisation capabilities to the VFS,
whereby an init routine will be executed on first use of a particular
filesystem type.  Also, an exit routine will be executed when the last
superblock of a filesystem type is deactivated.

This is useful for filesystems that share global resources between all
instances of the filesystem, but only need those resources when there are
any users of the filesystem.  This lets the filesystem initialise those
resources (kernel threads or caches, say) when the first superblock is
created.  It also lets the filesystem clean up those resources when the
last superblock is deactivated.

Signed-off-by: Tom Spink <tspink@gmail.com>
---
 fs/filesystems.c   |    2 ++
 fs/super.c         |   31 +++++++++++++++++++++++++++++--
 include/linux/fs.h |    3 +++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..59b2eaa 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -79,6 +79,7 @@ int register_filesystem(struct file_system_type * fs)
 		res = -EBUSY;
 	else
 		*p = fs;
+	mutex_init(&fs->fs_supers_lock);
 	write_unlock(&file_systems_lock);
 	return res;
 }
@@ -105,6 +106,7 @@ int unregister_filesystem(struct file_system_type * fs)
 	tmp = &file_systems;
 	while (*tmp) {
 		if (fs == *tmp) {
+			mutex_destroy(&fs->fs_supers_lock);
 			*tmp = fs->next;
 			fs->next = NULL;
 			write_unlock(&file_systems_lock);
diff --git a/fs/super.c b/fs/super.c
index 453877c..7625a90 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -287,6 +287,7 @@ int fsync_super(struct super_block *sb)
 void generic_shutdown_super(struct super_block *sb)
 {
 	const struct super_operations *sop = sb->s_op;
+	struct file_system_type *type = sb->s_type;

 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
@@ -315,8 +316,14 @@ void generic_shutdown_super(struct super_block *sb)
 	spin_lock(&sb_lock);
 	/* should be initialized for __put_super_and_need_restart() */
 	list_del_init(&sb->s_list);
-	list_del(&sb->s_instances);
 	spin_unlock(&sb_lock);
+
+	mutex_lock(&type->fs_supers_lock);
+	list_del(&sb->s_instances);
+	if (list_empty(&type->fs_supers) && type->exit)
+		type->exit();
+	mutex_unlock(&type->fs_supers_lock);
+	
 	up_write(&sb->s_umount);
 }

@@ -365,11 +372,31 @@ retry:
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
+	
 	s->s_type = type;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
-	list_add_tail(&s->s_list, &super_blocks);
+
+	spin_unlock(&sb_lock);
+
+	mutex_lock(&type->fs_supers_lock);
+	if (list_empty(&type->fs_supers) && type->init) {
+		err = type->init();
+		if (err) {
+			mutex_unlock(&type->fs_supers_lock);
+			destroy_super(s);
+
+			if (err < 0)
+				return ERR_PTR(err);
+		}
+	}
+	
 	list_add(&s->s_instances, &type->fs_supers);
+	mutex_unlock(&type->fs_supers_lock);
+
+	spin_lock(&sb_lock);
+	list_add_tail(&s->s_list, &super_blocks);
 	spin_unlock(&sb_lock);
+	
 	get_filesystem(type);
 	return s;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f413085..92d446f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1477,8 +1477,11 @@ struct file_system_type {
 	int (*get_sb) (struct file_system_type *, int,
 		       const char *, void *, struct vfsmount *);
 	void (*kill_sb) (struct super_block *);
+	int (*init) (void);
+	void (*exit) (void);
 	struct module *owner;
 	struct file_system_type * next;
+	struct mutex fs_supers_lock;
 	struct list_head fs_supers;

 	struct lock_class_key s_lock_key;
-- 
1.5.4.3
