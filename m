Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753205AbYLRKss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYLRKss (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYLRKsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:48:38 -0500
Received: from www.tglx.de ([62.245.132.106]:41205 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYLRKsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:48:37 -0500
Date: Thu, 18 Dec 2008 11:48:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
 interrupt infinite loop
In-Reply-To: <20081218103459.GD10513@elte.hu>
Message-ID: <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: fix a system hang on slow systems
> > 
> > While testing the function graph tracer on VirtualBox, I had a system hang
> > immediatly after enabling the tracer.
> >
> > If hrtimer is enabled on kernel, a slow system can spend too much time 
> > during tracing the hrtimer_interrupt which will do eternal loops, 
> > assuming it always have to retry its process because too much time 
> > elapsed during its time update. Now we provide a feature which lurks at 
> > the number of retries on hrtimer_interrupt. After 10 retries, the 
> > function graph tracer will definetly stop its tracing.
> 
> hm, i dont really like this solution - it just works around the problem by 
> 'speeding up' the system. If we have a _real_ slow system, there's no such 
> way for us to speed it up.
> 
> Thomas, what do you think - would you expect this lockup to happen on 
> really slow systems? If yes, is there a way we could avoid it from 
> happening - by driving some sort of 'mandatory interval', that is doubled 
> in size every time we detect such a bad hrtimer loop?

In reality I have not seen such a problem yet, even on an old real
slow P1 which I tricked to do highres, but of course if we add such
time consuming debugs and make it slow enough the system will spend
all the time running the tick timer :)

We should at least warn once about such a loop. 

I'm not sure about the mandatory interval though: 

Try the same test with HZ=1000 periodic mode (HIGHRES/NOHZ=off) and I
bet you see the same problem, just not in hrtimer_interrupt().

Thanks,

	tglx
