Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYDUSsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYDUSsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYDUSse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:48:34 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:38748 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbYDUSsd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:48:33 -0400
Date: Mon, 21 Apr 2008 21:48:24 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86_64: fix kernel rodata NX setting
Message-ID: <20080421214824.0c5dc637@daedalus.pq.iki.fi>
In-Reply-To: <20080420202533.GA16538@Krystal>
References: <20080419184137.79957a07@daedalus.pq.iki.fi>
	<20080419161956.GA24685@Krystal>
	<20080420000657.20ba6b4b@daedalus.pq.iki.fi>
	<20080420005208.12ad32fd@daedalus.pq.iki.fi>
	<20080419215826.GC2831@Krystal>
	<20080420014206.5cd61d4a@daedalus.pq.iki.fi>
	<20080420000509.GA7496@Krystal>
	<20080420101408.518b21b4@daedalus.pq.iki.fi>
	<20080420194440.GA15319@Krystal>
	<20080420231838.21eaf426@daedalus.pq.iki.fi>
	<20080420202533.GA16538@Krystal>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 35922163c8054bd8d12df78ebae6a6a603760206 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Mon, 21 Apr 2008 21:36:09 +0300
Subject: [PATCH] x86_64: fix kernel rodata NX setting

Without CONFIG_DYNAMIC_FTRACE, mark_rodata_ro() would mark a wrong
number of pages as no-execute. The bug was introduced in the patch
"ftrace: dont write protect kernel text". The symptom was machine reboot
after a CPU hotplug.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

Is this ok? At least it works for me:

[  294.564032] CPU 1 is now offline
[  294.564359] lockdep: fixing up alternatives.
[  294.565799] SMP alternatives: switching to UP code
[  306.626760] lockdep: fixing up alternatives.
[  306.627080] SMP alternatives: switching to SMP code
[  306.638566] Booting processor 1/1 ip 6000
[  306.653079] Initializing CPU#1
[  306.736556] Calibrating delay using timer specific routine.. 3991.08 BogoMIPS (lpj=6649734)
[  306.739889] CPU: L1 I cache: 32K, L1 D cache: 32K
[  306.739889] CPU: L2 cache: 4096K
[  306.739889] CPU: Physical Processor ID: 0
[  306.739889] CPU: Processor Core ID: 1
[  306.739889] x86: PAT support disabled.
[  306.741127] CPU1: <6>Clockevents: could not switch to one-shot mode: lapic is not functional.
[  306.743865] Could not switch to high resolution mode on CPU 1
[  306.750580] Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a

 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7851773..d7ae30a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -792,7 +792,7 @@ void mark_rodata_ro(void)
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
-- 
1.5.3.7

