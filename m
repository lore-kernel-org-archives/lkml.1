Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYFCBWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYFCBWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 21:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYFCBV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:21:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYFCBVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:21:55 -0400
Date: Mon, 2 Jun 2008 18:19:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, greg@kroah.com,
       jeff@garzik.org, davej@redhat.com
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
Message-Id: <20080602181955.ae5c99b8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806030116080.17244@blonde.site>
References: <48402DAA.60202@linux.intel.com>
	<Pine.LNX.4.64.0805302017580.16427@blonde.site>
	<Pine.LNX.4.64.0806030000110.9919@blonde.site>
	<20080602170031.d5c03225.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806030116080.17244@blonde.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 01:41:22 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 2 Jun 2008, Andrew Morton wrote:
> > On Tue, 3 Jun 2008 00:44:38 +0100 (BST)
> > Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > > +					if (in_atomic())
> > > +						kunmap_atomic(kaddr, KM_USER0);
> > > +					else
> > > +						kunmap(kmapped_page);
> > 
> > eek.
> > 
> > /*
> >  * Are we running in atomic context?  WARNING: this macro cannot
> >  * always detect atomic context; in particular, it cannot know about
> >  * held spinlocks in non-preemptible kernels.  Thus it should not be
> >  * used in the general case to determine whether sleeping is possible.
> >  * Do not use in_atomic() in driver code.
> >  */
> > #define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
> 
> Yes, that comment is all about how a common function cannot be expected
> to guess whether it's being called in atomic context or not; but we
> know that we don't have any spinlocks held here, therefore it's okay.
> 
> Or do you consider fs/exec.c a driver, and shouldn't set bad example?
> It is exactly the test that do_page_fault() makes at the other end,
> when deciding whether it can handle the fault.

Well, if you're sure..  I didn't look very closely (sorry), nor did you
explain very closely.

I think doing this sort of thing is OK in fs/exec.c from the
should-we-be-doing-this-in there POV, but it should have suitable comments
slapped all over it.

> Originally I had a bool atomic there instead.  I switched over to
> testing in_atomic() itself because I had it mind to suggest another
> patch: it has long seemed wrong to me that we should have to disable
> preemption and fault handling there, when often (on many architectures,
> or on many pages) it's unnecessary.
> 
> So I'd like to change (the various implementations of) kmap_atomic()
> to use pagefault_disable() only when the page actually is in highmem.

So...  places like file_read_actor() would be given an open-coded
pagefault_disable() so we preserve out implicit boolean-passing down to
do_page_fault()?

One of the reasons why we (I?) left kmap_atomic() doing
pagefault_disable() for all pages was testing coverage: not many
developers test with highmem nowadays so there's a high risk (almost a
certainty) that people will start adding can-schedule code inside their
kmap_atomic() regions.  Probably it's not a terribly good reason...
