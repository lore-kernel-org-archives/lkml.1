Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbYF3SMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbYF3SMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYF3SL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:11:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33446 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYF3SL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:11:57 -0400
Date: Mon, 30 Jun 2008 14:11:38 -0400
Message-Id: <200806301811.m5UIBchl030097@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unionfs: fix memory leak 
In-reply-to: Your message of "Sun, 29 Jun 2008 01:07:15 BST."
             <Pine.LNX.4.64.0806290105430.20280@blonde.site> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0806290105430.20280@blonde.site>, Hugh Dickins writes:
> Unionfs has slowly been leaking memory: although many places do explicitly
> free the dentry's lower_paths array (and I've not changed those, in case
> the ordering is important), not all do - and adding a WARN_ON didn't seem
> to finger any particular culprit.  So free_dentry_private_data needs to
> kfree lower_paths (other freeers are good about setting it to NULL).
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Should follow mmotm's git-unionfs-fixup.patch
> 
>  fs/unionfs/lookup.c |    1 +
>  1 file changed, 1 insertion(+)
>  
> --- mmotm/fs/unionfs/lookup.c	2008-06-27 13:39:18.000000000 +0100
> +++ linux/fs/unionfs/lookup.c	2008-06-27 14:08:00.000000000 +0100
> @@ -498,6 +498,7 @@ void free_dentry_private_data(struct den
>  {
>  	if (!dentry || !dentry->d_fsdata)
>  		return;
> +	kfree(UNIONFS_D(dentry)->lower_paths);
>  	kmem_cache_free(unionfs_dentry_cachep, dentry->d_fsdata);
>  	dentry->d_fsdata = NULL;
>  }


Thanks, I'll take a closer look at this to ensure that all paths kfree
lower_paths as needed.

Erez.
