Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbXK3To5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbXK3To5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXK3Toq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:44:46 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53720 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753052AbXK3Top (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:44:45 -0500
To: jdike@addtoit.com
CC: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071129170205.GA7415@c2.user-mode-linux.org> (message from Jeff
	Dike on Thu, 29 Nov 2007 12:02:05 -0500)
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129170205.GA7415@c2.user-mode-linux.org>
Message-Id: <E1IyBmq-0005t7-Re@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 Nov 2007 20:44:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Found some interesting things, the delays are caused by

 1) throttle_vm_writeout()

     I removed it, Andrew worries about that, but hopefully there's a
     better solution to his worries

 2) atime updates

     my uml image did not have them turned off

 3) UML timer tick does not seem very reliable, here's what the below
    patch outputs during writing.  It shows the delay between ticks in
    milliseconds:

[42949415.110000] zzz - 267
[42949415.120000] zzz - 862
[42949415.130000] zzz - 71
[42949415.140000] zzz - 599
[42949415.170000] zzz - 3746
[42949415.190000] zzz - 2961
[42949415.200000] zzz - 3272
[42949415.210000] zzz - 253
[42949415.220000] zzz - 1692
[42949415.230000] zzz - 823
[42949415.280000] zzz - 344
[42949415.310000] zzz - 224

I guess, the ubd interrupts confuse the timekeeping somehow, but the
details are unclear.

Miklos


Index: linux/arch/um/kernel/time.c
===================================================================
--- linux.orig/arch/um/kernel/time.c	2007-11-30 20:19:17.000000000 +0100
+++ linux/arch/um/kernel/time.c	2007-11-30 20:21:24.000000000 +0100
@@ -23,6 +23,12 @@ unsigned long long sched_clock(void)
 void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	unsigned long flags;
+	static long long last;
+	long long now = os_nsecs() / 1000000;
+
+	if (now - last > 50)
+		printk("zzz - %lli\n", now-last);
+	last = now;
 
 	local_irq_save(flags);
 	do_IRQ(TIMER_IRQ, regs);
