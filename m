Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbYKRKYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbYKRKYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKRKYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:24:42 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:36405 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751361AbYKRKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:24:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hZAXzQXlP1HJjmaSH87zN3nbN3EV+duOrazfI5p0yJu64c5A4Az2geGOWm/WApF4imPKTQO1tNdTiPfT9NGuPeNNXo0/1SB5+4Sct2/CuTYrjLWowOzyzz4dpMNVMVr8l53zFmNHP3qQEtCCo2wobsX95Y91pw+H8KON9BgtgTk=  ;
X-YMail-OSG: q.qK59AVM1nN1F39sjviEbodSBaBIgUoWCY6ixzNnWW2S5FBtyBKrsOw5S.9pCcUndq8r6nOpCwGTQoa0MwJP5iOLxIcEhLwEN5N0_XCTYti0EEcxcBLJMb8feUjo2..NRGjCfCm4El01MWofRhLpsVBPpoevyir7CUlO0uN
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Large stack usage in fs code (especially for PPC64)
Date: Tue, 18 Nov 2008 21:24:32 +1100
User-Agent: KMail/1.9.5
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <18722.2107.970887.768477@cargo.ozlabs.ibm.com> <alpine.LFD.2.00.0811171752450.18283@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811171752450.18283@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182124.33141.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2008 13:08, Linus Torvalds wrote:
> On Tue, 18 Nov 2008, Paul Mackerras wrote:
> > Also, you didn't respond to my comments about the purely software
> > benefits of a larger page size.
>
> I realize that there are benefits. It's just that the downsides tend to
> swamp the upsides.
>
> The fact is, Intel (and to a lesser degree, AMD) has shown how hardware
> can do good TLB's with essentially gang lookups, giving almost effective
> page sizes of 32kB with hardly any of the downsides. Couple that with

It's much harder to do this with powerpc I think because they would need
to calculate 8 hashes and touch 8 cachelines to prefill 8 translations,
wouldn't they?


> low-latency fault handling (for not when you miss in the TLB, but when
> something really isn't in the page tables), and it seems to be seldom the
> biggest issue.
>
> (Don't get me wrong - TLB's are not unimportant on x86 either. But on x86,
> things are generally much better).

The per-page processing costs are interesting too, but IMO there is more
work that should be done to speed up order-0 pages. The patches I had to
remove the sync instruction for smp_mb() in unlock_page sped up pagecache
throughput (populate, write(2), reclaim) on my G5 by something really
crazy like 50% (most of that's in, but I'm still sitting on that fancy
unlock_page speedup to remove the final smp_mb).

I suspect some of the costs are also in powerpc specific code to insert
linux ptes into their hash table. I think some of the synchronisation for
those could possibly be shared with generic code so you don't need the
extra layer of locks there.
