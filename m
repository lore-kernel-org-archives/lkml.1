Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYHEJMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYHEJMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759453AbYHEJMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:12:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759339AbYHEJME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:12:04 -0400
Date: Tue, 5 Aug 2008 02:11:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Adrian Bunk <bunk@kernel.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [2.6 patch] fix mm/mm_init.c compilation
Message-Id: <20080805021141.0b060e04.akpm@linux-foundation.org>
In-Reply-To: <20080805075122.GA20243@csn.ul.ie>
References: <20080804181915.GA12558@cs181140183.pp.htv.fi>
	<20080804140554.aa1ef2da.akpm@linux-foundation.org>
	<20080805075122.GA20243@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 08:51:23 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> > > --- a/mm/mm_init.c
> > > +++ b/mm/mm_init.c
> > > @@ -63,6 +63,13 @@ void __init mminit_verify_pageflags_layout(void)
> > >  {
> > >  	int shift, width;
> > >  	unsigned long or_mask, add_mask;
> > > +	int sections_shift;
> > > +
> > > +#ifdef SECTIONS_SHIFT
> > > +	sections_shift = SECTIONS_SHIFT;
> > > +#else
> > > +	sections_shift = 0;
> > > +#endif
> > >  
> > >  	shift = 8 * sizeof(unsigned long);
> > >  	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH;
> > > @@ -74,11 +81,7 @@ void __init mminit_verify_pageflags_layout(void)
> > >  		NR_PAGEFLAGS);
> > >  	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
> > >  		"Section %d Node %d Zone %d\n",
> > > -#ifdef SECTIONS_SHIFT
> > > -		SECTIONS_SHIFT,
> > > -#else
> > > -		0,
> > > -#endif
> > > +		sections_shift,
> > >  		NODES_SHIFT,
> > >  		ZONES_SHIFT);
> > >  	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
> > 
> > OK, ifdefs inside macro expansion aren't a great idea.
> > 
> > Mel, is there any erason why we shouldn't do it this way?
> > 
> 
> The only minor nit is SECTIONS_SHIFT is defined outside of SPARSEMEM even
> though it has no meaning there. There is no problem with this as such but
> someone being silly might use SECTIONS_SHIFT accidently. If this sort of
> behaviour was considered a possibility, we could add something like this to
> mm/mm_init.c instead?

That sounds sane.

diff -puN mm/mm_init.c~mm_initc-avoid-ifdef-inside-macro-expansion mm/mm_init.c
--- a/mm/mm_init.c~mm_initc-avoid-ifdef-inside-macro-expansion
+++ a/mm/mm_init.c
@@ -14,6 +14,10 @@
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
+#ifndef SECTIONS_SHIFT
+#define SECTIONS_SHIFT	0
+#endif
+
 /* The zonelists are simply reported, validation is manual. */
 void mminit_verify_zonelist(void)
 {
@@ -74,11 +78,7 @@ void __init mminit_verify_pageflags_layo
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
 		"Section %d Node %d Zone %d\n",
-#ifdef SECTIONS_SHIFT
 		SECTIONS_SHIFT,
-#else
-		0,
-#endif
 		NODES_SHIFT,
 		ZONES_SHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
_

