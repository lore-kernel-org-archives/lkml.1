Return-Path: <linux-kernel-owner+w=401wt.eu-S935751AbYEUOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751AbYEUOuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbYEUOtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:49:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:40816 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151AbYEUOtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WRMhbbJHxU/iz2PrTZnKCizqMlB+FyuqYaEjL18+uTdcn5CtMQEKHpF1bnO32+P2a9kH2LoiBihabL/bOAD9pG1wOS/ffJxysqv7zogvI+7oSvrW7vXJlvvRRnax8TBlClf4jyHcafjtj5oeh4b9iT3NR/EC+/E6j8B1T611pak=
Message-ID: <7b9198260805210749k4903b432t3a92cd8bc8315a99@mail.gmail.com>
Date: Wed, 21 May 2008 15:49:51 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <7b9198260805201522u43befee7m5d1b02e030e1c993@mail.gmail.com>
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
	 <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
	 <20080520220029.GR2638@parisc-linux.org>
	 <7b9198260805201522u43befee7m5d1b02e030e1c993@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Tom Spink <tspink@gmail.com>:
> 2008/5/20 Matthew Wilcox <matthew@wil.cx>:
>> On Tue, May 20, 2008 at 10:08:04PM +0100, Tom Spink wrote:
>>> I've taken some more time to go over the locking semantics.  I wrote a
>>> quick toy filesystem to simulate delays, blocking, memory allocation,
>>> etc in the init and exit routines - and with an appropriately large
>>> amount of printk's everywhere, I saw a quite a few interleavings.
>>>
>>> I *think* I may have got it right, but please, let me know what you
>>> think!  The only thing that I think may be wrong with this patch is
>>> the
>>> spin_lock/unlock at the end of sget, where the superblock is
>>> list_add_tailed into the super_blocks list.  I believe this opens the
>>> possibility for the same superblock being list_add_tailed twice... can
>>> anyone else see this code-path, and is it a problem?
>>
>> Hi Tom,
>
> Hi Matthew,
>
>> I spotted one definite bug; on failure, you leave the superblock on
>> the super_blocks list.
>
> I spotted this while I was coding, and I was careful not to let it get
> added to the list...  If the ->init routine fails, the superblock
> hasn't even been added to the list yet.  The patch moves this line:
>
> list_add_tail(&s->s_list, &super_blocks);
>
> Down to after the ->init call.
>
>> Your locking may well be correct, but it has the hallmarks of being "a bit
>> tricky" and a bit tricky means potentially buggy.  How about doing the
>> nesting the other way round, ie take the mutex first, then the spinlock?
>
> Thanks for the suggestion!
>
>> The code needs a bit of tweaking because you don't want to put the
>> superblock on any list where it can be found until it's fully
>> initialised.  This may not be quite right:
>>
>>> +     mutex_lock(&type->fs_supers_lock);
>>>       spin_lock(&sb_lock);
>>>       /* should be initialized for __put_super_and_need_restart() */
>>>       list_del_init(&sb->s_list);
>>>       list_del(&sb->s_instances);
>>>       spin_unlock(&sb_lock);
>>> +
>>> +     if (list_empty(&type->fs_supers) && type->exit)
>>> +             type->exit();
>>> +     mutex_unlock(&type->fs_supers_lock);
>>> +
>>>       up_write(&sb->s_umount);
>>>  }
>>>
>
> I'll definitely give it a go.
>
>> sget is a little more complex ... the fs_supers_lock would need to be
>> dropped in a lot more places than I've shown here:
>>
>> @@ -365,11 +372,31 @@ retry:
>>  retry:
>> +       mutex_lock(&type->fs_supers_lock);
>>        spin_lock(&sb_lock);
>>
>>                destroy_super(s);
>>                return ERR_PTR(err);
>>        }
>>        s->s_type = type;
>>        strlcpy(s->s_id, type->name, sizeof(s->s_id));
>> +       if (list_empty(&type->fs_supers) && type->init) {
>> +               spin_unlock(&sb_lock);
>> +               err = type->init();
>> +               if (err) {
>> +                       mutex_unlock(&type->fs_supers_lock);
>> +                       destroy_super(s);
>> +                       return ERR_PTR(err);
>> +               }
>> +               spin_lock(&sb_lock);
>> +       }
>>        list_add_tail(&s->s_list, &super_blocks);
>>        list_add(&s->s_instances, &type->fs_supers);
>>        spin_unlock(&sb_lock);
>> +       mutex_unlock(&type->fs_supers_lock);
>>        get_filesystem(type);
>>        return s;
>> }
>
> I had something similar earlier, but I thought it started to look
> slightly messy when I discovered that dropping the spinlock would lead
> to a racey ->init... but I hadn't thought of putting the mutex outside
> the spinlock; the mutex protecting ->init and ->exit (I was getting
> caught up in trying not to go to sleep inside a spinlock)
>
> Thanks!
> --
> Tom Spink
>

Ready for another?  <g>

Here's another try, with Matthews suggestion of moving the mutex
outside the spinlock.  Again, I've used a wee stress test that tries
to mount a toy filesystem many times, with random pauses in the init
routines.  It seems to pass this (and again I've seen quite a few
interleavings of the calls), and a mental scan of the code paths leads
me to believe the locking is correct.

Thanks for putting up with me, guys!

-- Tom

--

From: Tom Spink <tspink@gmail.com>
Date: Wed, 21 May 2008 13:29:07 +0100
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
 fs/super.c         |   29 ++++++++++++++++++++++++++++-
 include/linux/fs.h |    3 +++
 3 files changed, 33 insertions(+), 1 deletions(-)

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
index 453877c..65252c2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -287,7 +287,9 @@ int fsync_super(struct super_block *sb)
 void generic_shutdown_super(struct super_block *sb)
 {
 	const struct super_operations *sop = sb->s_op;
+	struct file_system_type *type = sb->s_type;

+	mutex_lock(&type->fs_supers_lock);
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
 		fsync_super(sb);
@@ -317,7 +319,12 @@ void generic_shutdown_super(struct super_block *sb)
 	list_del_init(&sb->s_list);
 	list_del(&sb->s_instances);
 	spin_unlock(&sb_lock);
+
+	if (list_empty(&type->fs_supers) && type->exit)
+		type->exit();
+	
 	up_write(&sb->s_umount);
+	mutex_unlock(&type->fs_supers_lock);
 }

 EXPORT_SYMBOL(generic_shutdown_super);
@@ -338,6 +345,7 @@ struct super_block *sget(struct file_system_type *type,
 	struct super_block *old;
 	int err;

+	mutex_lock(&type->fs_supers_lock);
 retry:
 	spin_lock(&sb_lock);
 	if (test) {
@@ -348,14 +356,17 @@ retry:
 				goto retry;
 			if (s)
 				destroy_super(s);
+			mutex_unlock(&type->fs_supers_lock);
 			return old;
 		}
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
 		s = alloc_super(type);
-		if (!s)
+		if (!s) {
+			mutex_unlock(&type->fs_supers_lock);
 			return ERR_PTR(-ENOMEM);
+		}
 		goto retry;
 	}
 		
@@ -363,14 +374,30 @@ retry:
 	if (err) {
 		spin_unlock(&sb_lock);
 		destroy_super(s);
+		mutex_unlock(&type->fs_supers_lock);
 		return ERR_PTR(err);
 	}
+
+	if (list_empty(&type->fs_supers) && type->init) {
+		spin_unlock(&sb_lock);
+		err = type->init();
+		if (err < 0) {
+			destroy_super(s);
+			mutex_unlock(&type->fs_supers_lock);
+			return ERR_PTR(err);
+		}
+		spin_lock(&sb_lock);
+	}
+
 	s->s_type = type;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
+
 	list_add_tail(&s->s_list, &super_blocks);
 	list_add(&s->s_instances, &type->fs_supers);
+
 	spin_unlock(&sb_lock);
 	get_filesystem(type);
+	mutex_unlock(&type->fs_supers_lock);
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
