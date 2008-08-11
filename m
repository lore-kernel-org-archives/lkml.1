Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbYHKMDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbYHKMDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYHKMD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:03:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYHKMD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:03:27 -0400
Date: Mon, 11 Aug 2008 14:02:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811120231.GC23529@elte.hu>
References: <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <87zlnj24qc.fsf@basil.nowhere.org> <1218453726.10800.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218453726.10800.63.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > The problem is that it means any printk data output that is more 
> > than DMESG-BUFFER-SIZE bytes during one clock tick is going to lose 
> > data. It loses the natural adaption to higher printk rates that you 
> > got previously.
> > 
> > Now we could say that for debugging etc. people should switch to 
> > other mechanisms like relayfs, but I would still worry about some 
> > corner cases where losing printk data that wasn't lost before could 
> > be a severe regression (e.g. consider firewall log messages or 
> > similar)

That's a rather misleading argument, because klogd as it stands today is 
already lossy: you can overflow it with enough printk data. (It's rather 
easy to trigger it as well, so nobody sane relies on it as a reliable 
channel.)

Using relayfs and dynamic buffers would be a much worse approach because 
if we are out of buffer space it would be a robustness disaster to start 
allocating more RAM. (we want less coupling of printk to other kernel 
subsystems, not more coupling) Preallocating wont help either because it 
doesnt protect against sudden spikes.

> You only loose the msgs with klogd, console still gets everything. If 
> firewalls are generating that much data, perhaps its time to think 
> about alternative ways to channel that.

yeah, and note that klogd as it stands today is a lossy channel no 
matter what - there's nothing that keeps a really verbose kernel from 
flooding the buffer.

The issue Andi raises is largely independent of this change and there's 
three clean options to deal with it:

 - increase buffering (already possible, see CONFIG_LOG_BUF_SHIFT)

 - create a more reliable klogd channel with a dynamically
   shrinking/growing buffer (i very much doubt the complexity is
   worth it, and this one wont be 100% loss-less either)

 - use a reliable console

#1 is what distros use to maximize the yield of user bugreports, and #3
is what everyone who ultimately cares about massive printk output and 
reliable logging uses.

	Ingo
