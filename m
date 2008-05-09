Return-Path: <linux-kernel-owner+w=401wt.eu-S1762419AbYEINN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762419AbYEINN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbYEINNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:13:21 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3766 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613AbYEINNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:13:20 -0400
Date: Fri, 9 May 2008 14:13:26 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, zippel@linux-m68k.org
Subject: Re: [Patch] hfsplus oops on image without extends
Message-ID: <20080509131326.GA31089@shadowen.org>
References: <20080507104244.GD2340@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507104244.GD2340@alice>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 12:42:44PM +0200, Eric Sesterhenn wrote:
> hi,
> 
> the following patch fixes an oops with a corrupted hfs+ image.
> see http://bugzilla.kernel.org/show_bug.cgi?id=10548 for details.
> 
> Problem is that we call hfs_btree_open() from hfsplus_fill_super() to set
> HFSPLUS_SB(sb).[ext_tree|cat_tree]
> Both trees are still NULL at this moment. If hfs_btree_open() fails for
> any reason it calls iput() on the page, which
> gets to hfsplus_releasepage() which tries to access HFSPLUS_SB(sb).*
> which is still NULL and oopses while dereferencing it.
> 
> 
> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> 
> --- linux-2.6/fs/hfsplus/inode.c.orig	2008-05-07 14:37:31.000000000 +0200
> +++ linux-2.6/fs/hfsplus/inode.c	2008-05-07 14:38:05.000000000 +0200
> @@ -65,6 +65,8 @@ static int hfsplus_releasepage(struct pa
>  		BUG();
>  		return 0;
>  	}
> +	it (!tree)
> +		return 0;

Erm, I presume this is meant to be 'if', checkpatch whined about the
space as it thought it was a function.  I guess this hasn't been compile
tested?

>  	if (tree->node_size >= PAGE_CACHE_SIZE) {
>  		nidx = page->index >> (tree->node_size_shift - PAGE_CACHE_SHIFT);
>  		spin_lock(&tree->hash_lock);

-apw
