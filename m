Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZIYAnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZIYAnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZIYAna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:43:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50984 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZIYAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:43:30 -0400
Date: Fri, 25 Sep 2009 09:43:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>, Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data can be mapped directly
Message-ID: <20090925004300.GA8651@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, graff.yang@gmail.com,
	linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
	Mel Gorman <mel@csn.ul.ie>, Greg Ungerer <gerg@snapgear.com>
References: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 03:13:10PM +0100, David Howells wrote:
> Fix MAP_PRIVATE mmap() of files and devices where the data in the backing store
> might be mapped directly.  Use the BDI_CAP_MAP_DIRECT capability flag to govern
> whether or not we should be trying to map a file directly.  This can be used to
> determine whether or not a region has been filled in at the point where we call
> do_mmap_shared() or do_mmap_private().
> 
> The BDI_CAP_MAP_DIRECT capability flag is cleared by validate_mmap_request() if
> there's any reason we can't use it.  It's also cleared in do_mmap_pgoff() if
> f_op->get_unmapped_area() fails.
> 
> 
> Without this fix, attempting to run a program from a RomFS image on a
> non-mappable MTD partition results in a BUG as the kernel attempts XIP, and
> this can be caught in gdb:
> 
> Program received signal SIGABRT, Aborted.
> 0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
> (gdb) bt
> #0  0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
> #1  0xc005f168 in do_mmap_pgoff (file=0xc31a6620, addr=<value optimized out>, len=3808, prot=3, flags=6146, pgoff=0) at mm/nommu.c:1373
> #2  0xc00a96b8 in elf_fdpic_map_file (params=0xc33fbbec, file=0xc31a6620, mm=0xc31bef60, what=0xc0213144 "executable") at mm.h:1145
> #3  0xc00aa8b4 in load_elf_fdpic_binary (bprm=0xc316cb00, regs=<value optimized out>) at fs/binfmt_elf_fdpic.c:343
> #4  0xc006b588 in search_binary_handler (bprm=0x6, regs=0xc33fbce0) at fs/exec.c:1234
> #5  0xc006c648 in do_execve (filename=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460, regs=0xc33fbce0) at fs/exec.c:1356
> #6  0xc0008cf0 in sys_execve (name=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460) at arch/frv/kernel/process.c:263
> #7  0xc00075dc in __syscall_call () at arch/frv/kernel/entry.S:897
> 
> 
> Note that this fix does the following commit differently:
> 
> 	commit a190887b58c32d19c2eee007c5eb8faa970a69ba
> 	Author: David Howells <dhowells@redhat.com>
> 	Date:   Sat Sep 5 11:17:07 2009 -0700
> 	nommu: fix error handling in do_mmap_pgoff()
> 
> Reported-by: Graff Yang <graff.yang@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Greg Ungerer <gerg@snapgear.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
