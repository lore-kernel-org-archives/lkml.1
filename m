Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbZCCQiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbZCCQiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZCCQiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:38:03 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:29825 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753408AbZCCQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:38:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BRTDbC5bcYaVIKYiPcERvv/lkHRrZhWUlsb3aSEwoKOLIJ+mwdhE12siQtzCb+Mnww4Z8hMOjwU3enhiAb8G8I4eH7T5Vmhx6K10c/t3BJF6e9jADXRLVDxRo4hUIaSJEYjThh53aYZRfX7Dp74fpl1MpqC7nV/lniFmjEOZbGY=  ;
X-YMail-OSG: xD5i.nAVM1n10b4e3wphH41YQIPNuEUAm.94rm_Oxn1eYWJZ33mrXhDItiNpGHH1wD6QPSF7nB_mtHl5ywtlgqqSFdYmFRJ8Zrs17hvHwhrmlzM8CXJmf5AgDhtcbxQn0QzhKtpz.Xam33cnrt3nN6n6vkln7zQ2Jb_rqM9AwY7_GbBHObUDxyM6jTuM6Wk47D1mtBaHNNrrWxF0llV_7tSN0CJBcSHALrs-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Wed, 4 Mar 2009 14:37:15 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <200903031521.00217.nickpiggin@yahoo.com.au> <20090303090252.GC11484@elte.hu>
In-Reply-To: <20090303090252.GC11484@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041437.16360.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009 20:02:52 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 03 March 2009 08:16:23 Linus Torvalds wrote:
> > > On Mon, 2 Mar 2009, Nick Piggin wrote:
> > > > I would expect any high performance CPU these days to combine entries
> > > > in the store queue, even for normal store instructions (especially
> > > > for linear memcpy patterns). Isn't this likely to be the case?
> > >
> > > None of this really matters.
> >
> > Well that's just what I was replying to. Of course
> > nontemporal/uncached stores can't avoid cc operations either,
> > but somebody was hoping that they would avoid the
> > write-allocate / RMW behaviour. I just replied because I think
> > that modern CPUs can combine stores in their store queues to
> > get the same result for cacheable stores.
> >
> > Of course it doesn't make it free especially if it is a cc
> > protocol that has to go on the interconnect anyway. But
> > avoiding the RAM read is a good thing anyway.
>
> Hm, why do you assume that there is a RAM read?

I don't ;) Re-read back a few posts. I thought that nontemporal stores
would not necessarily have an advantage with avoiding write allocate
behaviour. Because I thought CPUs should combine stores in their store
buffer.

Doing some simple tests is showing that a nontemporal stores takes about
0.7 the time of doing a rep stosq here, if the destination is much larger
than cache. So the CPU isn't quite as clever as I assumed.

I can't find any references to back up my assumption, but I thought I
heard it somewhere. It might have been in relation to some powerpc CPUs
not requiring their cacheline clear instruction because they combine
store buffer entries. But I could be way off.


> A sufficiently
> advanced x86 CPU will have good string moves with full cacheline
> transfers - removing partial cachelines and removing the need
> for the physical read.

I thought this should be the case even with a plain sequence of normal
stores. But that's taking about 1.4 the time of rep sto, so again
maybe I overestimate. I don't know.

