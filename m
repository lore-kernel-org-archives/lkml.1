Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbXKMQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbXKMQyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXKMQyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:54:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46536 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933AbXKMQyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:54:09 -0500
Date: Tue, 13 Nov 2007 16:54:06 +0000
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, apw@shadowen.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
Message-ID: <20071113165405.GA12837@skynet.ie>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071112182526.GC11244@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On (12/11/07 21:25), Alexey Dobriyan didst pronounce:
> Cross-compile farm here migrated to .ccache and build dir on separate
> disks and now I have a way to blow up .ccache without waiting half an
> hour for rm(1) to finish. It's called mke2fs(8).
> 
> However, in e.g 2.6.24-rc2 mke2fs is amazingly slow if done right after
> several fat cross-compile builds. Normally it takes ~11 seconds to
> finish. After commit 5adc5be7cd1bcef6bb64f5255d2a33f20a3cf5be aka
> "Bias the placement of kernel pages at lower PFNs" it takes several
> minutes. 2.6.24-rc2 without this patch also gives normal mkfs speeds.
> I'm pretty sure bisection wasn't screwed up.
> 
> 
> Details:
> 
> 	Core 2 Duo on x86_64, no debugging
> 	4G RAM
> 	30G ext2 .ccache partition with noatime
> 	100G ext2 partition with source tree and build dirs with noatime
> 
> I build alpha-allnoconfig, alpha-defconfig and 4 allmodconfigs
> (SMP=y/n x DEBUG_KERNEL=y/n).
> 
> Right after compilation finishes, free(1) reports more or less the same
> picture (VM hackers, please, tell me which info you need):
> 
>              total       used       free     shared    buffers     cached
> Mem:       4032320    2802604    1229716          0      97160    2424816
> -/+ buffers/cache:     280628    3751692
> Swap:      7823644          0    7823644
> 
> Last steps of build script are:
> 
> 	umount /home/ad/.ccache
> 	sudo mkfs.ext2 -m 0 	<=== this is slow
> 

Thanks very much for the report and the bisect. I spent the day trying
to reproduce it but I'm having trouble seeing the same problem using just
mke2fs. I've tried

Pentium III x86 machine with 1GB of RAM, 9GB partition
4-way Opteron with 8GB RAM, 10GB partition
2-way Opteron with 2GB RAM, 10GB partition
Pentium D (duel core) with 2GB RAM, 128GB partition

In all cases, the comparison between 2.6.23, latest git and latest git
with patch reverted were the same. For example, on the Pentium D, I got

2.6.23:			95.672 real, 0.068 user, 10.334 sys
2.6.24-rc2-git:		96.112 real, 0.08 user, 10.664 sys
2.6.24-rc2-revert:	96.182 real, 0.072 user, 10.602 sys

This is an average of 5 runs on a 128GB partition. Somewhat unexpectedly,
the revert was fractionally slower. The deviation between runs was around
the 0.4 second mark so the differences appear to be in the noise.

On the other machines, the reverted version was slightly faster but I was
seeing about 0.5% of overall running time, not the massive differences you
were seeing.  Clearly there is still a problem because reverting the patch
fixes your problem.... As I write this, it occurs to me that it might be
because your compile-job has created very long free-lists and searching them
is causing problems.

Can you post the contents of /proc/buddyinfo before and after you run
mke2fs? It will give an indication of how long the linked lists are being
searched. After I push send here, I'll be trying the tests after running
compile-tests similar to yours to see if that reproduces the problem.

Here are some other questions I hope you can answer just to eliminate them
as possibilities. Can you tell me what sort of disk driver you are using
(results here are for sata_nv)? Are you using RAID or MD? Is anything running
in the background while mke2fs is running? What is the output of mke2fs -V,
gcc --version and ld -v? Finally, can you mail me your .config and I'll try
it on my machine here.

In the meantime, it is safe to revert this patch. Andy Whitcroft tested
the behaviour of anti-fragmentation on a number of machines and while the
results are adversely affected in terms of hugepage allocation success rates,
they are still pretty decent. We will investigate a less expensive way of
achieving the same effect of the patch without the potentially long searches.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
