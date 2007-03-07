Return-Path: <linux-kernel-owner+w=401wt.eu-S2992556AbXCGUrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992556AbXCGUrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992554AbXCGUrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:47:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965640AbXCGUrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:47:03 -0500
Date: Wed, 7 Mar 2007 12:46:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 8/8] consolidate generic_writepages and mpage_writepages
 fix
Message-Id: <20070307124658.515d8fb5.akpm@linux-foundation.org>
In-Reply-To: <20070306180557.611121214@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
	<20070306180557.611121214@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 19:04:51 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Fix NULL pointer dereference in __mpage_writepage.  This probably
> doesn't matter in practice, but this is the original behavior.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/mpage.c
> ===================================================================
> --- linux.orig/fs/mpage.c	2007-03-06 17:30:09.000000000 +0100
> +++ linux/fs/mpage.c	2007-03-06 17:30:33.000000000 +0100
> @@ -662,7 +662,7 @@ confused:
>  	if (bio)
>  		bio = mpage_bio_submit(WRITE, bio);
>  
> -	if (mpd->use_writepage) {
> +	if (mpd->use_writepage && mapping->a_ops->writepage) {
>  		ret = mapping->a_ops->writepage(page, wbc);
>  	} else {
>  		ret = -EAGAIN;
> 
> --

I'm inclined to leave the code as-is, as an optimisation.  If it
blows up then it'd be cleaner to change the caller (mpage_writepages)
to do

	.use_writepage = (writepage != NULL),

?
