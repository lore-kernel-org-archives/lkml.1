Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXEIQ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXEIQ2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXEIQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:28:28 -0400
Received: from www.osadl.org ([213.239.205.134]:56825 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755692AbXEIQ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:28:28 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200705091942.22920.kernel@prachanda.hub>
References: <200705091942.22920.kernel@prachanda.hub>
Content-Type: text/plain
Date: Wed, 09 May 2007 18:31:20 +0200
Message-Id: <1178728280.3042.504.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 19:42 +0530, Anant Nitya wrote:
> Hi,
> Ever since I upgrade to 2.6.21/.1, system log is filled with following 
> messages if I enable CONFIG_NO_HZ=y, going through archives it seems ingo 
> sometime back posted some patch and now it is upstream, but its not helping 
> here. If I disable NOHZ by kernel command line nohz=off this problem 
> disappears. This system is P4/2.40GHz/HT with SMP/SMT on in kernel config. 
> One more thing that I noticed is this problem only arises while using X or 
> network otherwise plain command line with no network access don't trigger 
> this with nohz=on.

Is this independent of the load on the system ? i.e. : What happens if
you only use the console and run a kernel compile with -j4 ?

> dumdum@hahakaar [~]$ >>  grep NOHZ /var/log/messages
> May  8 03:38:14 rudra kernel: [  419.271195] NOHZ: local_softirq_pending 02
> May  8 03:38:14 rudra kernel: [  419.271663] NOHZ: local_softirq_pending 02

The patch below ratelimits the printk output, so your syslog is not
flooded anymore.

	tglx

Index: linux-2.6.21/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.21.orig/kernel/time/tick-sched.c
+++ linux-2.6.21/kernel/time/tick-sched.c
@@ -167,9 +167,15 @@ void tick_nohz_stop_sched_tick(void)
 		goto end;
 
 	cpu = smp_processor_id();
-	if (unlikely(local_softirq_pending()))
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       local_softirq_pending());
+	if (unlikely(local_softirq_pending())) {
+		static int ratelimit;
+
+		if (ratelimit < 10) {
+			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
+			       local_softirq_pending());
+			ratelimit++;
+		}
+	}
 
 	now = ktime_get();
 	/*


