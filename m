Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYCHIct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYCHIct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 03:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYCHIcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 03:32:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38696 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYCHIcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 03:32:39 -0500
Date: Sat, 08 Mar 2008 17:33:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Subject: Re: [PATCH][BUGFIX][RFC] fix soft lock up at NFS mount by making limitation of dentry_unused
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org, dgc@sgi.com
In-Reply-To: <47CF9A1F.50300@np.css.fujitsu.com>
References: <20080306055416.GF155407@sgi.com> <47CF9A1F.50300@np.css.fujitsu.com>
Message-Id: <20080308171911.E365.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi makita-san

in general, I agreed with many people disallow >1min hang up.

> > No, we need a smarter free list structure. There have been several attempts
> > at this in the past. Two that I can recall off the top of my head:
> > 
> > 	- per node unused LRUs
> > 	- per superblock unusued LRUs
> 
>  I know there is such attempt already, but they are not in main-line.
>  I think this is not a smart but simple way to avoid this ploblem.

I think 2 improvement is not exclusive.
your patch is nice, but we need David's patch too. 

because 2 patch purpose is different.

per superblock lru:   improve typical performance.
limit of unused list: prevent too long hang up.

many time hang up happend at worst case even introduce per superblock lru.
and
unused list traversal doesn't improvement even introduce limit of unused list.

I hope both.


> >> Tested on Intel Itanium 2 9050 (dualcore) x12 MEM 24GB , kernel-2.6.25-rc4
> >> I found no peformance regression in my tests.
> > 
> > Try something that relies on leaving the working set on the unused
> > list, like NFS server benchmarks that have a working set of tens of
> > million of files....
> > 
>  Okay, I'll try some benchmarks and report results...

good luck.


>   	spin_unlock(&dentry->d_lock);
>  	spin_unlock(&dcache_lock);
> +	/* Prune unused dentry over threshold level */
> +	int nr_in_use = (dentry_stat.nr_dentry - dentry_stat.nr_unused);
> +	if (dentry_stat.nr_dentry > nr_in_use * (dentry_unused_ratio / 100))
> +		prune_dcache(dentry_stat.nr_unused * 5 / 100 , NULL);
>  	return;

Why don't you make sysctl adjustable interface of dentry_unused_ratio?


- kosaki


