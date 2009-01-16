Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZAPXMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZAPXMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZAPXMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:12:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775AbZAPXMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:12:32 -0500
Date: Sat, 17 Jan 2009 00:11:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Maynard Johnson <maynardj@us.ibm.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20090116231139.GB23447@elte.hu>
References: <20081214212829.GA9435@elte.hu> <18758.18810.350923.806445@cargo.ozlabs.ibm.com> <1229437341.7025.11.camel@twins> <18760.13407.568536.198724@cargo.ozlabs.ibm.com> <87ljuf1s75.fsf@basil.nowhere.org> <4970CB6F.9000301@linux.vnet.ibm.com> <497106C5.60703@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497106C5.60703@us.ibm.com>
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


* Maynard Johnson <maynardj@us.ibm.com> wrote:

> > Over time, it seems clear that we will see multi-core processor 
> > designs with increasingly large uncore/nest facilities, so this could 
> > become more and more of an issue.

> Ingo, I'll add my voice to the chorus here.  To reiterate the point, 
> some PMUs count events that are external to the processor cores, and 
> these events cannot be attributed to any one particular CPU -- and 
> certainly not to a particular pid.  The current interface has a 
> restriction that the user cannot pass -1 for both pid and cpu.  But it 
> seems to me that's exactly what would be needed for such off-core 
> events.  Can this feature fit in with the current interface or is some 
> sort of extension needed?

They fit in just fine, they just will have constraints that dont allow 
their scheduling in a conflicting way. I.e. you'll only be able to occupy 
it from a single counter per physical package - but otherwise it still 
behaves like a normal counter if you define a single such counter per 
physical package, as a percpu counter. (they dont make much sense as task 
counters)

Btw., those kind of constraints make them quite noisy and hard to 
interpret as well - because they summarize per physical package 
characteristics (of up to 8 logical CPUs on Nehalem for example) and 
cannot be tied to tasks easily.

I'm not dismissing them entirely: they do give an overview of "all stuff 
that happens" at that level, and they do show a few things that is 
obviously tied to the 'uncore' of a CPU (the cache, the memory interlink, 
etc.), which cannot be provided by the normal PMCs - but they are too 
highlevel to really be useful for finegrained analysis and for eventing.

In any case, despite their limitations they can still be provided just 
fine, and any limitations they have is an inherent limitation of those 
hardware counters, not of the perfcounters framework.

	Ingo
