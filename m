Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbZCUVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbZCUVLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZCUVLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:11:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59135 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZCUVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:11:08 -0400
Date: Sat, 21 Mar 2009 21:10:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-kernel@vger.kernel.org, Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: 2.6.28.2 kernel bug
In-Reply-To: <49C52958.7030700@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0903212014380.15606@blonde.anvils>
References: <49C52958.7030700@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009, Udo van den Heuvel wrote:
> 
> While doing a find to get rid of 2.5M smallish files in 1 directory I got the
> stuff pasted below which made the system freeze.
> This is on Fedora 10 on AMD x86_64 with a custom kernel.
> Any ideas on how to fix this? Can I help?

Thanks for the helpful full messages, I've cut them down to edited
highlights below (the "scheduling while atomic" messages were just
consequential noise, and I doubt the "general protection fault" is
worth worrying about, given the errors that had already occurred).

I'm pretty sure the page at ffffe20001d4b8e8 is the page with pfn 85ebb
(0x85ebb * 0x38 == 0x1d4b8e8, 0x38 being sizeof(struct page) on x86_64);
and the fs/buffer.c:710 warning is likely to be on that same page too.

So we're probably seeing the fallout of just one page which somehow
got freed and reused while it's still in use elsewhere.  I've not
attempted a full history of what happens to page count and mapcount
in such a confusing case, but the various mapcount -1 errors are
almost certainly just the consequence of how we force it to 0 when
"Bad page state" finds it 1 (2.6.29-rc handles these differently,
and should be more robust).

But I don't have any theory for why that might have happened.
Page table corruption might be a possibility, but I think that
usually manifests as rmap Eeeks first.  It would certainly be
helpful to run memtest as Alexey suggested.

This would become more interesting if you are able to reproduce it,
or something like it - is that massive removal of files something
you often do without a problem, or was this new?  What does your
find/rm command line look like?  I'm wondering if we have a bug
with exceptionally long arg lists.

Hugh

> Bad page state in process 'find'
> page:ffffe20001d4b8e8 flags:0x4000000000080008
> mapping:0000000000000000 mapcount:1 count:0
> unmap_vmas+0x8b4/0x9a0
> exit_mmap+0xb5/0x1c0
> mmput+0x25/0xc0
> flush_old_exec+0x1de/0x890
> load_elf_binary+0x0/0x1dd0
> 
> Bad page state in process 'find'
> page:ffffe20001d4b8e8 flags:0x4000000000000008
> mapping:0000000000000000 mapcount:1 count:1
> get_page_from_freelist+0x5c5/0x600
> __alloc_pages_internal+0xe7/0x4b0
> __get_user_pages+0x136/0x450
> get_arg_page+0x46/0xb0
> copy_strings+0x102/0x1e0
> 
> Eeek! page_mapcount(page) went negative! (-1)
>  page pfn = 85ebb
>  page->flags = 400000000000001c
>  page->count = 0
>  page->mapping = 0000000000000000
>  vma->vm_ops = 0x0
> kernel BUG at mm/rmap.c:725!
> Process rm (pid: 28655, threadinfo
> unmap_vmas+0x4e6/0x9a0
> 
> Bad page state in process 'firefox'
> page:ffffe20001d4b8e8 flags:0x400000000000001c
> mapping:0000000000000000 mapcount:-1 count:0
> get_page_from_freelist+0x5c5/0x600
> __alloc_pages_internal+0xe7/0x4b0
> handle_mm_fault+0x4f3/0x840
> 
> WARNING: at fs/buffer.c:710 __set_page_dirty+0x12f/0x160()
> Pid: 29549, comm: find Tainted: G    B D 2.6.28.2
> set_page_dirty+0x31/0xc0
> unmap_vmas+0x730/0x9a0
> 
> Eeek! page_mapcount(page) went negative! (-1)
>  page pfn = 85ebb
>  page->flags = 4000000000000834
>  page->count = 2
>  page->mapping = ffff88012f435290
>  vma->vm_ops = 0x0
> kernel BUG at mm/rmap.c:725!
> Process find (pid: 29549, threadinfo
> unmap_vmas+0x4e6/0x9a0
