Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbZIDDuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbZIDDuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 23:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932556AbZIDDut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 23:50:49 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:60467 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbZIDDus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 23:50:48 -0400
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 23:50:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WFRjQkJBBnPBXLrGlXZsxV+3UB76IA+ixwmXoUi+F6pJxY+rCjs8vArUTJRlIsVNN3
         Xn/wEbL7k865iUi0TAvkLKEU/ymr3tX61Z6ComIcNUHzTw1RExzGp8WbEOWmomoy9OBo
         QK/SU2R7XjmCCUBTFpxQ/FtGCKGba4vImuAow=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       <ralf.roesch@rw-gmbh.de>, Nicholas Mc Guire <der.herr@hofr.at>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] [RT] fix the non-RT version of swap_get_cpu_var
Date: Fri,  4 Sep 2009 11:22:02 +0800
Message-Id: <1252034522-32653-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

The commit(f8382688) have converted swap to percpu locked, the
non-RT version of swap_get_cpu_var should be the same as the old
implementation, but in reality, it not works as the old one:

...
+#define swap_get_cpu_var(var, cpu)                     \
+       ({                                              \
+               (void)cpu;                              \
+               &get_cpu_var(var);                      \
+        })
...
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-       struct pagevec *pvec = &get_cpu_var(lru_add_pvecs)[lru];
+       struct pagevec *pvec;
+       int cpu;

+       pvec = swap_get_cpu_var(lru_add_pvecs, cpu)[lru];
        page_cache_get(page);
        if (!pagevec_add(pvec, page))
                ____pagevec_lru_add(pvec, lru);
-       put_cpu_var(lru_add_pvecs);
+       swap_put_cpu_var(lru_add_pvecs, cpu);
 }

Here is the point, the old version:

      pvec = &get_cpu_var(lru_add_pvecs)[lru];
     	   = & (get_cpu_var(lru_add_pvecs)[lru]);

new version from commit f8382688:

      pvec = ({ (void)cpu; &get_cpu_var(lru_add_pvecs); })[lru];
           = (&get_cpu_var(lru_add_pvecs)) [lru];

so, we can see, these two are really different. and it made the non-RT boot
fail:

...

ide-gd driver 1.18
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hda: cache flushes supported
 hda:Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 0000000000000000 000000001400c4e1 98000000013699d0 0000000000000000
$ 4   : 0000000000000000 98000000be04f980 0000000000000010 000000007fd78b57
$ 8   : 0000000000000001 0000000000200200 0000000000100100 98000000be00f210
$12   : 000000001400c4e1 000000001000001e ffffffffffffffff 98000000bd0180a8
$16   : 0000000000000000 98000000be04f998 fffffffb81a72600 ffffffff802d3270
$20   : 0000000000000000 0000000000000000 ffffffffffffffef ffffffff80667a90
$24   : 0000000000000228 ffffffff803ded88
$28   : 98000000be04c000 98000000be04f950 00000000003fffff ffffffff80200404
Hi    : 0000000000000000
Lo    : 0000000000000320
epc   : ffffffff80217194 do_ade+0x298/0x3bc
    Not tainted
ra    : ffffffff80200404 ret_from_exception+0x0/0x10
Status: 1400c4e3    KX SX UX KERNEL EXL IE
Cause : 00000014
BadVA : fffffffb81a72607
PrId  : 00006303 (ICT Loongson-2)
Modules linked in:
Process swapper (pid: 1, threadinfo=98000000be04c000, task=98000000be04b7d8, tls=0000000000000000)
Stack : ffffffff80666f60 ffffffff8025165c 98000000013699d0 0000000000000001
        98000000bd00ae30 ffffffff80200404 0000000000000000 000000001400c4e1
        000000007fd78b57 98000000013699d0 ffffffff80638070 0000000000000002
        fffffffb81a72600 000000007fd78b57 0000000000000001 0000000000200200
        0000000000100100 98000000be00f210 98000000be00f220 000000000000001d
        ffffffffffffffff 98000000bd0180a8 98000000013699d0 0000000000000001
        98000000bd00ae30 ffffffff802d3270 0000000000000000 0000000000000000
        ffffffffffffffef ffffffff80667a90 0000000000000228 ffffffff803ded88
        98000000bd00ae30 98000000bd00ae30 98000000be04c000 98000000be04fab0
        00000000003fffff ffffffff80275350 000000001400c4e3 0000000000000000
        ...
Call Trace:
[<ffffffff80217194>] do_ade+0x298/0x3bc
[<ffffffff80200404>] ret_from_exception+0x0/0x10
[<ffffffff8027fafc>] __lru_cache_add+0x94/0xd8
[<ffffffff80275350>] add_to_page_cache_lru+0x84/0xa8
[<ffffffff80275520>] read_cache_page_async+0xa8/0x1dc
[<ffffffff80275664>] read_cache_page+0x10/0x74
[<ffffffff802fed34>] read_dev_sector+0x34/0xe0
[<ffffffff802ff96c>] adfspart_check_ICS+0x44/0x1b0
[<ffffffff802ff6e4>] rescan_partitions+0x178/0x3a8
[<ffffffff802d3840>] __blkdev_get+0x238/0x318
[<ffffffff802feeb0>] register_disk+0xd0/0x15c
[<ffffffff8037c1e8>] add_disk+0xcc/0x128
[<ffffffff803fcbc4>] ide_gd_probe+0x170/0x1d0
[<ffffffff803e6e08>] driver_probe_device+0xbc/0x180
[<ffffffff803e6f38>] __driver_attach+0x6c/0xa4
[<ffffffff803e6508>] bus_for_each_dev+0x58/0xa4
[<ffffffff803e5bbc>] bus_add_driver+0xc8/0x284
[<ffffffff803e72d8>] driver_register+0xc4/0x17c
[<ffffffff8020fa5c>] do_one_initcall+0x64/0x18c
[<ffffffff806701d8>] kernel_init+0xe0/0x14c
[<ffffffff80212e5c>] kernel_thread_helper+0x10/0x18

Code: 001188f8  00b1882d  de220000 <b2420007> b6420000  24120000  1640000c  00a0202d  8ca20120
Disabling lock debugging due to kernel taint
note: swapper[1] exited with preempt_count 1
Kernel panic - not syncing: Attempted to kill init!

This patch will keep the swap_get_cpu_var as the one before commit f8382688,
and put "(void)cpu;" to swap_put_cpu_var() to avoid warning about unused
variable.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 mm/swap.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index a981acd..c2dfe5f 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -95,12 +95,13 @@ static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 	local_irq_restore(flags)
 
 #define swap_get_cpu_var(var, cpu)			\
-	({						\
-		(void)cpu;				\
-		&get_cpu_var(var);			\
-	 })
+	&get_cpu_var(var)			\
 
-#define swap_put_cpu_var(var, cpu)	put_cpu_var(var)
+#define swap_put_cpu_var(var, cpu)		\
+	({					\
+		(void)cpu;			\
+		put_cpu_var(var);		\
+	 })
 
 #define swap_per_cpu_lock(var, cpu)	&per_cpu(var, cpu)
 
-- 
1.6.2.1

