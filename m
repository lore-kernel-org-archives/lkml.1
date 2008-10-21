Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbYJUFKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbYJUFKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYJUFJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:09:59 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:49572 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYJUFJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:09:58 -0400
Message-ID: <48FD641B.80406@nttdata.co.jp>
Date: Tue, 21 Oct 2008 14:09:47 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@zeniv.linux.org.uk, hch@lst.de, crispin@crispincowan.com,
       casey@schaufler-ca.com
Subject: Re: [TOMOYO #11 (linux-next) 01/11] Introduce new LSM hooks where
 vfsmount is available.
References: <20081020073423.024299308@nttdata.co.jp> <20081020073643.986810046@nttdata.co.jp> <E1Krxrj-0001r8-7t@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Krxrj-0001r8-7t@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2008 05:09:49.0159 (UTC) FILETIME=[3DE9CF70:01C9333B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> (6) Introducing new LSM hooks.
>>  (this patch)
>>
>>  We understand that adding new LSM hooks which receive "struct
>>  vfsmount" outside VFS helper functions is the most straightforward
>>  approach. This approach has less impact to existing LSM module and
>>  no impact to VFS helper functions.
> 
> AppArmor will need a few additional hooks, but the ones added by this
> patch look OK.  One thing I'd prefer is if there were two different
> hooks for truncate and ftruncate:
> 
>    int (*path_truncate) (struct path *path, ...);
> 
> and
> 
>    int (*file_truncate) (struct file *file, ...);
When you submit AppArmor, you can introduce security_file_truncate() 
and replace security_path_truncate() with security_file_truncate() 
since TOMOYO can get "struct path *path" from 
"struct file *file"->f_path .

> security_path_truncate() is missing from do_coredump() in exec.c.  Is
> this intentional?
Yes.
TOMOYO checks only requests from userspace, not from kernel (e.g. 
filesystem). Since do_coredump() performs request from kernel, we 
don't insert security_path_truncate() in do_coredump() .

> Also seems to be missing:
> 
>  - security_path_mknod() from do_create() in ipc/mqueue.c
TOMOYO doesn't check IPC for now.

>  - security_path_mknod() from unix_bind() in net/unix/af_unix.c
There is security_path_mknod() call in unix_bind(). Please see below.
;-)

--- linux-next.orig/net/unix/af_unix.c
+++ linux-next/net/unix/af_unix.c
@@ -828,7 +828,12 @@ static int unix_bind(struct socket *sock
 		err = mnt_want_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
+		err = security_path_mknod(&nd.path, dentry, mode, 0);
+		if (err)
+			goto out_mknod_drop_write;
 		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
+		security_path_clear();
+out_mknod_drop_write:
 		mnt_drop_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;

>  - security_path_unlink() from sys_mq_unlink() in ipc/mqueue.c
Same reason as security_path_mknod() from do_create() in ipc/mqueue.c .

> The hooks are also not called from nfsd, I presume that's intentional?
Same reason as do_coredump() . Requests from nfsd are not from 
userspace.

Since AppArmor checks both reqests from userspace and kernel, 
AppArmor will need to insert security_path_*() to more locations. 
Then TOMOYO will want a mechanism for dinstinguishing requests from 
userspace and ones from kernel.

>> (6.1) Introducing security_path_clear() hook.
>>  (this patch)
>>
>>  To perform DAC performed in vfs_foo() before MAC, we let
>>  security_path_foo() save a result into our own hash table and
>>  return 0, and let security_inode_foo() return the saved
>>  result. Since security_inode_foo() is not always called after
>>  security_path_foo(), we need security_path_clear() to clear the
>>  hash table.
> 
> This is not a good interface, IMO.  It's easy to forget (e.g. two
> places in open.c), and hard to detect.
> 
> And is it necessary at all?  Saving the result in the per-task
> security context and destroying it at exit should be an equivalent
> solution.
Though current kernel has current->security, CRED patchset by David moves 
security field from current to current->cred . Since current->cred is shared by 
multiple processes, we'll not be able to implement per-task security. Please see 
http://lkml.org/lkml/2008/10/2/7 in detail.

Regards,

