Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZLAE1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZLAE1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZLAE07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:26:59 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55039 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZLAE06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:26:58 -0500
Date: Mon, 30 Nov 2009 23:26:30 -0500
Message-Id: <200912010426.nB14QUt0030633@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/41] union-mount: Make pivot_root work with union mounts 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:36 PDT."
             <1256152779-10054-39-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-39-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> When moving a union mount, follow it down to the bottom layer and move
> that instead of just the top layer.
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namespace.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 9b71743..6ac5fc1 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2282,6 +2282,15 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
>  	if (d_unlinked(old.dentry))
>  		goto out2;
>  	error = -EBUSY;
> +	/*
> +	 * follow_union_down() only goes one layer down.  We want the
> +	 * bottom-most layer here - if we move that around, all the
> +	 * layers on top move with it.  But if we ever allow more than
> +	 * two layers, the below two will both need to be in while()
> +	 * loops.
> +	 */

Given the nature of this comment, I'd stick an "XXX" there for easier
ability to grep-the-src-for-issues.

> +	follow_union_down(&new.mnt, &new.dentry);
> +	follow_union_down(&root.mnt, &root.dentry);
>  	if (new.mnt == root.mnt ||
>  	    old.mnt == root.mnt)
>  		goto out2; /* loop, on the same file system  */
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
