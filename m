Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZBKQtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZBKQtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbZBKQtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:49:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbZBKQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:49:07 -0500
Date: Wed, 11 Feb 2009 11:49:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
In-Reply-To: <20090211153650.GA19576@elte.hu>
Message-ID: <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009, Ingo Molnar wrote:

> 
> > > Steven Rostedt (7):
> > >       ring-buffer: add NMI protection for spinlocks
> > >       nmi: add generic nmi tracking state
> 
> hm, this commit breaks a number of non-x86 architectures the following way:
> 
> In file included from /home/mingo/tip/include/linux/interrupt.h:12,
>                  from /home/mingo/tip/arch/ia64/include/asm/mca.h:16,
>                  from /home/mingo/tip/arch/ia64/kernel/asm-offsets.c:17:
> /home/mingo/tip/include/linux/hardirq.h:67:2: #error PREEMPT_ACTIVE too high!
> make[2]: *** [arch/ia64/kernel/asm-offsets.s] Error 1
> 
> Alpha and ARM are broken too. (and possibly others)

Looking at this, it doesn't seem like it should be a problem. Perhaps the 
CPP is treating the number as signed. Does this patch fix the compile?

-- Steve

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index f3cf86e..9bd4302 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -63,7 +63,7 @@
 
 #define NMI_OFFSET	(PREEMPT_ACTIVE << 1)
 
-#if NMI_OFFSET >= 0x80000000
+#if NMI_OFFSET >= 0x80000000UL
 #error PREEMPT_ACTIVE too high!
 #endif
 
