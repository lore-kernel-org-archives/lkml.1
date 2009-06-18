Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZFRARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZFRARd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZFRARY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:17:24 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50900 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZFRARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=swwd1+m0/FKMTxAc0bXp48d4rjQphzUdzGixulhFkqXD1rnGix+V9H6Fx8LsdMQmNI
         8kuUp4hJsjLz7AE+YPRHY0phToB5cCMg8sQLsdG8V90GSKWnnWenlPoPmS3qFENBIsWY
         aohsTEkVL0ymWCoNs0nEpZAKThMr64wX3ZyGA=
Date: Thu, 18 Jun 2009 02:17:21 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fs: fix overflow in sys_mount() for in-kernel calls
Message-ID: <20090618001721.GA14500@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c81d9980492c96cf693a76af6bfe4db0294fac70 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 18 Jun 2009 01:37:58 +0200
Subject: [PATCH] fs: fix overflow in sys_mount() for in-kernel calls

2009/6/17 Ingo Molnar <mingo@elte.hu> reported:
>
> btw., here's an old friend of a warning:
>
> async_continuing @ 1 after 0 usec
> WARNING: kmemcheck: Caught 8-bit read from freed memory (f5f33004)
> 0040f3f57400686f74706c756700000000000000000000000000000000000000
>  i i i i f f f f f f f f f f f f f f f f f f f f f f f f f f f f
>          ^
> 
> Pid: 1, comm: swapper Not tainted (2.6.30-tip-04303-g5ada65e-dirty #767) P4DC6
> EIP: 0060:[<c1248df4>] EFLAGS: 00010246 CPU: 0
> EIP is at exact_copy_from_user+0x64/0x130
> EAX: 00000000 EBX: 00000001 ECX: 000000f5 EDX: 000000f5
> ESI: f5fdeffb EDI: f5f33004 EBP: f6c48ee8 ESP: c29598cc
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: f6c20044 CR3: 0294d000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
>  [<c124916a>] copy_mount_options+0xba/0x1c0
>  [<c124dc0a>] sys_mount+0x1a/0x170
>  [<c263c937>] do_mount_root+0x27/0xe0
>  [<c263ca33>] mount_block_root+0x43/0x140
>  [<c263cc02>] mount_root+0xd2/0x160
>  [<c263ce49>] prepare_namespace+0x1b9/0x380
>  [<c263c4c8>] kernel_init+0xb8/0x110
>  [<c103ab13>] kernel_thread_helper+0x7/0x14
>  [<ffffffff>] 0xffffffff
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.

sys_mount() reads/copies a whole page for its "type" parameter. When
do_mount_root() passes a kernel address that points to an object
which is smaller than a whole page, copy_mount_options() will happily
go past this memory object, possibly dereferencing "wild" pointers
that could be in any state (hence the kmemcheck warning, which shows
that parts of the next page are not even allocated).

(The likelyhood of something going wrong here is pretty low -- first
of all this only applies to kernel calls to sys_mount(), which are
mostly found in the boot code. Secondly, I guess if the page was not
mapped, exact_copy_from_user() _would_ in fact handle it correctly
because of its access_ok(), etc. checks.)

But it is much nicer to avoid the dubious reads altogether, by
stopping as soon as we find a NUL byte. Is there a good reason why we
can't do something like this, using the already existing
strndup_from_user()?

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 fs/namespace.c |   77 ++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2dd333b..eb7fa90 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1620,7 +1620,7 @@ static int do_new_mount(struct path *path, char *type, int flags,
 {
 	struct vfsmount *mnt;
 
-	if (!type || !memchr(type, 0, PAGE_SIZE))
+	if (!type)
 		return -EINVAL;
 
 	/* we need capabilities... */
@@ -1851,6 +1851,23 @@ int copy_mount_options(const void __user * data, unsigned long *where)
 	return 0;
 }
 
+int copy_mount_string(const void __user *data, char **where)
+{
+	char *tmp;
+
+	if (!data) {
+		*where = NULL;
+		return 0;
+	}
+
+	tmp = strndup_user(data, PAGE_SIZE);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	*where = tmp;
+	return 0;
+}
+
 /*
  * Flags is a 32-bit value that allows up to 31 non-fs dependent flags to
  * be given to the mount() call (ie: read-only, no-dev, no-suid etc).
@@ -1880,8 +1897,6 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 
 	if (!dir_name || !*dir_name || !memchr(dir_name, 0, PAGE_SIZE))
 		return -EINVAL;
-	if (dev_name && !memchr(dev_name, 0, PAGE_SIZE))
-		return -EINVAL;
 
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
@@ -2022,40 +2037,42 @@ struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
 SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 		char __user *, type, unsigned long, flags, void __user *, data)
 {
-	int retval;
+	int ret;
+	char *kernel_type;
+	char *kernel_dir;
+	char *kernel_dev;
 	unsigned long data_page;
-	unsigned long type_page;
-	unsigned long dev_page;
-	char *dir_page;
 
-	retval = copy_mount_options(type, &type_page);
-	if (retval < 0)
-		return retval;
+	ret = copy_mount_string(type, &kernel_type);
+	if (ret < 0)
+		goto out_type;
 
-	dir_page = getname(dir_name);
-	retval = PTR_ERR(dir_page);
-	if (IS_ERR(dir_page))
-		goto out1;
+	kernel_dir = getname(dir_name);
+	if (IS_ERR(kernel_dir)) {
+		ret = PTR_ERR(kernel_dir);
+		goto out_dir;
+	}
 
-	retval = copy_mount_options(dev_name, &dev_page);
-	if (retval < 0)
-		goto out2;
+	ret = copy_mount_string(dev_name, &kernel_dev);
+	if (ret < 0)
+		goto out_dev;
 
-	retval = copy_mount_options(data, &data_page);
-	if (retval < 0)
-		goto out3;
+	ret = copy_mount_options(data, &data_page);
+	if (ret < 0)
+		goto out_data;
 
-	retval = do_mount((char *)dev_page, dir_page, (char *)type_page,
-			  flags, (void *)data_page);
-	free_page(data_page);
+	ret = do_mount(kernel_dev, kernel_dir, kernel_type, flags,
+		(void *) data_page);
 
-out3:
-	free_page(dev_page);
-out2:
-	putname(dir_page);
-out1:
-	free_page(type_page);
-	return retval;
+	free_page(data_page);
+out_data:
+	kfree(kernel_dev);
+out_dev:
+	putname(kernel_dir);
+out_dir:
+	kfree(kernel_type);
+out_type:
+	return ret;
 }
 
 /*
-- 
1.6.0.6

