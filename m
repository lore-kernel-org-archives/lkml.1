Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYFLTAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYFLTAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbYFLTAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:00:32 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1972 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbYFLTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:00:30 -0400
Subject: Re: [PATCH] undo the brd.c part of
	ramfs-and-ram-disk-pages-are-unevictable.patch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080612135353.2d17436a@cuia.bos.redhat.com>
References: <20080612135353.2d17436a@cuia.bos.redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 12 Jun 2008 15:00:57 -0400
Message-Id: <1213297257.6240.15.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 13:53 -0400, Rik van Riel wrote:
> Undo the brd.c part of ramfs-and-ram-disk-pages-are-unevictable.patch.
> The brd pages do not live on the LRU at all, so there is no need to
> play these tricks.

Does this mean that these pages cannot be migrated?  E.g., to evacuate
memory for hotplug?  Looks like all paths to migrate_pages() construct a
list of pages to migrate by isolating them from the lru
[isolate_lru_page()].  Any pages not found in the lru are skipped.

Lee
> 
> Debugged-by: Nick Piggin <nickpiggin@yahoo.com.au>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> ---
>  drivers/block/brd.c |   13 -------------
>  1 file changed, 13 deletions(-)
> 
> Index: linux-2.6.26-rc5-mm2/drivers/block/brd.c
> ===================================================================
> --- linux-2.6.26-rc5-mm2.orig/drivers/block/brd.c	2008-06-11 14:39:43.000000000 -0400
> +++ linux-2.6.26-rc5-mm2/drivers/block/brd.c	2008-06-12 13:49:18.000000000 -0400
> @@ -374,21 +374,8 @@ static int brd_ioctl(struct inode *inode
>  	return error;
>  }
>  
> -/*
> - * brd_open():
> - * Just mark the mapping as containing unevictable pages
> - */
> -static int brd_open(struct inode *inode, struct file *filp)
> -{
> -	struct address_space *mapping = inode->i_mapping;
> -
> -	mapping_set_unevictable(mapping);
> -	return 0;
> -}
> -
>  static struct block_device_operations brd_fops = {
>  	.owner =		THIS_MODULE,
> -	.open  =		brd_open,
>  	.ioctl =		brd_ioctl,
>  #ifdef CONFIG_BLK_DEV_XIP
>  	.direct_access =	brd_direct_access,
> 

