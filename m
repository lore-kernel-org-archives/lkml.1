Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbYETPSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbYETPSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbYETPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:18:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:21247 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066AbYETPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LNmn1VOafoRBOHvvUhcYnldlD8LJxnYSMhIS2JjqUOtKu+BUOSHKDZVyia+PtaQX0RiSQxYPEtS7wRLgOP6R/gyGXSwh2MiBRhWfP04g4vixitFl80JfcIuEyiJL4eZcbMs8/QgjRXAetDZVc0ru4H52TwsA2O0E2C5ln/LryRY=
Message-ID: <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
Date: Tue, 20 May 2008 16:18:14 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080520135732.GA30349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211196126-7442-1-git-send-email-tspink@gmail.com>
	 <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
	 <20080520134306.GA28946@ZenIV.linux.org.uk>
	 <20080520135732.GA30349@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Christoph Hellwig <hch@infradead.org>:
> On Tue, May 20, 2008 at 02:43:06PM +0100, Al Viro wrote:
>> No, you have not and no, doing that anywhere near that layer is hopeless.
>>
>>       a) Instances of filesystem can easily outlive all vfsmounts,
>> let alone their attachment to namespaces.
>>       b) What should happen if init is done in the middle of exit?
>>       c) Why do we need to bother, anyway?
>
> We had a discussion about filesystems starting threads without an
> active instance.  I suggested tracking instances and add ->init / ->exit
> methods to struct file_system_type for these kinds of instances.
>
> But we should track superblock instances, not vfsmount instances of
> course.  Tom, you probably don't even need a counter, emptyness
> of file_system_type.fs_supers should be indication enough.  And yes
> we'd need locking to prevent init racing with exit.
>
>

Hi Guys,

Thanks for looking!  So I've had another go - this time taking the
superblock approach, and hopefully I've got the locking right too.
Let me know what you think (or if I'm still barking up the wrong
tree)!

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
 fs/super.c         |   22 +++++++++++++++++++++-
 include/linux/fs.h |    3 +++
 3 files changed, 26 insertions(+), 1 deletions(-)

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
index 453877c..e3a3186 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -184,6 +184,11 @@ void deactivate_super(struct super_block *s)
 		fs->kill_sb(s);
 		put_filesystem(fs);
 		put_super(s);
+
+		mutex_lock(&fs->fs_supers_lock);
+		if (list_empty(&fs->fs_supers) && fs->exit)
+			fs->exit();
+		mutex_unlock(&fs->fs_supers_lock);
 	}
 }

@@ -365,10 +370,25 @@ retry:
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
+	
+	mutex_lock(&type->fs_supers_lock);
+	if (list_empty(&type->fs_supers) && type->init) {
+		err = type->init();
+		if (err) {
+			mutex_unlock(&type->fs_supers_lock);
+			spin_unlock(&sb_lock);
+			destroy_super(s);
+			return ERR_PTR(err);
+		}
+	}
+	
+	list_add(&s->s_instances, &type->fs_supers);
+	mutex_unlock(&type->fs_supers_lock);
+
 	s->s_type = type;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
-	list_add(&s->s_instances, &type->fs_supers);
+	
 	spin_unlock(&sb_lock);
 	get_filesystem(type);
 	return s;
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
