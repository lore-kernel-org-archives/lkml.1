Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXJOJ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXJOJ2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbXJOJ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:27:54 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:44328 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755916AbXJOJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:27:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NP/UD5s2EnsZ2XcWy5oefaMFkHyWMuKwdFMmFTcjSLm75c2DQK/Ttqm//tch2KknwAfa9LWaQe8ubyaT9kdv5pKjWaxLUxIwRSEKp2C7NTnB4kJD9C6udWO6YIls+0V3gw1cWu+ETyYWJBqbZT09Ngt8KOouOjYaU1P3NQ46lfA=  ;
X-YMail-OSG: Joa3W1IVM1l3nZd1eR5.LaqlkKpkKvuxNLdKewRfQXYVza8c
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH resend] ramdisk: fix zeroed ramdisk pages on memory pressure
Date: Tue, 16 Oct 2007 00:38:03 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710160006.19735.nickpiggin@yahoo.com.au> <200710151105.57442.borntraeger@de.ibm.com>
In-Reply-To: <200710151105.57442.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160038.03524.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 19:05, Christian Borntraeger wrote:
> Am Montag, 15. Oktober 2007 schrieb Nick Piggin:
> > On Monday 15 October 2007 18:28, Christian Borntraeger wrote:
> > > Andrew, this is a resend of a bugfix patch. Ramdisk seems a bit
> > > unmaintained, so decided to sent the patch to you :-).
> > > I have CCed Ted, who did work on the code in the 90s. I found no
> > > current email address of Chad Page.
> >
> > This really needs to be fixed...
>
> I obviously agree ;-)
> We have seen this problem happen several times.
>
> > I can't make up my mind between the approaches to fixing it.
> >
> > On one hand, I would actually prefer to really mark the buffers
> > dirty (as in: Eric's fix for this problem[*]) than this patch,
> > and this seems a bit like a bandaid...
>
> I have never seen these patches, so I cannot comment on them.

> > On the other hand, the wound being covered by the bandaid is
> > actually the code in the buffer layer that does this latent
> > "cleaning" of the page because it sadly doesn't really keep
> > track of the pagecache state. But it *still* feels like we
> > should be marking the rd page's buffers dirty which should
> > avoid this problem anyway.
>
> Yes, that would solve the problem as well. As long as we fix
> the problem, I am happy. On the other hand, do you see any
> obvious problem with this "bandaid"?

I don't think so -- in fact, it could be the best candidate for
a minimal fix for stable kernels (anyone disagree? if not, maybe
you could also send this to the stable maintainers?).

But I do want to have this fixed in a "nice" way. eg. I'd like
it to mark the buffers dirty because that actually results in
more reuse of generic kernel code, and also should make rd
behave more naturally (I like using it to test filesystems
because it can expose a lot more concurrency than something like
loop on tmpfs). It should also be possible to actually have
rd's buffer heads get reclaimed as well, preferably while
exercising the common buffer paths and without writing much new
code.

All of that is secondary to fixing the data corruption problem
of course! But the fact that those alternate patches do exist now
means I want to just bring them into the discussion again before
merging one or the other.
