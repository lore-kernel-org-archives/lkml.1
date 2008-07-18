Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYGRL5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYGRL5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYGRL4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:56:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYGRL4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:56:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] autofs4 - indirect dentry must almost always be positive
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 18 Jul 2008 07:56:34 -0400
In-Reply-To: <20080718023651.12802.59107.stgit@raven.themaw.net> (Ian Kent's
	message of "Fri, 18 Jul 2008 10:36:53 +0800")
Message-ID: <x49k5fje77x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> Signed-off-by: Ian Kent <raven@themaw.net>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Cheers,

Jeff

>
> ---
>
>  fs/autofs4/waitq.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
>
>
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index bcb6c52..35216d1 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -328,9 +328,20 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
>  	if (sbi->catatonic)
>  		return -ENOENT;
>  
> -	if (!dentry->d_inode &&
> -	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
> -		return -ENOENT;
> +	if (!dentry->d_inode) {
> +		/*
> +		 * A wait for a negative dentry is invalid for certain
> +		 * cases. A direct or offset mount "always" has its mount
> +		 * point directory created and so the request dentry must
> +		 * be positive or the map key doesn't exist. The situation
> +		 * is very similar for indirect mounts except only dentrys
> +		 * in the root of the autofs file system may be negative.
> +		 */
> +		if (sbi->type & (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET))
> +			return -ENOENT;
> +		else if (!IS_ROOT(dentry->d_parent))
> +			return -ENOENT;
> +	}
>  
>  	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
>  	if (!name)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
