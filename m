Return-Path: <linux-kernel-owner+w=401wt.eu-S2992462AbXDRN2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992462AbXDRN2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992466AbXDRN2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:28:47 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:45238 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992462AbXDRN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:28:46 -0400
Date: Wed, 18 Apr 2007 18:56:32 +0530
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PREEMPT_RT] [PATCH] Fix BUG: using smp_processor_id() in preemptible [00000000] code: nfsd/2852
Message-ID: <20070418132632.GC10065@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: ankita@in.ibm.com (Ankita Garg)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running some tests on 2.6.20-rt8 with DEBUG_PREEMPT on, I hit the following BUG:

BUG: using smp_processor_id() in preemptible [00000000] code: nfsd/2852
caller is drain_array+0x25/0x132

Call Trace:
 [<ffffffff8026d828>] dump_trace+0xbd/0x3d8
 [<ffffffff8026db87>] show_trace+0x44/0x6d
 [<ffffffff8026ddc8>] dump_stack+0x13/0x15
 [<ffffffff80355e2e>] debug_smp_processor_id+0xe3/0xf1
 [<ffffffff802e01b5>] drain_array+0x25/0x132
 [<ffffffff802e07ac>] __cache_shrink+0xd5/0x1a6
 [<ffffffff802e0a47>] kmem_cache_destroy+0x6c/0xe3
 [<ffffffff8846c809>] :nfsd:nfsd4_free_slab+0x16/0x21
 [<ffffffff8846c824>] :nfsd:nfsd4_free_slabs+0x10/0x36
 [<ffffffff8846daf9>] :nfsd:nfs4_state_shutdown+0x1a2/0x1ae
 [<ffffffff884570f8>] :nfsd:nfsd_last_thread+0x47/0x76
 [<ffffffff8839463a>] :sunrpc:svc_destroy+0x8d/0xd1
 [<ffffffff88394738>] :sunrpc:svc_exit_thread+0xba/0xc6
 [<ffffffff8845795f>] :nfsd:nfsd+0x2a3/0x2b8
 [<ffffffff802600f8>] child_rip+0xa/0x12

---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<ffffffff80355ddb>] .... debug_smp_processor_id+0x90/0xf1
.....[<ffffffff802e01b5>] ..   ( <= drain_array+0x25/0x132)


This patch fixes the above issue which arises due to the call to
smp_processor_id in drain_array() from mm/slab.c. smp_processor_id()
invocation is redundant here, as the call to slab_spin_lock_irq() 
already fills the value of this_cpu using raw_smp_processor_id().


o Patch to fix BUG in drain_array()

Signed-off-by: Ankita Garg <ankita2in.ibm.com>
--
 slab.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.20-rt8/mm/slab.c
===================================================================
--- linux-2.6.20-rt8.orig/mm/slab.c	2007-04-18 18:41:22.000000000 +0530
+++ linux-2.6.20-rt8/mm/slab.c	2007-04-18 18:42:21.000000000 +0530
@@ -4121,8 +4121,7 @@
 int drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
 		 struct array_cache *ac, int force, int node)
 {
-	int this_cpu = smp_processor_id();
-	int tofree;
+	int tofree, this_cpu;
 
 	if (!ac || !ac->avail)
 		return 0;


Regards,
-- 
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
