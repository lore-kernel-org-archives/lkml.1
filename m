Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbZFOSTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbZFOSTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932565AbZFOSTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:19:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738AbZFOSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:19:38 -0400
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090615181555.GA11248@elte.hu>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
	 <1245077165.6800.497.camel@laptop>
	 <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
	 <1245080486.6800.561.camel@laptop> <1245089065.13761.19316.camel@twins>
	 <20090615181555.GA11248@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Jun 2009 20:19:03 +0200
Message-Id: <1245089943.13761.19334.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 20:15 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > +static int kmap_type_to_context(enum km_type type)
> > +{
> > +	switch (type) {
> > +	case KM_BOUNCE_READ:
> > +		return KM_CTX_USER;
> > +	case KM_SKB_SUNRPC_DATA:
> > +		return KM_CTX_USER;
> > +	case KM_SKB_DATA_SOFTIRQ:
> > +		return KM_CTX_SOFTIRQ;
> > +	case KM_USER0:
> > +		return KM_CTX_USER;
> > +	case KM_USER1:
> > +		return KM_CTX_USER;
> > +	case KM_BIO_SRC_IRQ:
> > +		return KM_CTX_IRQ;
> > +	case KM_BIO_DST_IRQ:
> > +		return KM_CTX_IRQ;
> > +	case KM_PTE0:
> > +		return KM_CTX_USER;
> > +	case KM_PTE1:
> > +		return KM_CTX_USER;
> > +	case KM_IRQ0:
> > +		return KM_CTX_IRQ;
> > +	case KM_IRQ1:
> > +		return KM_CTX_IRQ;
> > +	case KM_SOFTIRQ0:
> > +		return KM_CTX_SOFTIRQ;
> > +	case KM_SOFTIRQ1:
> > +		return KM_CTX_SOFTIRQ;
> > +	case KM_NMI:
> > +		return KM_CTX_NMI;
> > +	case KM_NMI_PTE:
> > +		return KM_CTX_NMI;
> > +	}
> > +
> > +	return KM_CTX_MAX;
> 
> why not do a very simple stack of atomic kmaps, like Hugh suggested?
> 
> That would mean a much simpler interface:
> 
> 	kaddr = kmap_atomic(page);
> 
> no index needed. The kunmap pops the entry off the stack:
> 
> 	kunmap_atomic(kaddr);
> 
> This becomes simpler too.
> 
> Now, a stack can be overflown by imbalance - but that's easy to 
> detect and existing entries are easily printed and thus the source 
> of the leak is easily identified.
> 
> In my book this design beats the current enumeration of kmap types 
> indices hands down ... It would likely be much more robust as well, 
> and much more easy to extend.
> 
> Am i missing any subtlety?

The above is mostly debug code used to validate the kmap_atomic
conditions.

KM_CTX_NMI nests in KM_CTX_IRQ nests in KM_CTX_SOFTIRQ nests in
KM_CTX_USER.

And validate that we indeed are in the context specified by the type.
That is, it will warn if we use KM_IRQ1 with KM_CTX_IRQ from user
context.

Some of this was already captured in the old kmap debug code which I
removed.

But yes, I should write that nicer..

/me goes clean up
