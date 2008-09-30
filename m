Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYI3Sp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYI3Sp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYI3Soi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:44:38 -0400
Received: from www.tglx.de ([62.245.132.106]:48984 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYI3Sog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:44:36 -0400
Message-Id: <20080930121338.010172527@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 30 Sep 2008 18:44:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>
Subject: [patch 2/3] timer_list: print cpu number of clockevents device
References: <20080930121310.879471299@linutronix.de>
Content-Disposition: inline;
	filename=timerlist-print-cpu-number-of-clockevents-device.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per cpu clock events device output of timer_list lacks an
association of the device to the cpu which is annoying when looking at
the output of /proc/timer_list from a 128 way system. 

Add the CPU number info and mark the broadcast device in the device
list printout.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer_list.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/time/timer_list.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timer_list.c
+++ linux-2.6-tip/kernel/time/timer_list.c
@@ -184,12 +184,16 @@ static void print_cpu(struct seq_file *m
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 static void
-print_tickdevice(struct seq_file *m, struct tick_device *td)
+print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 {
 	struct clock_event_device *dev = td->evtdev;
 
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
+	if (cpu < 0)
+		SEQ_printf(m, "Broadcast device\n");
+	else
+		SEQ_printf(m, "Per CPU device: %d\n", cpu);
 
 	SEQ_printf(m, "Clock Event Device: ");
 	if (!dev) {
@@ -223,7 +227,7 @@ static void timer_list_show_tickdevices(
 	int cpu;
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
-	print_tickdevice(m, tick_get_broadcast_device());
+	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
 		   tick_get_broadcast_mask()->bits[0]);
 #ifdef CONFIG_TICK_ONESHOT
@@ -233,7 +237,7 @@ static void timer_list_show_tickdevices(
 	SEQ_printf(m, "\n");
 #endif
 	for_each_online_cpu(cpu)
-		   print_tickdevice(m, tick_get_device(cpu));
+		print_tickdevice(m, tick_get_device(cpu), cpu);
 	SEQ_printf(m, "\n");
 }
 #else


