Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbXBOWCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbXBOWCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXBOWCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:02:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391AbXBOWCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:02:36 -0500
Date: Thu, 15 Feb 2007 14:02:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.20-mm1
Message-Id: <20070215140232.0aba86a7.akpm@linux-foundation.org>
In-Reply-To: <45D47020.1010309@googlemail.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D47020.1010309@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 15:37:20 +0100
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton napisa__(a):
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> > 
> > Will appear later at
> > 
> >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/
> > 
> > 
> 
> BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/mm/slab.c:3043
> in_atomic():1, irqs_disabled():0
> 1 lock held by artsd/3819:
>  #0:  (&new->lock){--..}, at: [<c01d5b7c>] ipc_lock+0x35/0x4f
>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
>  [<c0105a25>] show_trace+0x12/0x14
>  [<c0105ae7>] dump_stack+0x16/0x18
>  [<c011db4a>] __might_sleep+0xc9/0xcf
>  [<c017c37a>] kmem_cache_zalloc+0x28/0xe5
>  [<c01d8c7d>] do_shmat+0x111/0x372
>  [<c0109151>] sys_ipc+0x148/0x1b5
>  [<c010432c>] syscall_call+0x7/0xb

That's shm-make-sysv-ipc-shared-memory-use-stacked-files.patch, brought to
us by Eric-who-hasnt-read-Documentation/SubmitChecklist.

Like this, I guess:

diff -puN ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-fix ipc/shm.c
--- a/ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-fix
+++ a/ipc/shm.c
@@ -818,7 +818,7 @@ long do_shmat(int shmid, char __user *sh
 	int acc_mode;
 	void *user_addr;
 	struct ipc_namespace *ns;
-	struct shm_file_data *sfd;
+	struct shm_file_data *sfd = NULL;
 	mode_t f_mode;
 
 	if (shmid < 0) {
@@ -856,6 +856,8 @@ long do_shmat(int shmid, char __user *sh
 		acc_mode |= S_IXUGO;
 	}
 
+	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
+
 	/*
 	 * We cannot rely on the fs check since SYSV IPC does have an
 	 * additional creator id...
@@ -879,13 +881,12 @@ long do_shmat(int shmid, char __user *sh
 		goto out_unlock;
 
 	err = -ENOMEM;
-	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
 	if (!sfd)
 		goto out_unlock;
 
 	file = get_empty_filp();
 	if (!file)
-		goto out_free;
+		goto out_unlock;
 
 	file->f_op = &shm_file_operations;
 	file->private_data = sfd;
@@ -939,9 +940,8 @@ invalid:
 	if (IS_ERR(user_addr))
 		err = PTR_ERR(user_addr);
 out:
-	return err;
-out_free:
 	kfree(sfd);
+	return err;
 out_unlock:
 	shm_unlock(shp);
 	goto out;
_

