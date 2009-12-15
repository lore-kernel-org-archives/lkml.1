Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbZLOXyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbZLOXyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbZLOXyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:54:52 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:54055 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981AbZLOXyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:54:50 -0500
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
 2.6.32-git1
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091215233841.GE22392@basil.fritz.box>
References: <20091207115949.GA7610@basil.fritz.box>
	 <20091207211216.E95E.A69D9226@jp.fujitsu.com>
	 <20091207132009.GI18989@one.firstfloor.org>
	 <20091215222134.GA27892@ZenIV.linux.org.uk>
	 <20091215233841.GE22392@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 18:54:37 -0500
Message-Id: <1260921277.3219.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 2046 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A708FF916B3F6AAD4E5E3603E3DCAAE93F956DAA
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 44 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 00:38 +0100, Andi Kleen wrote: 
> I suppose an easy workaround would be to not revalidate in mmap,
> because open should have already done that?
> 
> Very lightly tested RFC patch attached.
> 
> -Andi
> 
> ---
> 
> NFS: don't revalidate in mmap
> 
> nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
> hold and taking i_mutex inside mmap_sem is not allowed by the VFS.
> 
> So don't revalidate on mmap time and trust it has been already done.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/nfs/file.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> Index: linux-2.6.32-ak/fs/nfs/file.c
> ===================================================================
> --- linux-2.6.32-ak.orig/fs/nfs/file.c
> +++ linux-2.6.32-ak/fs/nfs/file.c
> @@ -297,14 +297,9 @@ nfs_file_mmap(struct file * file, struct
>  	dprintk("NFS: mmap(%s/%s)\n",
>  		dentry->d_parent->d_name.name, dentry->d_name.name);
>  
> -	/* Note: generic_file_mmap() returns ENOSYS on nommu systems
> -	 *       so we call that before revalidating the mapping
> -	 */
>  	status = generic_file_mmap(file, vma);
> -	if (!status) {
> +	if (!status)
>  		vma->vm_ops = &nfs_file_vm_ops;
> -		status = nfs_revalidate_mapping(inode, file->f_mapping);
> -	}
>  	return status;
>  }
>  

If you want to work around the problem rather than going for something
like Peter's split up of the mmap() callback, then I'd suggest changing
to using nfs_revalidate_mapping_nolock() instead. The fact that we are
seeing these lock misordering warnings is proof that the call to
nfs_revalidate_mapping() is not always a no-op.

By not taking the i_mutex your call to invalidate_inode_pages2() can
potentially end up racing with another process that is writing to the
file, but that should be a rare occurrence. The effect will be that the
two processes can end up fighting to alternatively dirty and then clean
the pages...

Cheers
  Trond

