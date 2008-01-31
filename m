Return-Path: <linux-kernel-owner+w=401wt.eu-S1765112AbYAaQ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765112AbYAaQ2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbYAaQ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:28:45 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49667 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041AbYAaQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:28:43 -0500
Date: Thu, 31 Jan 2008 18:29:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, wli@holomorphy.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, sparclinux@vger.kernel.org
Subject: sparc compile error caused by x86 arch updates
Message-ID: <20080131162920.GE19700@cs181133002.pp.htv.fi>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131161523.GA12347@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:15:23PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, Jan 31, 2008 at 05:00:33PM +0100, Ingo Molnar wrote:
> > > 
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > You tested x86 but broke more than half a dozen other archtectures, 
> > > > with at least 3 different commits breaking other architectures.
> > > 
> > > Note that all known breakages are fixed in current -git, except for the 
> > > s390 problem that Martin/Nick posted the fix.
> > 
> > What about the breakages caused by commit 
> > a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 (this commit broke the 
> > defconfig compilation on at least avr32, blackfin, sh, sparc and uml)?
> 
> the patch below fixes that.

The sparc breakage (might not have been reported until now and I 
bisected it just a few minutes ago) is caused by the following part of 
commit a5a19c63f4e55e32dc0bc3d936d7f94793d8b380:

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -6,6 +6,7 @@
 #include <linux/mmzone.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>


The compile error with the sparc defconfig is:

<--  snip  -->

...
  CC      init/main.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:24,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:10,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swap.h:9,
                 from include2/asm/pgtable.h:15,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:39,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/dma-mapping.h:17,
                 from include2/asm/dma-mapping.h:6,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/dma-mapping.h:52,
                 from include2/asm/sbus.h:10,
                 from include2/asm/dma.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/bootmem.h:8,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:26:
include2/asm/highmem.h: In function 'kmap':
include2/asm/highmem.h:60: error: implicit declaration of function 'PageHighMem'
include2/asm/highmem.h:61: error: implicit declaration of function 'page_address'
include2/asm/highmem.h:61: warning: return makes pointer from integer without a cast
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swap.h:9,
                 from include2/asm/pgtable.h:15,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:39,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/dma-mapping.h:17,
                 from include2/asm/dma-mapping.h:6,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/dma-mapping.h:52,
                 from include2/asm/sbus.h:10,
                 from include2/asm/dma.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/bootmem.h:8,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:26:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h: In function 'lock_page':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:169: error: implicit declaration of function 'TestSetPageLocked'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h: In function 'wait_on_page_locked':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:199: error: implicit declaration of function 'PageLocked'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:200: error: 'PG_locked' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:200: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:200: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h: In function 'wait_on_page_writeback':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:208: error: implicit declaration of function 'PageWriteback'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:209: error: 'PG_writeback' undeclared (first use in this function)
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/dma-mapping.h:17,
                 from include2/asm/dma-mapping.h:6,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/dma-mapping.h:52,
                 from include2/asm/sbus.h:10,
                 from include2/asm/dma.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/bootmem.h:8,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:26:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h: At top level:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:556: error: conflicting types for 'page_address'
include2/asm/highmem.h:61: error: previous implicit declaration of 'page_address' was here
make[2]: *** [init/main.o] Error 1
make[1]: *** [init] Error 2
make: *** [sub-make] Error 2

<--  snip  -->


> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

