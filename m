Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXDUP4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXDUP4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXDUP4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:56:47 -0400
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:46290 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbXDUP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:56:47 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 01:55:20 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
In-Reply-To: <20070421121235.GA2044@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704220155.20856.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 22:12, Willy Tarreau wrote:
> I promised to perform some tests on your code. I'm short in time right now,
> but I observed behaviours that should be commented on.

>   Feels even better, mouse movements are very smooth even under high load.
>   I noticed that X gets reniced to -19 with this scheduler. I've not looked
>   at the code yet but this looked suspicious to me.

Looks like this code does it:

+int sysctl_sched_privileged_nice_level __read_mostly = -19;

allows anything that sets sched_privileged_task one way or another gets 
nice -19, and this is enabled by default.

--- linux-cfs-2.6.20.7.q.orig/arch/i386/kernel/ioport.c
+++ linux-cfs-2.6.20.7.q/arch/i386/kernel/ioport.c

+	if (turn_on) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		/*
+		 * Task will be accessing hardware IO ports,
+		 * mark it as special with the scheduler too:
+		 */
+		sched_privileged_task(current);
+	}

presumably that selects out X as a privileged task... and sets it to nice -19 
by default.

-- 
-ck
