Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYJaShQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYJaShQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYJaShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:37:03 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54702 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbYJaShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:37:01 -0400
Date: Fri, 31 Oct 2008 18:36:58 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
Message-ID: <20081031183658.GC6817@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <20081030142632.GA15645@csn.ul.ie> <18698.7794.500191.189515@cargo.ozlabs.ibm.com> <20081031103646.GA24395@csn.ul.ie> <18698.59327.927555.732608@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <18698.59327.927555.732608@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:10:55PM +1100, Paul Mackerras wrote:
> Mel Gorman writes:
> 
> > Yaboot in my case and I've heard it affected a DVD installation. I don't
> > know for sure if it affects netboot but as I think it's something the
> > kernel is doing, it probably doesn't matter how it gets loaded?
> 
> What changed in that commit was the contents of a couple of structures
> that the firmware looks at to see what the kernel wants from
> firmware.  Specifically the change was to say that the kernel (or
> really the zImage wrapper) would like the firmware to be based at the
> 32MB point (which is what AIX uses) rather than 12MB (which was the
> default on older machines).
> 
> So, as I understand it, it's not anything the kernel is actively
> doing, it's how the firmware is reacting to what the kernel says it
> wants.  And since we are requesting the same value as AIX (as far as I
> know) I'm really surprised it caused problems.
> 
> We can revert that commit, but I still need to solve the problem that
> the distros are facing, namely that their installer kernel + initramfs
> images are now bigger than 12MB and can't be loaded if the firmware is
> based at 12MB.  That's why I really want to understand the problem in
> more detail.
> 
> > It's been pointed out that it can be "fixed" by upgrading the firmware but
> > surely we can avoid breaking the machine in the first place?
> 
> Have you upgraded the firmware on the machine you saw this problem on?
> If not, would you be willing to run some tests for me?
> 

As per an off-line suggestion, I was able to get past the NVRAM problem
using the following patch. The machine still fails to fully boot but it's
due to some modules problem and unrelated to this issue.

>From 7e54016ce29eb80026d7ff9a8310cf9c3a7e17a9 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mel@csn.ul.ie>
Date: Fri, 31 Oct 2008 17:12:46 +0000
Subject: [PATCH] Partial revert of 91a00302, set new_mem_def back to 0

On the suggestion of Paul McKerras, I tried the following patch. It partially
reverts a change made by commit 91a00302 by setting new_mem_def back to 0.
Once applied, IBM pSeries with old firmware do not corrupt their NVRAM early
in boot.

I do not know why this change fixes the problem. A structure like this is
also in arch/powerpc/boot/addnote.c but it's not clear if it needs to be
similarly changed or not. Paul?

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 arch/powerpc/kernel/prom_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 23e0db2..d6c8128 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -719,7 +719,7 @@ static struct fake_elf {
 			.max_pft_size = 46,	/* 2^46 bytes max PFT size */
 			.splpar = 1,
 			.min_load = ~0U,
-			.new_mem_def = 1
+			.new_mem_def = 0
 		}
 	}
 };

