Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbXBEVg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbXBEVg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbXBEVg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:36:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbXBEVgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:36:24 -0500
Date: Mon, 5 Feb 2007 13:35:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Moore <dcm@MIT.EDU>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, discuss@x86-64.org,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
Message-Id: <20070205133556.9b290d0a.akpm@linux-foundation.org>
In-Reply-To: <1170614380.26464.52.camel@PISCES.MIT.EDU>
References: <1170614380.26464.52.camel@PISCES.MIT.EDU>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 13:39:40 -0500
David Moore <dcm@MIT.EDU> wrote:

> From: David Moore <dcm@acm.org>
> 
> Adds missing call to phys_to_virt() in the
> lib/swiotlb.c:swiotlb_sync_sg() function.  Without this change, a kernel
> panic will always occur whenever a SWIOTLB bounce buffer from a
> scatter-gather list gets synced.
> 
> Signed-off-by: David Moore <dcm@acm.org>
> ---
> 
> This change was originally part of a larger patch by Jan Beulich, which
> was more extensive and doesn't look destined to make it into 2.6.20:
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/ia64-swiotlb-bug-fixes.patch
> 
> However, considering the severity of this one-liner bug, I would like to
> request that this simplified patch make it into 2.6.20, despite how
> close we are to the final cut.  It fixes real crashes:
> http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
> http://qa.mandriva.com/show_bug.cgi?id=28224
> http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce
> 
> --- linux-2.6.19.x86_64/lib/swiotlb.c.orig	2007-02-04 13:18:41.000000000 -0500
> +++ linux-2.6.19.x86_64/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
> @@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
>  
>  	for (i = 0; i < nelems; i++, sg++)
>  		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
> -			sync_single(hwdev, (void *) sg->dma_address,
> +			sync_single(hwdev, phys_to_virt(sg->dma_address),
>  				    sg->dma_length, dir, target);
>  }
>  

argh.  I didn't know that Jan's patches fixed crashes.  I thought they were
ia64-only things.

Who maintains the swiotlb code?

I shall queue this up, tag it for 2.6.20.1, then I'll fix up Jan's alleged
ia64 patches to account for that.  I'll still push it through Tony, but the
x86_64/ia64 linkage here seems to be a source of problems.


