Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZDMWGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZDMWGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZDMWGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:06:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZDMWGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:06:14 -0400
Date: Tue, 14 Apr 2009 00:02:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Serge Hallyn <serue@us.ibm.com>,
       Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_execute() needs mb() before
	test_bit(SLOW_WORK_PENDING)
Message-ID: <20090413220201.GA1368@redhat.com>
References: <20090413201348.GA16661@redhat.com> <20090413201306.GA16653@redhat.com> <32305.1239659266@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32305.1239659266@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > clear_bit_unlock() implies release semantics, iow we have a one-way barrier
> > before clear_bit().
>
> That is correct.  The stuff before the clear_bit_unlock() must not leak out
> past it.  SLOW_WORK_EXECUTING is a lock around the execution of the work item.
>
> > But we need the mb() semantics after clear_bit(), before we test
> > SLOW_WORK_PENDING. Otherwise we can miss SLOW_WORK_ENQ_DEFERRED if we race
> > slow_work_enqueue().
>
> But if you move the mb() to the other side, and reduce to clear_bit() you
> break the above non-reentrancy guarantee.

Hmm. Can't understand... please see below.

> > However, given that both clear_bit() and set_bit() use the same word,
> > perhaps this is not possible.
>
> I would assume clear_bit() and set_bit() on different bits of the same word
> must interact as if they're on the same bit, with regard to atomiticity, but I
> don't know for certain that it is guaranteed.

Yes, this was my concern. Reading the docs, I can't see how it is possible
to "prove" that clear_bit(x, WORD) + test_bit(y, WORD) can't be "reversed".

> > But in that case I don't understand why do we need clear_bit_unlock(), not
> > just clear_bit(), and how "mb is not needeed" could be derived from
> > documentation.
>
> As mentioned above, SLOW_WORK_EXECUTING is a lock against multiple entrance to
> the execution function.

Yes I see.

But why do we need the barrier before clear_bit(SLOW_WORK_EXECUTING) ?
We do have one after test_and_clear_bit(SLOW_WORK_PENDING) above, and it
should be enough, no?

Oleg.

