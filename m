Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbYCZKsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbYCZKsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYCZKsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:48:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYCZKsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:48:32 -0400
Date: Wed, 26 Mar 2008 10:48:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: J?rn Engel <joern@logfs.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch] bkl2mtd: cleanup
Message-ID: <20080326104821.GS10722@ZenIV.linux.org.uk>
References: <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326101452.GA17176@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 11:14:52AM +0100, Ingo Molnar wrote:
>  /* Info for the block device */
>  struct block2mtd_dev {
> -	struct list_head list;
> -	struct block_device *blkdev;
> -	struct mtd_info mtd;
> -	struct mutex write_mutex;
> +	struct list_head	list;
> +	struct block_device	*blkdev;
> +	struct mtd_info		mtd;
> +	/* serializes writes with each other and also with erase: */
> +	struct mutex		write_mutex;
>  };

Why the hell?

> -static int _block2mtd_write(struct block2mtd_dev *dev, const u_char *buf,
> -		loff_t to, size_t len, size_t *retlen)
> +static int
> +_block2mtd_write(struct block2mtd_dev *dev, const u_char *buf, loff_t to,
> +		 size_t len, size_t *retlen)

That's actually worse...  BTW, single-underscore-... for identifiers?  Odd.

> -static int block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
> +static int
> +block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
>  		size_t *retlen, const u_char *buf)

Again, why split it that way?

> -	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
> -	dev->mtd.erasesize = erase_size;
> -	dev->mtd.writesize = 1;
> -	dev->mtd.type = MTD_RAM;
> -	dev->mtd.flags = MTD_CAP_RAM;
> -	dev->mtd.erase = block2mtd_erase;
> -	dev->mtd.write = block2mtd_write;
> -	dev->mtd.writev = default_mtd_writev;
> -	dev->mtd.sync = block2mtd_sync;
> -	dev->mtd.read = block2mtd_read;
> -	dev->mtd.priv = dev;
> -	dev->mtd.owner = THIS_MODULE;
> +	dev->mtd.size		= dev->blkdev->bd_inode->i_size & PAGE_MASK;
> +	dev->mtd.erasesize	= erase_size;
> +	dev->mtd.writesize	= 1;
> +	dev->mtd.type		= MTD_RAM;
> +	dev->mtd.flags		= MTD_CAP_RAM;
> +	dev->mtd.erase		= block2mtd_erase;
> +	dev->mtd.write		= block2mtd_write;
> +	dev->mtd.writev		= default_mtd_writev;
> +	dev->mtd.sync		= block2mtd_sync;
> +	dev->mtd.read		= block2mtd_read;
> +	dev->mtd.priv		= dev;
> +	dev->mtd.owner		= THIS_MODULE;

Bogus.

> -		if (ret) {
> +		if (ret)
>  			parse_err("illegal erase size");
> -		}
>  	}

BTW, I certainly wouldn't inflict that on patches; at some point in
series the body of if may shrink to one line only to get longer in
the next patch.  Removing and restoring {} would only add noise.

OTOH, you've missed quite a few of my pet peeves, starting with
u_char in the quoted part...
