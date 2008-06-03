Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYFCEdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYFCEdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYFCEd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:33:27 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:48302 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751664AbYFCEd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:33:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k0ZN5QniJyMzfoZiaa4PtdXSLhwKmttPdVEgLI30xnTsRP763MVseS5TGa12/qye/DdGSecz1+ksRF8KU0TkAdPe4kzr/t9seTpIJ7aJq0IUQRse1aq9Mf8SzpR7LDMn66sWUOE0uZewNTb04UYsHs/+D1LLVjRfzpDBEMjelU4=  ;
X-YMail-OSG: s.aIPP0VM1kFBwUVQOkHmT7zT4tc0S98h._ey3rIQlEF.Mq4o7g.3OVI_NTNoWazmd_7AmEmFycQgjo00QGwnmIGGkJmEw2ROwXBD_c4qg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jes Sorensen <jes@sgi.com>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 3 Jun 2008 14:33:11 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Higdon <jeremy@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       benh@kernel.crashing.org, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
References: <1211852026.3286.36.camel@pasglop> <20080531075242.GC108600@sgi.com> <4843C3D7.7000609@sgi.com>
In-Reply-To: <4843C3D7.7000609@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031433.12460.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 19:56, Jes Sorensen wrote:
> Jeremy Higdon wrote:
> > We don't actually have that problem on the Altix.  All writes issued
> > by CPU X will be ordered with respect to each other.  But writes by
> > CPU X and CPU Y will not be, unless an mmiowb() is done by the
> > original CPU before the second CPU writes.  I.e.
> >
> > 	CPU X	writel
> > 	CPU X	writel
> > 	CPU X	mmiowb
> >
> > 	CPU Y	writel
> > 	...
> >
> > Note that this implies some sort of locking.  Also note that if in
> > the above, CPU Y did the mmiowb, that would not work.
>
> Hmmm,
>
> Then it's less bad than I thought - my apologies for the confusion.
>
> Would we be able to use Ben's trick of setting a per cpu flag in
> writel() then and checking that in spin unlock issuing the mmiowb()
> there if needed?

Yes you could, but your writels would still not be strongly ordered
within (or outside) spinlock regions, which is what Linus wants (and
I kind of agree with).

This comes back to my posting about mmiowb and io_*mb barriers etc.

Despite what you say, what you've done really _does_ change the semantics
of wmb() for all drivers. It is a really sad situation we've got ourselves
into somehow, AFAIKS in the hope of trying to save ourselves a tiny bit
of work upfront :( (this is not just the sgi folk with mmiowb I'm talking
about, but the whole random undefinedness of ordering and io barriers).

The right way to make any change is never to weaken the postcondition of
an existing interface *unless* you are willing to audit the entire tree
and fix it. Impossible for drivers, so the correct thing to do is introduce
a new interface, and move things over at an easier pace. Not rocket science.

The argument that "Altix only uses a few drivers so this way we can just
fix these up rather than make big modifications to large numbers of drivers"
is bogus. It is far worse even for Altix if you make incompatible changes,
because you first *break* every driver on your platform, then you have to
audit and fix them. If you make compatible changes, then you have to do
exactly the same audits to move them over to the new API, but you go from
slower->faster rather than broken->non broken. As a bonus, you haven't
got random broken stuff all over the tree that you forgot to audit.

I don't know how there is still so much debate about this :(

I have a proposal: I am a neutral party here, not being an arch maintainer,
so I'll take input and write up a backward compatible API specification
and force everybody to conform to it ;)
