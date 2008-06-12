Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYFLAyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYFLAyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYFLAya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:54:30 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:45097 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751454AbYFLAy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:54:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jAwhbFflhaDxtGwwtsA0ecgbdyLh/bUYcQsexzx8bhcY2hvZBmQTqwGb7jioKVE1RO2NC9U7YrTC5lkX+nP+TeBFgJv1fh/FyQDH8a79CYrC3mdNKZPTREDnLi5zFaKC86bgJ5bC4Cb3yW1DYVKwK2zxTIoYG6PUuXE82E+4bys=  ;
X-YMail-OSG: wRmIYj8VM1kl_2vQ.DbBZ9uoXPK3Lo.V7szwEhM0UL820YKRANXh47O8FqHYwJOEZfys5VKxhR8AZDwsZcropItQO_iEAvN79DTTAQrxBDZpXJykpinaaY0QfErX3WOKZWE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm 14/24] Ramfs and Ram Disk pages are unevictable
Date: Thu, 12 Jun 2008 10:54:18 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>
References: <20080611184214.605110868@redhat.com> <20080611184339.693975681@redhat.com>
In-Reply-To: <20080611184339.693975681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121054.19253.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 04:42, Rik van Riel wrote:
> From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
>
> Christoph Lameter pointed out that ram disk pages also clutter the
> LRU lists.  When vmscan finds them dirty and tries to clean them,
> the ram disk writeback function just redirties the page so that it
> goes back onto the active list.  Round and round she goes...


> Index: linux-2.6.26-rc5-mm2/drivers/block/brd.c
> ===================================================================
> --- linux-2.6.26-rc5-mm2.orig/drivers/block/brd.c	2008-06-10
> 10:46:18.000000000 -0400 +++
> linux-2.6.26-rc5-mm2/drivers/block/brd.c	2008-06-10 16:47:23.000000000
> -0400 @@ -374,8 +374,21 @@ static int brd_ioctl(struct inode *inode
>  	return error;
>  }
>
> +/*
> + * brd_open():
> + * Just mark the mapping as containing unevictable pages
> + */
> +static int brd_open(struct inode *inode, struct file *filp)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +
> +	mapping_set_unevictable(mapping);
> +	return 0;
> +}
> +
>  static struct block_device_operations brd_fops = {
>  	.owner =		THIS_MODULE,
> +	.open  =		brd_open,
>  	.ioctl =		brd_ioctl,
>  #ifdef CONFIG_BLK_DEV_XIP
>  	.direct_access =	brd_direct_access,

This isn't the case for brd any longer. It doesn't use the buffer
cache as its backing store, so the buffer cache is reclaimable.
