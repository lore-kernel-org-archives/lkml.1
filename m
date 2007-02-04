Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbXBDJoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbXBDJoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 04:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXBDJoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 04:44:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXBDJoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 04:44:54 -0500
Date: Sun, 4 Feb 2007 01:44:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-Id: <20070204014445.88e6c8c7.akpm@linux-foundation.org>
In-Reply-To: <20070204063833.23659.55105.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
	<20070204063833.23659.55105.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  4 Feb 2007 09:51:07 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:

> 2.  If we find the destination page is non uptodate, unlock it (this could be
>     made slightly more optimal), then find and pin the source page with
>     get_user_pages. Relock the destination page and continue with the copy.
>     However, instead of a usercopy (which might take a fault), copy the data
>     via the kernel address space.

argh.  We just can't go adding all this gunk into the write() path. 

mmap_sem, a full pte-walk, taking of pte-page locks, etc.  For every page. 
Even single-process write() will suffer, let along multithreaded stuff,
where mmap_sem contention may be the bigger problem.

I was going to do some quick measurements of this, but the code oopses
on power4 (http://userweb.kernel.org/~akpm/s5000402.jpg)

There's a build error in filemap_xip.c btw.



We need to think different.

What happened to the idea of doing an atomic copy into the non-uptodate
page and handling it somehow?



Another option might be to effectively pin the whole mm during the copy:

	down_read(&current->mm->unpaging_lock);
	get_user(addr);		/* Fault the page in */
	...
	copy_from_user()
	up_read(&current->mm->unpaging_lock);

then, anyone who wants to unmap pages from this mm requires
write_lock(unpaging_lock).  So we know the results of that get_user()
cannot be undone.

Or perhaps something like this can be done on a per-vma basis.  Just
something to tell the VM "hey, you're not allowed to unmap this page right
now"?
