Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYAWViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYAWViS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYAWViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:38:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYAWViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:38:09 -0500
Date: Wed, 23 Jan 2008 13:36:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: a.p.zijlstra@chello.nl, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
 sys_msync()
In-Reply-To: <E1JHmxa-0004BK-6X@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.00.0801231329120.2803@woody.linux-foundation.org>
References: <12010440803930-git-send-email-salikhmetov@gmail.com>  <1201044083504-git-send-email-salikhmetov@gmail.com>  <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org> <1201110066.6341.65.camel@lappy> <alpine.LFD.1.00.0801231107520.1741@woody.linux-foundation.org>
 <E1JHlh8-0003s8-Bb@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801231248060.2803@woody.linux-foundation.org> <E1JHmxa-0004BK-6X@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jan 2008, Miklos Szeredi wrote:
> 
> Yeah, nasty.
> 
> How about doing it in a separate pass, similarly to
> wait_on_page_writeback()?  Just instead of waiting, clean the page
> tables for writeback pages.

That sounds like a good idea, but it doesn't work.

The thing is, we need to hold the page-table lock over the whole sequence 
of

	if (page_mkclean(page))
		set_page_dirty(page);
	if (TestClearPageDirty(page))
		..

and there's a big comment about why in clear_page_dirty_for_io().

So if you split it up, so that the first phase is that

	if (page_mkclean(page))
		set_page_dirty(page);

and the second phase is the one that just does a

	if (TestClearPageDirty(page))
		writeback(..)

and having dropped the page lock in between, then you lose: because 
another thread migth have faulted in and re-dirtied the page table entry, 
and you MUST NOT do that "TestClearPageDirty()" in that case!

That dirty bit handling is really really important, and it's sadly also 
really really easy to get wrong (usually in ways that are hard to even 
notice: things still work 99% of the time, and you might just be leaking 
memory slowly, and fsync/msync() might not write back memory mapped data 
to disk at all etc).

> Sure, I would have though all of this stuff is 2.6.25, but it's your
> kernel... :)

Well, the plain added "file_update_time()" call addition looked like a 
trivial fix, and if there are actually *customers* that have bad backups 
due to this, then I think that part was worth doing. At least a "sync" 
will then sync the file times...

			Linus
