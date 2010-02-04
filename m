Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0BDOgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:36:36 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:57397 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758292Ab0BDOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:36:34 -0500
Date: Thu, 4 Feb 2010 09:36:30 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BISECTED] post -rc6 regression, X server crash.
Message-ID: <20100204143630.GA18161@emergent.ellipticsemi.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been using 2.6.33-rc6 just fine, but after booting the latest and
greatest from Linus' git this morning, I'm greeted with a segfault
immediately after 'startx' on my ThinkPad T500.  There is nothing
abnormal in dmesg.

The backtrace from Xorg probably isn't too helpful since there aren't
debugging symbols available, but I'll post it anyway.  If someone wants
it, I can rebuild stuff with debugging info later today.

  ...
  (II) intel(0): Integrated Graphics Chipset: Intel(R) GM45
  ...
  (==) intel(0): Backing store disabled
  (==) intel(0): Silken mouse enabled
  (II) intel(0): Initializing HW Cursor
  (II) intel(0): No memory allocations

  Backtrace:
  0: /usr/bin/X (xorg_backtrace+0x28) [0x467498]
  1: /usr/bin/X (0x400000+0x673e5) [0x4673e5]
  2: /lib/libpthread.so.0 (0x7fc74b925000+0xedf0) [0x7fc74b933df0]
  3: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7fc748741000+0x2c885) [0x7fc74876d885]
  4: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7fc748741000+0x2dbff) [0x7fc74876ebff]
  5: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7fc748741000+0x136a5) [0x7fc7487546a5]
  6: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7fc748741000+0x13f12) [0x7fc748754f12]
  7: /usr/bin/X (AddScreen+0x1c5) [0x44d175]
  8: /usr/bin/X (InitOutput+0x239) [0x478c39]
  9: /usr/bin/X (0x400000+0x2423a) [0x42423a]
  10: /lib/libc.so.6 (__libc_start_main+0xe6) [0x7fc74a32ea26]
  11: /usr/bin/X (0x400000+0x23f89) [0x423f89]
  Segmentation fault at address (nil)
  
  Fatal server error:
  Caught signal 11 (Segmentation fault). Server aborting

I'm using Intel KMS with xf86-video-intel 2.10.0.  I bisected the issue
to the following commit.  Reverting the commit allows Xorg to start
again.

859ddf09743a8cc680af33f7259ccd0fd36bfe9d is the first bad commit
commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Feb 2 13:43:58 2010 -0800

    idr: fix a critical misallocation bug
    
    Eric Paris located a bug in idr.  With IDR_BITS of 6, it grows to three
    layers when id 4096 is first allocated.  When that happens, idr wraps
    incorrectly and searches the idr array ignoring the high bits.  The
    following test code from Eric demonstrates the bug nicely.
    
    #include <linux/idr.h>
    #include <linux/kernel.h>
    #include <linux/module.h>
    
    static DEFINE_IDR(test_idr);
    
    int init_module(void)
    {
    	int ret, forty95, forty96;
    	void *addr;
    
    	/* add 2 entries both with 4095 as the start address */
    again1:
    	if (!idr_pre_get(&test_idr, GFP_KERNEL))
    		return -ENOMEM;
    	ret = idr_get_new_above(&test_idr, (void *)4095, 4095, &forty95);
    	if (ret) {
    		if (ret == -EAGAIN)
    			goto again1;
    		return ret;
    	}
    	if (forty95 != 4095)
    		printk(KERN_ERR "hmmm, forty95=%d\n", forty95);
    
    again2:
    	if (!idr_pre_get(&test_idr, GFP_KERNEL))
    		return -ENOMEM;
    	ret = idr_get_new_above(&test_idr, (void *)4096, 4095, &forty96);
    	if (ret) {
    		if (ret == -EAGAIN)
    			goto again2;
    		return ret;
    	}
    	if (forty96 != 4096)
    		printk(KERN_ERR "hmmm, forty96=%d\n", forty96);
    
    	/* try to find the 2 entries, noticing that 4096 broke */
    	addr = idr_find(&test_idr, forty95);
    	if ((int)addr != forty95)
    		printk(KERN_ERR "hmmm, after find forty95=%d addr=%d\n", forty95, (int)addr);
    	addr = idr_find(&test_idr, forty96);
    	if ((int)addr != forty96)
    		printk(KERN_ERR "hmmm, after find forty96=%d addr=%d\n", forty96, (int)addr);
    	/* really weird, the entry which should be at 4096 is actually at 0!! */
    	addr = idr_find(&test_idr, 0);
    	if ((int)addr)
    		printk(KERN_ERR "found an entry at id=0 for addr=%d\n", (int)addr);
    
    	idr_remove(&test_idr, forty95);
    	idr_remove(&test_idr, forty96);
    
    	return 0;
    }
    
    void cleanup_module(void)
    {
    }
    
    MODULE_AUTHOR("Eric Paris <eparis@redhat.com>");
    MODULE_DESCRIPTION("Simple idr test");
    MODULE_LICENSE("GPL");
    
    This happens because when sub_alloc() back tracks it doesn't always do it
    step-by-step while the over-the-limit detection assumes step-by-step
    backtracking.  The logic in sub_alloc() looks like the following.
    
      restart:
        clear pa[top level + 1] for end cond detection
        l = top level
        while (true) {
    	search for empty slot at this level
    	if (not found) {
    	    push id to the next possible value
    	    l++
    A:	    if (pa[l] is clear)
    	        failed, return asking caller to grow the tree
    	    if (going up 1 level gives more slots to search)
    	        continue the while loop above with the incremented l
    	    else
    C:	        goto restart
    	}
    	adjust id accordingly to the found slot
    	if (l == 0)
    	    return found id;
    	create lower level if not there yet
    	record pa[l] and l--
        }
    
    Test A is the fail exit condition but this assumes that failure is
    propagated upwared one level at a time but the B optimization path breaks
    the assumption and restarts the whole thing with a start value which is
    above the possible limit with the current layers.  sub_alloc() assumes the
    start id value is inside the limit when called and test A is the only exit
    condition check, so it ends up searching for empty slot while ignoring
    high set bit.
    
    So, for 4095->4096 test, level0 search fails but pa[1] contains a valid
    pointer.  However, going up 1 level wouldn't give any more empty slot so
    it takes C and when the whole thing restarts nobody notices the high bit
    set beyond the top level.
    
    This patch fixes the bug by changing the fail exit condition check to full
    id limit check.
    
    Based-on-patch-from: Eric Paris <eparis@redhat.com>
    Reported-by: Eric Paris <eparis@redhat.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 11f618142df85b0ecbd1d5e459a1824c5c62a9f7 b75717e75129785e47eb22360d9761c29676620c M	lib

git bisect start
# bad: [e9e70bc14ea5974e21f5baecf95a123844c412b9] Merge branch 'for-linus' of git://git.monstr.eu/linux-2.6-microblaze
git bisect bad e9e70bc14ea5974e21f5baecf95a123844c412b9
# good: [ab658321f32770b903a4426e2a6fae0392757755] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect good ab658321f32770b903a4426e2a6fae0392757755
# bad: [03eac7bb882a75e6ee5705288f7ec36ad2e7d0d5] uartlite: fix crash when using as console
git bisect bad 03eac7bb882a75e6ee5705288f7ec36ad2e7d0d5
# good: [de5604231ce4bc8db1bc1dcd27d8540cbedf1518] mm: percpu-vmap fix RCU list walking
git bisect good de5604231ce4bc8db1bc1dcd27d8540cbedf1518
# bad: [859ddf09743a8cc680af33f7259ccd0fd36bfe9d] idr: fix a critical misallocation bug
git bisect bad 859ddf09743a8cc680af33f7259ccd0fd36bfe9d
# good: [9e9432c267e4047db98b9d4fba95099c6effcef9] block: fix bugs in bio-integrity mempool usage
git bisect good 9e9432c267e4047db98b9d4fba95099c6effcef9
# good: [1efe8fe1c2240acc476bed77740883df63373862] cfq-iosched: Do not idle on async queues
git bisect good 1efe8fe1c2240acc476bed77740883df63373862
# good: [1a45dcfe2525e9432cb4aba461d4994fc2befe42] Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
git bisect good 1a45dcfe2525e9432cb4aba461d4994fc2befe42

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
