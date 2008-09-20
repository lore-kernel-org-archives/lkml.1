Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYITVxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYITVxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYITVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:53:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYITVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:53:23 -0400
Date: Sat, 20 Sep 2008 17:53:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sitsofe Wheeler <sitsofe@yahoo.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls
In-Reply-To: <48D52FE3.6060803@yahoo.com>
Message-ID: <alpine.DEB.1.10.0809201739170.18130@gandalf.stny.rr.com>
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no>
 <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com> <48D50498.5050608@yahoo.com> <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com> <48D52FE3.6060803@yahoo.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Sep 2008, Sitsofe Wheeler wrote:

> Steven Rostedt wrote:
> > OK, that is probably the known bug you are hitting. Simply disable the
> > CONFIG_FTRACE_STARTUP_TEST and you should have the wakeup tracer. The bug is
> > with the test, not the tracer, so it should not hurt you.
> 
> Thanks - this made the wakeup tracer appear a you said. I have put two wakeup
> traces up:
> 
> http://sucs.org/~sits/test/eeepc-debug/20080920/latency_trace.txt.gz
> http://sucs.org/~sits/test/eeepc-debug/20080920/trace.txt.gz
> (each file is around 6Mbytes uncompressed)
> 
> Here's a small extract of latency_trace.txt:
> 
> > # tracer: wakeup
> > #
> > wakeup latency trace v1.1.5 on 2.6.27-rc6skw-dirty
> > --------------------------------------------------------------------
> >  latency: 3232905 us, #65620/6180619, CPU#0 | (M:desktop VP:0, KP:0, SP:0

Peter, these times are crazy, mainly due to the cpu_clock. He probably 
wants to use the sched_clock. Below is a patch to use it instead.

Sitsofe, I notice that the trace states "desktop". This means that you
are running with CONFIG_PREEMPT_VOLUNTARY. You want 
CONFIG_PREEMPT.

[...]
> 
> Is it intentional that the last event has a time earlier closer to that of the
> first event?
> 

Change the config, and see what you get with this patch:

Note this is not compiled tested:

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linus.git/kernel/trace/trace.c
===================================================================
--- linus.git.orig/kernel/trace/trace.c	2008-09-20 17:49:00.000000000 -0400
+++ linus.git/kernel/trace/trace.c	2008-09-20 17:49:35.000000000 -0400
@@ -60,7 +60,7 @@ ns2usecs(cycle_t nsec)
 
 cycle_t ftrace_now(int cpu)
 {
-	return cpu_clock(cpu);
+	return sched_clock();
 }
 
 /*


-- Steve

