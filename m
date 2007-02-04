Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbXBDKPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbXBDKPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXBDKPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:15:31 -0500
Received: from mail.suse.de ([195.135.220.2]:55181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXBDKPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:15:30 -0500
Date: Sun, 4 Feb 2007 11:15:29 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070204101529.GA22004@wotan.suse.de>
References: <20070204063707.23659.20741.sendpatchset@linux.site> <20070204063833.23659.55105.sendpatchset@linux.site> <20070204014445.88e6c8c7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070204014445.88e6c8c7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 01:44:45AM -0800, Andrew Morton wrote:
> On Sun,  4 Feb 2007 09:51:07 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> 
> > 2.  If we find the destination page is non uptodate, unlock it (this could be
> >     made slightly more optimal), then find and pin the source page with
> >     get_user_pages. Relock the destination page and continue with the copy.
> >     However, instead of a usercopy (which might take a fault), copy the data
> >     via the kernel address space.
> 
> argh.  We just can't go adding all this gunk into the write() path. 
> 
> mmap_sem, a full pte-walk, taking of pte-page locks, etc.  For every page. 
> Even single-process write() will suffer, let along multithreaded stuff,
> where mmap_sem contention may be the bigger problem.

The write path is broken. I prefer my kernels slow, than buggy.

As I said, I'm working on a replacement API so that the filesystems
that care, can be correct *and* fast.

> I was going to do some quick measurements of this, but the code oopses
> on power4 (http://userweb.kernel.org/~akpm/s5000402.jpg)

Cool, a kernel thread is calling sys_write. Fun.

I guess I should be able to reproduce this if using initramfs. Thanks.

> There's a build error in filemap_xip.c btw.
> 
> 
> 
> We need to think different.
> 
> What happened to the idea of doing an atomic copy into the non-uptodate
> page and handling it somehow?

That was my second idea. I didn't get any feedback on that patchset
except to try this method, so I assume everyone hated it.

I actually liked it, because it didn't have to do the writev
segment-at-a-time for !uptodate pages like this one does. Considering
this code gets called from mm-less contexts, maybe I'll have to go back
to this approach.

> Another option might be to effectively pin the whole mm during the copy:
> 
> 	down_read(&current->mm->unpaging_lock);
> 	get_user(addr);		/* Fault the page in */
> 	...
> 	copy_from_user()
> 	up_read(&current->mm->unpaging_lock);
> 
> then, anyone who wants to unmap pages from this mm requires
> write_lock(unpaging_lock).  So we know the results of that get_user()
> cannot be undone.

Fugly. Don't know whether there are any lock order problems making it
hard to implement, but you introduce the theoretical memory deadlock
where a task cannot reclaim its own memory.

> Or perhaps something like this can be done on a per-vma basis.  Just
> something to tell the VM "hey, you're not allowed to unmap this page right
> now"?

Same memory deadlock problem.
