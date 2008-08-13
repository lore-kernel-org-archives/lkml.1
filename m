Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYHMQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYHMQgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHMQgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:36:09 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:37286 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYHMQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:36:08 -0400
X-BigFish: VPS-5(zz936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5JSRR-02-CXQ-01
Content-Disposition: inline
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org
Subject: invalidate caches before going into suspend
Date: Wed, 13 Aug 2008 11:41:17 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <200808131141.18003.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 13 Aug 2008 16:35:59.0295 (UTC) FILETIME=[AAB944F0:01C8FD62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU core is shut down, all of its caches need to be flushed
to prevent stale data from causing errors if the core is resumed.
Current Linux suspend code performs an assignment after the flush,
which can add dirty data back to the cache.  On some AMD platforms,
additional speculative reads have caused crashes on resume because
of this dirty data.

Relocate the cache flush to be the very last thing done before 
halting.


Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Mark Borden <mark.borden@amd.com>
Acked-by: Michael Hohmuth <michael.hohmuth@amd.com>

diff -r f3f819497a68 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c	Thu Aug 07 04:24:53 2008 -0500
+++ b/arch/x86/kernel/process_64.c	Tue Aug 12 07:11:36 2008 -0500
@@ -93,11 +93,11 @@ static inline void play_dead(void)
 static inline void play_dead(void)
 {
 	idle_task_exit();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
 
+	wbinvd();
 	local_irq_disable();
 	while (1)
 		halt();


