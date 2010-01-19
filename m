Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834Ab0ASMXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0ASMXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416Ab0ASMXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:23:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab0ASMXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:23:40 -0500
Date: Tue, 19 Jan 2010 07:20:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Tejun Heo <tj@kernel.org>, Steve French <sfrench@samba.org>
Subject: Re: [PATCH 38/40] cifs: use workqueue instead of slow-work
Message-ID: <20100119072000.247ac894@tlielax.poochiereds.net>
In-Reply-To: <1263776272-382-39-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-39-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 09:57:50 +0900
Tejun Heo <tj@kernel.org> wrote:

> Workqueue can now handle high concurrency.  Use system_single_wq
> instead of slow-work.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> ---
>  fs/cifs/Kconfig    |    1 -
>  fs/cifs/cifsfs.c   |    6 +-----
>  fs/cifs/cifsglob.h |    8 +++++---
>  fs/cifs/dir.c      |    2 +-
>  fs/cifs/file.c     |   22 +++++-----------------
>  fs/cifs/misc.c     |   15 +++++++--------
>  6 files changed, 19 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 80f3525..6994a0f 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -2,7 +2,6 @@ config CIFS
>  	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
>  	depends on INET
>  	select NLS
> -	select SLOW_WORK
>  	help
>  	  This is the client VFS module for the Common Internet File System
>  	  (CIFS) protocol which is the successor to the Server Message Block
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8c6a036..461a3a7 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
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
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4b35f7e..c645843 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
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
> @@ -723,4 +723,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
>  GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
>  GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
>  
> -extern const struct slow_work_ops cifs_oplock_break_ops;
> +void cifs_oplock_break(struct work_struct *work);
> +void cifs_oplock_break_get(struct cifsFileInfo *cfile);
> +void cifs_oplock_break_put(struct cifsFileInfo *cfile);
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 6ccf726..3c6f9b2 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -157,7 +157,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
>  	mutex_init(&pCifsFile->lock_mutex);
>  	INIT_LIST_HEAD(&pCifsFile->llist);
>  	atomic_set(&pCifsFile->count, 1);
> -	slow_work_init(&pCifsFile->oplock_break, &cifs_oplock_break_ops);
> +	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
>  
>  	write_lock(&GlobalSMBSeslock);
>  	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 057e1da..1c5fdf9 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
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
> @@ -2316,33 +2315,22 @@ cifs_oplock_break(struct slow_work *work)
>  				 LOCKING_ANDX_OPLOCK_RELEASE, false);
>  		cFYI(1, ("Oplock release rc = %d", rc));
>  	}
> +
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
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index d27d4ec..a2cf7d2 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -499,7 +499,6 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
>  	struct cifsTconInfo *tcon;
>  	struct cifsInodeInfo *pCifsInode;
>  	struct cifsFileInfo *netfile;
> -	int rc;
>  
>  	cFYI(1, ("Checking for oplock break or dnotify response"));
>  	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
> @@ -584,13 +583,13 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
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
> +				cifs_oplock_break_get(netfile);
> +				if (!queue_work(system_single_wq,
> +						&netfile->oplock_break))
> +					cifs_oplock_break_put(netfile);
> +				netfile->oplock_break_cancelled = false;
> +
>  				read_unlock(&GlobalSMBSeslock);
>  				read_unlock(&cifs_tcp_ses_lock);
>  				return true;

This block of code looks problematic. This code is run by the
cifs_demultiplex_thread (cifsd). We can't do an oplock_break_put in
this context, since it might trigger a blocking SMB and cause a
deadlock.

A while back, I backported this code to earlier kernels and used a
standard workqueue there. What I did there was to only do the "get" if
the queue_work succeeded, and then had the queued work take and
immediately drop the GlobalSMBSeslock first thing. Yes, it's ugly, but
it prevented the possible deadlock and didn't require adding anything
like completion vars to the struct.

Also, this change seems to have changed the logic a bit. The
oplock_break_cancelled flag is being set to false unconditionally, and
the printk was dropped. Not a big deal on the last part, but we can't
really do much with errors in this codepath so it might be helpful to
have some indication that there are problems here.

Other than the above problems (which are easily fixable), this patch
seems fine.

-- 
Jeff Layton <jlayton@redhat.com>
