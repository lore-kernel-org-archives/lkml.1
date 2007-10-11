Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbXJLJjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbXJLJjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759615AbXJLJjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:39:24 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:28909 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759820AbXJLJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:39:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FsTAvTUY7DK2XSw2Lbsm8YNa7GRtIl81zeLks1UG72zZtMwD/eKNewYLP5k0VAJFkC8l8GzHU9AfJwEHCo3DJkEfzdD+rAEsd4cbgqWkjqS0qThfaW5jHPvfWbNDb20fUWViN+SBM6yNbyD2rtLQSCBEeonvdd1pxCojI67uXpc=  ;
X-YMail-OSG: HgH_ApQVM1lhz3s3BE4cJ.L7lAFfXRGQmThgPGOAZi0wmWtdzHsP98DOJb8mb0.886_YUx8eVA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm: avoid dirtying shared mappings on mlock
Date: Fri, 12 Oct 2007 03:07:40 +1000
User-Agent: KMail/1.9.5
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org> <1192179805.27435.6.camel@twins> <200710120257.05960.nickpiggin@yahoo.com.au>
In-Reply-To: <200710120257.05960.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120307.40303.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 02:57, Nick Piggin wrote:
> On Friday 12 October 2007 19:03, Peter Zijlstra wrote:
> > Subject: mm: avoid dirtying shared mappings on mlock
> >
> > Suleiman noticed that shared mappings get dirtied when mlocked.
> > Avoid this by teaching make_pages_present about this case.
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Acked-by: Suleiman Souhlal <suleiman@google.com>
>
> Umm, I don't see the other piece of this thread, so I don't
> know what the actual problem was.

Found it, but no more clues. Presumably it's some horrible
google workload... they're pretty happy to carry these kinds
of patches internally, right? ;)


> But I would really rather not do this. If you do this, then you
> now can get random SIGBUSes when you write into the memory if it
> can't allocate blocks or ... (some other filesystem specific
> condition).
>
> I agree it feels suboptimal, but we've _always_ done this, right?
> Is it suddenly a problem? Unless a really nice general way is
> made to solve this, optimising it like this makes it harder to
> ensure good semantics for all corner cases I think (and then once
> the optimisation is in place, it's a lot harder to remove it).

Yeah, I really would rather not do this. If we actually go
through the whole fault path in mlock, then it doesn't
really matter what future baggage we attach to fault handlers...
(OK, we still technically have some problems with invalidations,
but mostly they're avoidable unless doing something silly).

How about just doing another PROT_READ mmap, and mlocking that?
(I was going to suggest another syscall, but that's probably
overkill).
