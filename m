Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbZAZPSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbZAZPSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZAZPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:18:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZAZPS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:18:29 -0500
Date: Mon, 26 Jan 2009 16:17:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Papi <ptools-perfapi@cs.utk.edu>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090126151746.GH9128@elte.hu>
References: <20090121185021.GA8852@elte.hu> <497D0C81.5040406@linux.vnet.ibm.com> <7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> Hi,
> 
> Corey brings up an interesting problem which I wanted to comment on.
> 
> The current proposal hinges on the idea that by interpreting a single 
> value the kernel can understand what the user wants to measure. For 
> instance, if I pass type=0, then the kernel understands I want to 
> measure CPU_CYCLES. Given that the number of events and their unit mask 
> combinations can be large, the proposal also provides a "raw" mode, 
> where the content of the type field is interpreted as the raw value to 
> put into a register.
> 
> This is where there is an issue because with several PMU models, 
> including on X86, using the raw bit + 64 value is not enough to figure 
> out what the user wants to measure. This happens when the PMU has more 
> than counters. Thus, interpreting each raw value has the event code may 
> be wrong. To remain on familiar territory, the Nehalem uncore PMU has an 
> opcode matcher register, that uses a 64-bit value. On AMD64 Family 10h, 
> you have IBS. But I could give examples on Itanium with opcode matchers, 
> range restrictions. Corey provided other examples for Power. The API has 
> to provide a way to express what the raw value is meant for: counter, 
> matcher, filter...

this can be done in a number of ways (in order of increasing levels of 
abstraction):

- the raw type is kept wide enough. Paul already requested the raw type
  to be widened to 128 bits to express certain PowerPC features.

- or the PMU capability is expressed as a special counter type (if it's
  useful enough) - and then either the write() method or ioctl is extended
  to express attributes we want to set/change while a counter is running.

- or the highest level counter / hw event data type is extended with new
  attribute field(s).

My feeling is that we generally want such hw features to start small - 
i.e. at the raw type level initially. Then we can allow them to climb the 
ladder, if they prove their utility in practice. We've got space reserved 
in the ABI to allow for growth like this.

	Ingo
