Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXCHVZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXCHVZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXCHVZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:25:40 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:22416 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbXCHVZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:25:32 -0500
Date: Thu, 8 Mar 2007 12:53:41 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix read past end of array in md/linear.c
Message-ID: <20070308205341.GA13663@hexapodia.org>
References: <20070308205204.GA12152@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308205204.GA12152@hexapodia.org>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 48 01 21 E2 D4 E4 68 D1  B8 DF 39 B2 AF A3 16 B9
X-PGP-Key-URL: http://web.hexapodia.org/~adi/pgp.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 12:52:04PM -0800, Andy Isaacson wrote:
> When iterating through an array, one must be careful to test one's index
> variable rather than another similarly-named variable.  
> 
> The loop will read off the end of conf->disks[] in the following
> (pathological) case:
> 
> % dd bs=1 seek=840716287 if=/dev/zero of=d1 count=1
> % for i in 2 3 4; do dd if=/dev/zero of=d$i bs=1k count=$(($i+150)); done
> % ./vmlinux ubd0=root ubd1=d1 ubd2=d2 ubd3=d3 ubd4=d4
> # mdadm -C /dev/md0 --level=linear --raid-devices=4 /dev/ubd[1234]
> 
> adding some printks, I saw this:
> [42949374.960000] hash_spacing = 821120
> [42949374.960000] cnt          = 4
> [42949374.960000] min_spacing  = 801
> [42949374.960000] j=0 size=820928 sz=820928
> [42949374.960000] i=0 sz=820928 hash_spacing=820928
> [42949374.960000] j=1 size=64 sz=64
> [42949374.960000] j=2 size=64 sz=128
> [42949374.960000] j=3 size=64 sz=192
> [42949374.960000] j=4 size=1515870810 sz=1515871002
> 
> Index: linus/drivers/md/linear.c
> ===================================================================
> --- linus.orig/drivers/md/linear.c	2007-03-02 11:35:55.000000000 -0800
> +++ linus/drivers/md/linear.c	2007-03-07 13:10:30.000000000 -0800
> @@ -188,7 +188,7 @@
>  	for (i=0; i < cnt-1 ; i++) {
>  		sector_t sz = 0;
>  		int j;
> -		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
> +		for (j=i; j<cnt-1 && sz < min_spacing ; j++)
>  			sz += conf->disks[j].size;
>  		if (sz >= min_spacing && sz < conf->hash_spacing)
>  			conf->hash_spacing = sz;

Forgot to add:

Signed-off-by: Andrew Isaacson <adi@hexapodia.org>

-andy
