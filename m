Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYG2Bjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYG2Bjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYG2Bjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:39:45 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:22030 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751958AbYG2Bjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:39:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gHliVIQyUkUrrKby2BRYPVqDjLUCPDsfyOsnZk06lJLSApvdXLYgcR7L23y0k5fNg2ln4KTXMaEzMOQTBVnuoN8C7J87tZ0PljkgqTiBUq2DKGNG+lXAwyrrp8DM84hioR28xYTjhz77bQt8gvN0O7Nijujdt9bCEXG5kJrwcoI=  ;
X-YMail-OSG: QF8sby8VM1mq9B24G3rNpTL_Rom_zqYSYo7n2_QVKR.0stQQ0dzmHYz36fjdvUeVHfaqEIQiOT50zcQJtpta5gAePcnO_Yr9z21a6cYhwfhpH4.bhjtPZUSnw2o6YsifxRs-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
Date: Tue, 29 Jul 2008 11:39:33 +1000
User-Agent: KMail/1.9.5
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
References: <20080728184947.GA5041@martell.zuzino.mipt.ru> <87tze95yrk.fsf@saeurebad.de> <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291139.33427.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 10:33, Linus Torvalds wrote:
> On Tue, 29 Jul 2008, Johannes Weiner wrote:
> > Actually, I think the prettier fix would be to just establish that
> > garuantee:
> >
> > --- a/arch/x86/mm/gup.c
> > +++ b/arch/x86/mm/gup.c
> > @@ -223,7 +223,7 @@ int get_user_pages_fast(unsigned long start, int
> > nr_pages, int write, struct page **pages)
> >  {
> >  	struct mm_struct *mm = current->mm;
> > -	unsigned long end = start + (nr_pages << PAGE_SHIFT);
> > +	unsigned long end = PAGE_ALIGN(start + (nr_pages << PAGE_SHIFT));
>
> Umm. 'end' is guaranteed to be page-aligned if 'start' is.
>
> So if this makes a difference, that implies that _start_ isn't
> page-aligned, and then you when you add PAGE_SIZE to 'addr', you are going
> to miss 'end' again.
>
> So no, the right fix would be to align 'start' first, which means that
> everything else (including 'end') will be page-aligned. Aligning just one
> or the other is very very wrong.
>
> But yeah, this looks like a nasty bug. It's also sad that the code
> that _should_ be architecture-independent, isn't - because every
> architecture defines the _whole_ "get_user_pages_fast()", even though part
> of it is very much arch-independent (the whole alignment/access_ok part).

I guess when we get a couple more architectures implementing it, we
should split that into a little helper perhaps. I just don't know
quite how it is going to pan out.
