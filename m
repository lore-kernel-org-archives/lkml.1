Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbXJLSDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbXJLSDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbXJLSDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:03:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55897 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbXJLSDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:03:32 -0400
Subject: Re: [PATCH] mm: avoid dirtying shared mappings on mlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
In-Reply-To: <DC1BA0F9-59D4-41AE-BB90-55E325F602F2@freebsd.org>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
	 <200710120257.05960.nickpiggin@yahoo.com.au>
	 <1192185439.27435.19.camel@twins>
	 <200710120414.11026.nickpiggin@yahoo.com.au>
	 <1192186222.27435.22.camel@twins>
	 <20071012075317.591212ef@laptopd505.fenrus.org>
	 <1192201105.27435.41.camel@twins>
	 <DC1BA0F9-59D4-41AE-BB90-55E325F602F2@freebsd.org>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 20:02:18 +0200
Message-Id: <1192212138.5797.30.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-12 at 10:45 -0700, Suleiman Souhlal wrote:
> On Oct 12, 2007, at 7:58 AM, Peter Zijlstra wrote:
> 
> > On Fri, 2007-10-12 at 07:53 -0700, Arjan van de Ven wrote:
> >> On Fri, 12 Oct 2007 12:50:22 +0200
> >>>>> The pages will still be read-only due to dirty tracking, so the
> >>>>> first write will still do page_mkwrite().
> >>>>
> >>>> Which can SIGBUS, no?
> >>>
> >>> Sure, but that is no different than any other mmap'ed write. I'm not
> >>> seeing how an mlocked region is special here.
> >>>
> >>> I agree it would be nice if mmap'ed writes would have better error
> >>> reporting than SIGBUS, but such is life.
> >>
> >> well... there's another consideration
> >> people use mlock() in cases where they don't want to go to the
> >> filesystem for paging and stuff as well (think the various iscsi
> >> daemons and other things that get in trouble).. those kind of uses
> >> really use mlock to avoid
> >> 1) IO to the filesystem
> >> 2) Needing memory allocations for pagefault like things
> >> at least for the more "hidden" cases...
> >>
> >> prefaulting everything ready pretty much gives them that... letting
> >> things fault on demand... nicely breaks that.
> >
> > Non of that is changed. So I'm a little puzzled as to which side you
> > argue.
> 
> I think this might change the behavior in case you mlock sparse files.
> I guess currently the holes disappear when you mlock them, but with  
> the patch the blocks wouldn't get allocated until they get written to.

Sure, but by point 1 - avoiding IO - that doesn't matter. Once you write
to a shared mapping you'll generate IO and you'll hit kernel allocations
and other delays no matter what you do.


