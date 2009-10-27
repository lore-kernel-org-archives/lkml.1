Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZJ0Pcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZJ0Pcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZJ0Pcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:32:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZJ0Pcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:32:53 -0400
Date: Tue, 27 Oct 2009 16:32:51 +0100
From: Jan Kara <jack@suse.cz>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jan Kara <jack@suse.cz>, WU Fengguang <wfg@mail.ustc.edu.cn>,
       npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hch@infradead.org, chris.mason@oracle.com
Subject: Re: [RFC] [PATCH] Avoid livelock for fsync
Message-ID: <20091027153251.GA5345@duck.suse.cz>
References: <20091026181314.GE7233@duck.suse.cz> <200910271926.15176.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910271926.15176.knikanth@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-10-09 19:26:14, Nikanth Karthikesan wrote:
> On Monday 26 October 2009 23:43:14 Jan Kara wrote:
> >   Hi,
> > 
> >   on my way back from Kernel Summit, I've coded the attached patch which
> > implements livelock avoidance for write_cache_pages. We tag patches that
> > should be written in the beginning of write_cache_pages and then write
> > only tagged pages (see the patch for details). The patch is based on Nick's
> > idea.
> 
> As I understand, livelock can be caused only by dirtying new pages.
> 
> So theoretically, if a process can dirty pages faster than we can tag pages 
> for writeback, even now isn't there a chance for livelock? But if it is really 
  Yes, theoretically the livelock is still there but practically, I don't
think it's triggerable (the amount of work needed to do either write(2) or
page fault is much higher than just looking up a page in radix tree and
setting there one bit). If the file has lots of dirty pages, I belive user
can create a few more while we are tagging but not much...

> a very fast operation and livelock is not possible, why not hold the tree_lock 
> during the entire period of tagging the pages for writeback i.e., call 
> tag_pages_for_writeback() under mapping->tree_lock? Would it cause 
> deadlock/starvation or some other serious problems?
  I'm dropping tree_lock because I don't think I can hold it during
pagevec_lookup_tag. Even if that was worked-around, if the file has lots of
dirty pages, it could take us long enough to tag all of them that it would
matter latency-wise for other users of the lock. So I'd leave the code as
is.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
