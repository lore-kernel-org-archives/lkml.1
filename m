Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYGIWqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYGIWqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYGIWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:46:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43928 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYGIWqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:46:38 -0400
Date: Thu, 10 Jul 2008 00:46:37 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Kernel oops (bug) in fs/buffers.c:create_empty_buffers
Message-ID: <20080709224637.GA30008@atrey.karlin.mff.cuni.cz>
References: <20080706132302.5ca87f4f@infradead.org> <20080706133100.8d8ed269.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706133100.8d8ed269.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 6 Jul 2008 13:23:02 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > Hi,
> > 
> > caught this one on kerneloops.org: 
> > http://www.kerneloops.org/searchweek.php?search=create_empty_buffers
> > 
> > void create_empty_buffers(struct page *page,
> >                         unsigned long blocksize, unsigned long b_state)
> > {
> >         struct buffer_head *bh, *head, *tail;
> > 
> >         head = alloc_page_buffers(page, blocksize, 1);
> >         bh = head;
> >         do {
> >                 bh->b_state |= b_state;
> >                 tail = bh;
> >                 bh = bh->b_this_page;
> >         } while (bh);
> > 
> > 
> > turns out, alloc_page_buffers() can fail and return NULL (for AIO for
> > example)... yet this code blindly dereferences the result, getting a
> > predictable NULL pointer fault.
> > 
> > It's not directly clear what to do about... make this function return
> > the failure to the caller?
> 
> isofs has a habit of returning impossible block sizes and the
> 
> 	while ((offset -= size) >= 0) {
> 
> consequently loops zero times and alloc_page_buffers() returns null.
> 
> Someone was having a look at it - maybe Jan?
  Yes, I was looking at that. Actually, I've pinpointed the cause of
the Oopses I've seen to a bug in ide-cd driver. It happily sets blocksize
to whatever value the drive reported and some drives have a habit of
reporting bogus values when unreadable medium is inserted.
  Jens has actually cooked up a fix for this bug
(http://thread.gmane.org/gmane.linux.kernel/696582) and it fixes the
problem at least for me.

> I assume that the kernloops.org records link back to the original
> report somewhere but I can't find it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
