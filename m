Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYKNTio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYKNTio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYKNTig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:38:36 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57499 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYKNTif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:38:35 -0500
Date: Fri, 14 Nov 2008 19:38:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Christoph Lameter <cl@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
In-Reply-To: <Pine.LNX.4.64.0811141244060.29394@quilx.com>
Message-ID: <Pine.LNX.4.64.0811141923030.10125@blonde.site>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
 <Pine.LNX.4.64.0811141244060.29394@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Christoph Lameter wrote:
> On Fri, 14 Nov 2008, Hugh Dickins wrote:
> > (I was intending to downgrade these BUG_ONs to VM_BUG_ONs anyway, but
> > this example makes that seem highly desirable):
> >
> > void __delete_from_swap_cache(struct page *page)
> > {
> > 	BUG_ON(!PageLocked(page));
> > 	BUG_ON(!PageSwapCache(page));
> > 	BUG_ON(PageWriteback(page));
> > 	BUG_ON(PagePrivate(page));
> 
> Maybe checking all the conditionals in one BUG_ON is not such a bad idea
> after all? 4 useless branches in a hotpath?

That is usually frowned on, since on those rare occasions you hit
the BUG_ON, you're left wondering which of the four cases it hit.
(I suppose it might show up in the stack trace or registers.)

What I was intending anyway, quite independently of the INLINING
issue, was changing those and some others to VM_BUG_ONs, which are
intended really for VM testers rather than for distros to turn on.
(Though perhaps Nick has shifted his position on that.)

And the last of them, the PagePrivate one, I was just going to
remove along with quite a few other BUG_ON(PagePrivate)s: they were
interesting at the time we started storing swpentry in page->private,
without setting PagePrivate, when before page->private had always(?)
contained a buffer pointer with PagePrivate set; but of no interest
nowadays, I'd say.

> > I do wonder whether there's some tweak we could make to page-flags.h
> > which would stop this nonsense.  Change the inline functions back to
> > macros?  I suspect that by itself wouldn't work, and my quick attempt
> > to try it failed abysmally to compile, I've not the cpp foo needed.
> 
> I think we want to get away from macros as much as possible.

That is indeed the orthodoxy.  I've never been so sold on it as most
(there are cases when inlines give superior typechecking, but often
the use of the macro will catch wrong types anyway).  But I suspect
it's irrelevant, that changing those functions to macros would not
actually have any effect on the problem - that's what we've often
been assured, anyway, that the compiler nowadays does inlines as
efficiently as the preprocessor does macros.  I do wonder though.

Hugh
