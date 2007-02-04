Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbXBDKbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbXBDKbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXBDKbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:31:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXBDKbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:31:09 -0500
Date: Sun, 4 Feb 2007 02:30:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-Id: <20070204023055.2583fd65.akpm@linux-foundation.org>
In-Reply-To: <20070204101529.GA22004@wotan.suse.de>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
	<20070204063833.23659.55105.sendpatchset@linux.site>
	<20070204014445.88e6c8c7.akpm@linux-foundation.org>
	<20070204101529.GA22004@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007 11:15:29 +0100 Nick Piggin <npiggin@suse.de> wrote:

> On Sun, Feb 04, 2007 at 01:44:45AM -0800, Andrew Morton wrote:
> > On Sun,  4 Feb 2007 09:51:07 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > 2.  If we find the destination page is non uptodate, unlock it (this could be
> > >     made slightly more optimal), then find and pin the source page with
> > >     get_user_pages. Relock the destination page and continue with the copy.
> > >     However, instead of a usercopy (which might take a fault), copy the data
> > >     via the kernel address space.
> > 
> > argh.  We just can't go adding all this gunk into the write() path. 
> > 
> > mmap_sem, a full pte-walk, taking of pte-page locks, etc.  For every page. 
> > Even single-process write() will suffer, let along multithreaded stuff,
> > where mmap_sem contention may be the bigger problem.
> 
> The write path is broken. I prefer my kernels slow, than buggy.

That won't fly.

> > There's a build error in filemap_xip.c btw.

?

> > 
> > We need to think different.
> > 
> > What happened to the idea of doing an atomic copy into the non-uptodate
> > page and handling it somehow?
> 
> That was my second idea.

Coulda sworn it was mine ;) I thought you ended up deciding it wasn't
practical because of the games we needed to play with ->commit_write.

> I didn't get any feedback on that patchset
> except to try this method, so I assume everyone hated it.
> 
> I actually liked it, because it didn't have to do the writev
> segment-at-a-time for !uptodate pages like this one does. Considering
> this code gets called from mm-less contexts, maybe I'll have to go back
> to this approach.

OK.

> > Another option might be to effectively pin the whole mm during the copy:
> > 
> > 	down_read(&current->mm->unpaging_lock);
> > 	get_user(addr);		/* Fault the page in */
> > 	...
> > 	copy_from_user()
> > 	up_read(&current->mm->unpaging_lock);
> > 
> > then, anyone who wants to unmap pages from this mm requires
> > write_lock(unpaging_lock).  So we know the results of that get_user()
> > cannot be undone.
> 
> Fugly.

I invited you to think different - don't just fixate on one random
tossed-out-there suggestion.

> but you introduce the theoretical memory deadlock
> where a task cannot reclaim its own memory.

Nah, that'll never happen - both pages are already allocated.

It's better than taking mmap_sem and walking pagetables...
