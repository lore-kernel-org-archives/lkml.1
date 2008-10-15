Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYJORpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYJORpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYJORph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:45:37 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43980 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752876AbYJORph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:45:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qVoHfZ2NYm3nF2r0YSxBo6po88pCVncjA5DPUYyLe6bjDelPF4uPF+jLsuE09RTJS6nqpMN2tMUekhuJ7n7T2Bv8+8S/qmGgh7ag/isLE4kAuikCe6qRGR7gwiNKbvpIuaeC+LLdLzrBNKYOAsyGmpjjuDHmaEeSiMvNr+qRqnQ=  ;
X-YMail-OSG: gDwv9w4VM1kKq1w2k8ohMes8L27xV_fLJBWdJTld2P20xh_cbiAyQaFOLlQTg8LRBFehhqfah.B1li_FsdR4QTdc2KqQPCl30hWmOXdQ.fuRLlOS_OnuK15A4dq6NHxDw18CCwPG6tfM93pqH2VedmBu.Cul4ZdAnGVcHOIo
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 04:45:28 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160410.49894.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160445.28781.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 04:33, Linus Torvalds wrote:
> On Thu, 16 Oct 2008, Nick Piggin wrote:
> > Now they allocate these guys, take a lock, then insert them into the
> > page tables. The lock is only an acquire barrier, so it can leak past
> > stores.
>
> I think that Matt's point was that the code is buggy regardless of any
> ctor or not.
>
> If you make an allocation visible to other CPU's, you would need to make
> sure that allocation is stable with a smp_wmb() before you update the
> pointer to that allocation.

What do you mean by the allocation is stable? Let's just talk in loads and
stores and order. You need to make sure previous stores to initialise the
object become visible before subsequent store to make the object visible.
No questions about that (I think that's what you meant by make the alloc
stable).

1. However, if the object is already fully initialised at the point the caller
gets it out of the allocator, then the caller doesn't need to make any
stores to initialise it obviously.

2. I think it could be easy to assume that the allocated object that was
initialised with a ctor for us already will have its initializing stores
ordered when we get it from slab.

So in my page table almost-example, by combining 1 and 2, one might think
it is OK to leave out those smp_wmb()s. And it would be valid code if all
those assumptions _were_ true.

