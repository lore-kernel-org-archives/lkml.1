Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYHMRXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYHMRXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYHMRXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:23:44 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:65120 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYHMRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:23:43 -0400
X-BigFish: VPS-22(z21eWz936fQzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5JUYZ-01-IMZ-01
Content-Disposition: inline
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][retry 1] 2.6.27-rc2: invalidate caches before going into suspend
Date: Wed, 13 Aug 2008 12:28:50 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <200808131228.50415.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 13 Aug 2008 17:23:31.0376 (UTC) FILETIME=[4EB24B00:01C8FD69]
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

diff -r 1e74a821dd00 arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_32.c	Wed Aug 13 07:03:35 2008 -0500
@@ -95,7 +95,6 @@ static inline void play_dead(void)
 {
 	/* This must be done before dead CPU ack */
 	cpu_exit_clear();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
@@ -104,6 +103,7 @@ static inline void play_dead(void)
 	 * With physical CPU hotplug, we should halt the cpu
 	 */
 	local_irq_disable();
+	wbinvd();
 	while (1)
 		halt();
 }
diff -r 1e74a821dd00 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c	Tue Aug 12 12:04:12 2008 -0500
+++ b/arch/x86/kernel/process_64.c	Wed Aug 13 07:03:54 2008 -0500
@@ -93,12 +93,12 @@ static inline void play_dead(void)
 static inline void play_dead(void)
 {
 	idle_task_exit();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
 
 	local_irq_disable();
+	wbinvd();
 	while (1)
 		halt();
 }

