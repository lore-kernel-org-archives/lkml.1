Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXEAPzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXEAPzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXEAPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:55:23 -0400
Received: from www.osadl.org ([213.239.205.134]:60387 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753023AbXEAPzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:55:21 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of
	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mark Lord <lkml@rtr.ca>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <46374B1D.6050509@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>
	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>
		 <463741F1.7050706@rtr.ca>
	 <1178027285.5791.307.camel@localhost.localdomain> <46374B1D.6050509@rtr.ca>
Content-Type: text/plain
Date: Tue, 01 May 2007 17:57:38 +0200
Message-Id: <1178035058.5791.333.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 10:13 -0400, Mark Lord wrote:
> Of possible interest is that the bottom of the 25line screen capture
> differs somewhat from the 50line capture.. see for yourself.
> This is 100% consistent from boot to boot.
> 
> Using CONFIG_DETECT_SOFTLOCKUP=y eliminates the problem,
> so that's really got to be a huge clue, somehow ?

I twisted my brain, why the watchdog thread might change the problem and
I think I have a rough idea of the scenario. 

Can you apply the following patch, which prints out the CPU on which the
kernel messages are generated and upload the screenshot when the hang
happens ? Oh, please enable CONFIG_PRINTK_TIME or add "time" to the
kernel commandline.

	tglx

Index: linux-2.6.21/kernel/printk.c
===================================================================
--- linux-2.6.21.orig/kernel/printk.c
+++ linux-2.6.21/kernel/printk.c
@@ -567,10 +567,11 @@ asmlinkage int vprintk(const char *fmt, 
 				t = printk_clock();
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf,
-						"<%c>[%5lu.%06lu] ",
+						"<%c>[%5lu.%06lu] %d ",
 						loglev_char,
 						(unsigned long)t,
-					       nanosec_rem/1000);
+					       nanosec_rem/1000,
+					       printk_cpu);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);


