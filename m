Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbYE3ND5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbYE3ND5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYE3NDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:03:47 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51339 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYE3NDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:03:46 -0400
Date: Fri, 30 May 2008 14:03:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Wolf Wiegand <wolf.wiegand@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in 2.6.25
In-Reply-To: <20080530111741.GB3533@denkbrett.wiegand.homedns.org>
Message-ID: <Pine.LNX.4.64.0805301343190.13156@blonde.site>
References: <20080530111741.GB3533@denkbrett.wiegand.homedns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Wolf Wiegand wrote:
> 
> my current kernel just threw an error, see output from ksymoops below.

(It's rather unusual to be using ksymoops on a 2.6 trace: I thought it
tended to mess up the trace more often than it helped, but perhaps I'm
wrong on that, the one below looks okay.  And I see you do build with
CONFIG_KALLSYMS=y, not trying to save space by omitting symbols, so
I'd expect you to have a good trace in your logs without ksymoops.)

> I've been using this version for quite some time now, this is the first
> time this has happened. There have been no hardware changes lately. The
> hardware itself is nothing special, it's a somewhat dusty Thinkpad. 

I'm afraid it looks like the dust has got into your RAM ;)

> Error (regular_file): read_ksyms stat /proc/ksyms failed
> No modules in ksyms, skipping objects
> No ksyms, skipping lsmod

Ah, yes, ksymoops isn't even looking in the right place (/proc/kallsyms)
for a 2.6 kernel: I think you can just forget about ksymoops next time.
If it's the Code decipherment you wanted, try scripts/decodecode from
the kernel tree - though I have seen that get confused.

> Pid: 7266, comm: convert Not tainted (2.6.25 #2)
> EIP: 0060:[<c013bc09>] EFLAGS: 00210006 CPU: 0
> Using defaults from ksymoops -t elf32-i386 -a i386
> EAX: 00001000 EBX: 00001000 ECX: 00000000 EDX: 00000000
> ESI: d2ce7bf8 EDI: d2ce7bfc EBP: 00002b4f ESP: d8c4beb0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Stack: 02d60000 ffffffe5 d2ce7b04 00000000 c015161c d8c4bf34 00002b4f d2ce7b60
>        01000003 d2ce7bf8 001200d2 00000000 02d60000 00000000 d8c4bf28 00002b4f
>        c0151ef3 00000001 d8c4bf00 d2ce7b60 00000000 c0538bd0 b75ff004 d2cc03b0
> Call Trace:
>  [<c015161c>] shmem_getpage+0x58/0x852
>  [<c0151ef3>] shmem_fault+0x79/0xa1
>  [<c0145df3>] __do_fault+0x50/0x31b
>  [<c0147a75>] handle_mm_fault+0x246/0x535
>  [<c01125d5>] do_page_fault+0x205/0x520
>  [<c01123d0>] do_page_fault+0x0/0x520
>  [<c0427072>] error_code+0x6a/0x70
>  [<c0420000>] e100_probe+0x495/0x5b6
> Code: 5b 5b 5e 5f 5d c3 55 89 d5 57 56 89 c6 53 8d 78 04 fa b8 01 00 00 00 e8 6e 8b fd ff 89 ea 89 f8 e8 1d 35 10 00 85 c0 89 c3 74 59 <8b> 00 89 da 25 00 40 02 00 3d 00 40 02 00 75 03 8b 53 0c ff 42
> 
> >>EIP; c013bc09 <find_lock_page+25/a2>   <=====
> Trace; c015161c <shmem_getpage+58/852>
> Trace; c0151ef3 <shmem_fault+79/a1>
> Trace; c0145df3 <__do_fault+50/31b>
> Trace; c0147a75 <handle_mm_fault+246/535>
> Trace; c01125d5 <do_page_fault+205/520>
> Trace; c01123d0 <do_page_fault+0/520>
> Trace; c0427072 <error_code+6a/70>
> Trace; c0420000 <e100_probe+495/5b6>
> 
> Code;  c013bbfe <find_lock_page+1a/a2>
>   20:   e8 1d 35 10 00            call   103542 <_EIP+0x103542>

That's the call to radix_tree_lookup(), which should return
struct page *, or 0x00000000 when it doesn't find the page.

> Code;  c013bc03 <find_lock_page+1f/a2>
>   25:   85 c0                     test   %eax,%eax
> Code;  c013bc05 <find_lock_page+21/a2>
>   27:   89 c3                     mov    %eax,%ebx
> Code;  c013bc07 <find_lock_page+23/a2>
>   29:   74 59                     je     84 <_EIP+0x84>
> Code;  c013bc09 <find_lock_page+25/a2>   <=====
>   2b:   8b 00                     mov    (%eax),%eax   <=====

But in this case it's returned 0x00001000, see EAX or EBX above.
I don't think that's a kernel bug at all, just a single-bit
error in the RAM which held that radix tree node.

Hugh
