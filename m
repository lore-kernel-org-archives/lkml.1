Return-Path: <linux-kernel-owner+w=401wt.eu-S1946317AbXBIKxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946317AbXBIKxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946367AbXBIKxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:53:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946317AbXBIKxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:53:04 -0500
Date: Fri, 9 Feb 2007 02:52:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-Id: <20070209025249.0a87a435.akpm@linux-foundation.org>
In-Reply-To: <20070209103258.GC14398@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070209004101.3e4a88fc.akpm@linux-foundation.org>
	<20070209095405.GA14398@wotan.suse.de>
	<20070209020954.4951256e.akpm@linux-foundation.org>
	<20070209103258.GC14398@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 11:32:58 +0100 Nick Piggin <npiggin@suse.de> wrote:

> On Fri, Feb 09, 2007 at 02:09:54AM -0800, Andrew Morton wrote:
> > On Fri, 9 Feb 2007 10:54:05 +0100 Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > 
> > > That's still got a deadlock,
> > 
> > It does?
> 
> Yes, PG_lock vs mm->mmap_sem.

Where?  It requires that someone hold mmap_sem for writing as well as a
page lock (in an order which would require some thought).  Do we ever do
that?

> > >  and also it doesn't work if we want to lock
> > > the page when performing a minor fault (which I want to fix fault vs
> > > invalidate),
> > 
> > It's hard to discuss this without a description of what you want to fix
> > there, and a description of how you plan to fix it.
> 
> http://marc.theaimsgroup.com/?l=linux-mm&m=116865911432667&w=2

mutter.

Could perhaps fix that by running ClearPageUptodate in invalidate, thus
forcing the pagefault code to take the page lock (which we already hold).

That does mean that we'll fleetingly have a non-uptodate page in pagetables
which is a bit nasty.

Or, probably better, we could add a new page flag (heh) telling nopage that
it needs to lock the page even if it's uptodate.

> > > and also assumes nobody's ->nopage locks the page or
> > > requires any resources that are held by prepare_write (something not
> > > immediately clear to me with the cluster filesystems, at least).
> > 
> > The nopage handler is filemap_nopage().  Are there any exceptions to that?
> 
> OCFS2 and GFS2.

So the rule is that ->nopage handlers against pagecache mustn't lock the
page if it's already uptodate.  That's OK.  But it might conflict with the
above invalidate proposal.

Gad.  ocfs2_nopage() diddles with signals.


> > > But that all becomes legacy path, so do we really care? Supposing fs
> > > maintainers like perform_write, then after the main ones have implementations
> > > we could switch over to the slow-but-correct prepare_write legacy path.
> > > Or we could leave it, or we could use Linus's slightly-less-buggy scheme...
> > > by that point I expect I'd be sick of arguing about it ;)
> > 
> > It's worth "arguing" about.  This is write().  What matters more??
> 
> That's the legacy path that uses prepare/commit (ie. supposing that all
> major filesystems did get converted to perform_write).

We'll never, ever, ever update and test all filesytems.  What you're
calling "legacy" code will be there for all time.

I haven't had time to look at the perform_write stuff yet.

> Of course I would still want my correct-but-slow version in that case,
> but I just wouldn't care to argue if you still wanted to keep it fast.

This is write().  We just cannot go and double-copy all the memory or take
mmap_sem and do a full pagetable walk in there.  It just means that we
haven't found a suitable solution yet.

