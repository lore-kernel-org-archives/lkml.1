Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZCLAGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZCLAGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZCLAGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:06:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbZCLAGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:06:15 -0400
Date: Wed, 11 Mar 2009 17:02:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dhowells@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may
 get wrongly discarded
Message-Id: <20090311170207.1795cad9.akpm@linux-foundation.org>
In-Reply-To: <20090311150302.0ae76cf1.akpm@linux-foundation.org>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	<20090311150302.0ae76cf1.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 15:03:02 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > The problem is that the pages are not marked dirty.  Anything that creates data
> > in an MMU-based ramfs will cause the pages holding that data will cause the
> > set_page_dirty() aop to be called.
> > 
> > For the NOMMU-based mmap, set_page_dirty() may be called by write(), but it
> > won't be called by page-writing faults on writable mmaps, and it isn't called
> > by ramfs_nommu_expand_for_mapping() when a file is being truncated from nothing
> > to allocate a contiguous run.
> > 
> > The solution is to mark the pages dirty at the point of allocation by
> > the truncation code.
> 
> Page reclaim shouldn't be even attempting to reclaim or write back
> ramfs pagecache pages - reclaim can't possibly do anything with these
> pages!
> 
> Arguably those pages shouldn't be on the LRU at all, but we haven't
> done that yet.
> 
> Now, my problem is that I can't 100% be sure that we _ever_ implemented
> this properly.  I _think_ we did, in which case we later broke it.  If
> we've always been (stupidly) trying to pageout these pages then OK, I
> guess your patch is a suitable 2.6.29 stopgap.

OK, I can't find any code anywhere in which we excluded ramfs pages
from consideration by page reclaim.  How dumb.

So I guess that for now the proposed patch is suitable.  Longer-term we
should bale early in shrink_page_list(), or not add these pages to the
LRU at all.
