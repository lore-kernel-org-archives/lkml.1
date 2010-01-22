Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852Ab0AVLtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0AVLtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827Ab0AVLtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:49:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab0AVLtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:49:24 -0500
Date: Fri, 22 Jan 2010 06:45:28 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH UPDATED 38/40] cifs: use workqueue instead of slow-work
Message-ID: <20100122064528.0223d708@tlielax.poochiereds.net>
In-Reply-To: <4B59889D.7050903@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-39-git-send-email-tj@kernel.org>
	<20100119072000.247ac894@tlielax.poochiereds.net>
	<4B564B12.7020909@kernel.org>
	<20100119195641.7b6a17e4@tlielax.poochiereds.net>
	<4B565B26.3060709@kernel.org>
	<4B59889D.7050903@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 20:14:37 +0900
Tejun Heo <tj@kernel.org> wrote:

> Workqueue can now handle high concurrency.  Use system_single_wq
> instead of slow-work.
> 
> * Updated is_valid_oplock_break() to not call cifs_oplock_break_put()
>   as advised by Steve French.  It might cause deadlock.  Instead,
>   reference is increased after queueing succeeded and
>   cifs_oplock_break() briefly grabs GlobalSMBSeslock before putting
>   the cfile to make sure it doesn't put before the matching get is
>   finished.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> ---
> Another approach would be to put from a different work which would be
> cleaner but need more code.  How does this one look to you?
> 
> Thanks.
> 
>  fs/cifs/Kconfig    |    1 -
>  fs/cifs/cifsfs.c   |    6 +-----
>  fs/cifs/cifsglob.h |    8 +++++---
>  fs/cifs/dir.c      |    2 +-
>  fs/cifs/file.c     |   30 +++++++++++++-----------------
>  fs/cifs/misc.c     |   20 ++++++++++++--------
>  6 files changed, 32 insertions(+), 35 deletions(-)
> 
> Index: work/fs/cifs/cifsfs.c
> ===================================================================
> --- work.orig/fs/cifs/cifsfs.c
> +++ work/fs/cifs/cifsfs.c
> @@ -1038,15 +1038,10 @@ init_cifs(void)
>  	if (rc)
>  		goto out_unregister_key_type;
>  #endif
> -	rc = slow_work_register_user(THIS_MODULE);
> -	if (rc)
> -		goto out_unregister_resolver_key;
>  
>  	return 0;
>  
> - out_unregister_resolver_key:
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> -	unregister_key_type(&key_type_dns_resolver);
>   out_unregister_key_type:
>  #endif
>  #ifdef CONFIG_CIFS_UPCALL
> @@ -1069,6 +1064,7 @@ static void __exit
>  exit_cifs(void)
>  {
>  	cFYI(DBG2, ("exit_cifs"));
> +	flush_workqueue(system_single_wq);
>  	cifs_proc_clean();
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	cifs_dfs_release_automount_timer();
> Index: work/fs/cifs/cifsglob.h
> ===================================================================
> --- work.orig/fs/cifs/cifsglob.h
> +++ work/fs/cifs/cifsglob.h
> @@ -18,7 +18,7 @@
>   */
>  #include <linux/in.h>
>  #include <linux/in6.h>
> -#include <linux/slow-work.h>
> +#include <linux/workqueue.h>
>  #include "cifs_fs_sb.h"
>  #include "cifsacl.h"
>  /*
> @@ -356,7 +356,7 @@ struct cifsFileInfo {
>  	atomic_t count;		/* reference count */
>  	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
>  	struct cifs_search_info srch_inf;
> -	struct slow_work oplock_break; /* slow_work job for oplock breaks */
> +	struct work_struct oplock_break; /* work for oplock breaks */
>  };
>  
>  /* Take a reference on the file private data */
> @@ -723,4 +723,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv;
>  GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
>  GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
>  
> -extern const struct slow_work_ops cifs_oplock_break_ops;
> +void cifs_oplock_break(struct work_struct *work);
> +void cifs_oplock_break_get(struct cifsFileInfo *cfile);
> +void cifs_oplock_break_put(struct cifsFileInfo *cfile);
> Index: work/fs/cifs/dir.c
> ===================================================================
> --- work.orig/fs/cifs/dir.c
> +++ work/fs/cifs/dir.c
> @@ -157,7 +157,7 @@ cifs_new_fileinfo(struct inode *newinode
>  	mutex_init(&pCifsFile->lock_mutex);
>  	INIT_LIST_HEAD(&pCifsFile->llist);
>  	atomic_set(&pCifsFile->count, 1);
> -	slow_work_init(&pCifsFile->oplock_break, &cifs_oplock_break_ops);
> +	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
>  
>  	write_lock(&GlobalSMBSeslock);
>  	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
> Index: work/fs/cifs/file.c
> ===================================================================
> --- work.orig/fs/cifs/file.c
> +++ work/fs/cifs/file.c
> @@ -2276,8 +2276,7 @@ out:
>  	return rc;
>  }
>  
> -static void
> -cifs_oplock_break(struct slow_work *work)
> +void cifs_oplock_break(struct work_struct *work)
>  {
>  	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
>  						  oplock_break);
> @@ -2316,33 +2315,30 @@ cifs_oplock_break(struct slow_work *work
>  				 LOCKING_ANDX_OPLOCK_RELEASE, false);
>  		cFYI(1, ("Oplock release rc = %d", rc));
>  	}
> +
> +	/*
> +	 * We might have kicked in before is_valid_oplock_break()
> +	 * finished grabbing reference for us.  Make sure it's done by
> +	 * waiting for GlobalSMSSeslock.
> +	 */
> +	write_lock(&GlobalSMBSeslock);
> +	write_unlock(&GlobalSMBSeslock);
> +

^^^^
When I backported this before, I put this at the beginning of the
function, not just before the put. I think that this is actually ok
though. We may end up running the function without holding the
references, but the objects we're concerned about can't be freed until
is_valid_oplock_break drops the spinlock.

> +	cifs_oplock_break_put(cfile);
>  }
>  
> -static int
> -cifs_oplock_break_get(struct slow_work *work)
> +void cifs_oplock_break_get(struct cifsFileInfo *cfile)
>  {
> -	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
> -						  oplock_break);
>  	mntget(cfile->mnt);
>  	cifsFileInfo_get(cfile);
> -	return 0;
>  }
>  
> -static void
> -cifs_oplock_break_put(struct slow_work *work)
> +void cifs_oplock_break_put(struct cifsFileInfo *cfile)
>  {
> -	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
> -						  oplock_break);
>  	mntput(cfile->mnt);
>  	cifsFileInfo_put(cfile);
>  }
>  
> -const struct slow_work_ops cifs_oplock_break_ops = {
> -	.get_ref	= cifs_oplock_break_get,
> -	.put_ref	= cifs_oplock_break_put,
> -	.execute	= cifs_oplock_break,
> -};
> -
>  const struct address_space_operations cifs_addr_ops = {
>  	.readpage = cifs_readpage,
>  	.readpages = cifs_readpages,
> Index: work/fs/cifs/misc.c
> ===================================================================
> --- work.orig/fs/cifs/misc.c
> +++ work/fs/cifs/misc.c
> @@ -499,7 +499,6 @@ is_valid_oplock_break(struct smb_hdr *bu
>  	struct cifsTconInfo *tcon;
>  	struct cifsInodeInfo *pCifsInode;
>  	struct cifsFileInfo *netfile;
> -	int rc;
>  
>  	cFYI(1, ("Checking for oplock break or dnotify response"));
>  	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
> @@ -584,13 +583,18 @@ is_valid_oplock_break(struct smb_hdr *bu
>  				pCifsInode->clientCanCacheAll = false;
>  				if (pSMB->OplockLevel == 0)
>  					pCifsInode->clientCanCacheRead = false;
> -				rc = slow_work_enqueue(&netfile->oplock_break);
> -				if (rc) {
> -					cERROR(1, ("failed to enqueue oplock "
> -						   "break: %d\n", rc));
> -				} else {
> -					netfile->oplock_break_cancelled = false;
> -				}
> +
> +				/*
> +				 * cifs_oplock_break_put() can't be called
> +				 * from here.  Get reference after queueing
> +				 * succeeded.  cifs_oplock_break() will
> +				 * synchronize using GlobalSMSSeslock.
> +				 */
> +				if (queue_work(system_single_wq,
> +					       &netfile->oplock_break))
> +					cifs_oplock_break_get(netfile);
> +				netfile->oplock_break_cancelled = false;
> +

I think we want to move the setting of netfile->oplock_break_cancelled
inside of the if above it.

If the work is already queued, I don't think we want to set the flag to
false. Doing so might be problematic if we somehow end up processing
this oplock break after a previous oplock break/reconnect/reopen
sequence, but while the initial oplock break is still running.

>  				read_unlock(&GlobalSMBSeslock);
>  				read_unlock(&cifs_tcp_ses_lock);
>  				return true;
> Index: work/fs/cifs/Kconfig
> ===================================================================
> --- work.orig/fs/cifs/Kconfig
> +++ work/fs/cifs/Kconfig
> @@ -2,7 +2,6 @@ config CIFS
>  	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
>  	depends on INET
>  	select NLS
> -	select SLOW_WORK
>  	help
>  	  This is the client VFS module for the Common Internet File System
>  	  (CIFS) protocol which is the successor to the Server Message Block


-- 
Jeff Layton <jlayton@redhat.com>
