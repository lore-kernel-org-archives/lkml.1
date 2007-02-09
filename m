Return-Path: <linux-kernel-owner+w=401wt.eu-S1946321AbXBIKdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946321AbXBIKdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946347AbXBIKdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:33:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:35078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946321AbXBIKc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:32:59 -0500
Date: Fri, 9 Feb 2007 11:32:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-ID: <20070209103258.GC14398@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070209004101.3e4a88fc.akpm@linux-foundation.org> <20070209095405.GA14398@wotan.suse.de> <20070209020954.4951256e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209020954.4951256e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 02:09:54AM -0800, Andrew Morton wrote:
> On Fri, 9 Feb 2007 10:54:05 +0100 Nick Piggin <npiggin@suse.de> wrote:
> 
> > 
> > That's still got a deadlock,
> 
> It does?

Yes, PG_lock vs mm->mmap_sem.

> >  and also it doesn't work if we want to lock
> > the page when performing a minor fault (which I want to fix fault vs
> > invalidate),
> 
> It's hard to discuss this without a description of what you want to fix
> there, and a description of how you plan to fix it.

http://marc.theaimsgroup.com/?l=linux-mm&m=116865911432667&w=2

> > and also assumes nobody's ->nopage locks the page or
> > requires any resources that are held by prepare_write (something not
> > immediately clear to me with the cluster filesystems, at least).
> 
> The nopage handler is filemap_nopage().  Are there any exceptions to that?

OCFS2 and GFS2.

> > But that all becomes legacy path, so do we really care? Supposing fs
> > maintainers like perform_write, then after the main ones have implementations
> > we could switch over to the slow-but-correct prepare_write legacy path.
> > Or we could leave it, or we could use Linus's slightly-less-buggy scheme...
> > by that point I expect I'd be sick of arguing about it ;)
> 
> It's worth "arguing" about.  This is write().  What matters more??

That's the legacy path that uses prepare/commit (ie. supposing that all
major filesystems did get converted to perform_write).

Of course I would still want my correct-but-slow version in that case,
but I just wouldn't care to argue if you still wanted to keep it fast.

