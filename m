Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbZFOS0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbZFOS0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765218AbZFOS0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:26:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34862 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbZFOS0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:26:21 -0400
Date: Mon, 15 Jun 2009 20:25:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
Message-ID: <20090615182549.GD11248@elte.hu>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org> <1245077165.6800.497.camel@laptop> <Pine.LNX.4.64.0906151623570.5225@sister.anvils> <1245080486.6800.561.camel@laptop> <1245089065.13761.19316.camel@twins> <20090615181555.GA11248@elte.hu> <1245089943.13761.19334.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245089943.13761.19334.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-06-15 at 20:15 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > +static int kmap_type_to_context(enum km_type type)
> > > +{
> > > +	switch (type) {
> > > +	case KM_BOUNCE_READ:
> > > +		return KM_CTX_USER;
> > > +	case KM_SKB_SUNRPC_DATA:
> > > +		return KM_CTX_USER;
> > > +	case KM_SKB_DATA_SOFTIRQ:
> > > +		return KM_CTX_SOFTIRQ;
> > > +	case KM_USER0:
> > > +		return KM_CTX_USER;
> > > +	case KM_USER1:
> > > +		return KM_CTX_USER;
> > > +	case KM_BIO_SRC_IRQ:
> > > +		return KM_CTX_IRQ;
> > > +	case KM_BIO_DST_IRQ:
> > > +		return KM_CTX_IRQ;
> > > +	case KM_PTE0:
> > > +		return KM_CTX_USER;
> > > +	case KM_PTE1:
> > > +		return KM_CTX_USER;
> > > +	case KM_IRQ0:
> > > +		return KM_CTX_IRQ;
> > > +	case KM_IRQ1:
> > > +		return KM_CTX_IRQ;
> > > +	case KM_SOFTIRQ0:
> > > +		return KM_CTX_SOFTIRQ;
> > > +	case KM_SOFTIRQ1:
> > > +		return KM_CTX_SOFTIRQ;
> > > +	case KM_NMI:
> > > +		return KM_CTX_NMI;
> > > +	case KM_NMI_PTE:
> > > +		return KM_CTX_NMI;
> > > +	}
> > > +
> > > +	return KM_CTX_MAX;
> > 
> > why not do a very simple stack of atomic kmaps, like Hugh suggested?
> > 
> > That would mean a much simpler interface:
> > 
> > 	kaddr = kmap_atomic(page);
> > 
> > no index needed. The kunmap pops the entry off the stack:
> > 
> > 	kunmap_atomic(kaddr);
> > 
> > This becomes simpler too.
> > 
> > Now, a stack can be overflown by imbalance - but that's easy to 
> > detect and existing entries are easily printed and thus the source 
> > of the leak is easily identified.
> > 
> > In my book this design beats the current enumeration of kmap types 
> > indices hands down ... It would likely be much more robust as well, 
> > and much more easy to extend.
> > 
> > Am i missing any subtlety?
> 
> The above is mostly debug code used to validate the kmap_atomic
> conditions.
> 
> KM_CTX_NMI nests in KM_CTX_IRQ nests in KM_CTX_SOFTIRQ nests in
> KM_CTX_USER.
> 
> And validate that we indeed are in the context specified by the type.
> That is, it will warn if we use KM_IRQ1 with KM_CTX_IRQ from user
> context.
> 
> Some of this was already captured in the old kmap debug code which I
> removed.
> 
> But yes, I should write that nicer..

but ... look at the APIs i propose above. We dont need _any_ 
'types'.

That type enumeration is basically an open-coded allocator. If we do 
a _real_ allocator (a balanced stack of atomic kmaps) we dont need 
any of those indices, and all the potential for mismatch goes away 
as well - a stack nests trivially with IRQ and NMI and arbitrary 
other contexts.

	Ingo
