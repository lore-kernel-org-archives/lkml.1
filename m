Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXJCQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXJCQH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXJCQHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:07:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbXJCQHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:07:17 -0400
Date: Wed, 3 Oct 2007 09:07:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9
 and a heads-up for the 2.6.24 series..)
In-Reply-To: <20071003154046.GA17256@elte.hu>
Message-ID: <alpine.LFD.0.999.0710030848150.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
 <20071003154046.GA17256@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Ingo Molnar wrote:
> 
> >  - and as a result you get an exception on the *next* page:
> > 
> > 	BUG: unable to handle kernel paging request at virtual address f2a40000
> 
> Hm, are you sure? This is a CONFIG_DEBUG_PAGEALLOC=y kernel, so even a 
> slight overrun of a non-NIL terminated string (as suspected by Al) could 
> run into a non-mapped kernel page. (which would indicate not a compiler 
> bug but use-after free)

I am 100% sure. I can look at the disassembly, and point to the fact that 
your Oops happens on code that is simply totally bogus.

That string is NUL-terminated, which is why the access is to f2a3fffe in 
the first place: we explicitly asked d_path() to create us a string at the 
end of the page (it creates them backwards), so the path string has a NUL 
a the end at address f2a3ffff, which is exactly what we'd expect.

Your compiler really does seem to be total crap.

Do a "make fs/seq_file.s" (and make sure you *disable* CONFIG_DEBUG_INFO 
first, otherwise the result will be unreadable crud), and look at 
seq_path(). It's going to be more readable than the disassembly that I got 
through gdb, but I bet it's going to show it even more clearly.

> i just found another config under which i get similar crashes, config 
> attached. One common theme is CONFIG_DEBUG_FS and DEBUG_PAGEALLOC - and 
> CONFIG_MAC80211_DEBUGFS is not enabled in this one so it's off the hook 
> i think. (the crashes are attached below)

.. of *course* DEBUG_PAGEALLOC is going to be implied in the problem. If 
you don't have DEBUG_PAGEALLOC, you'll never see this, because you'll have 
all pages mapped, and the only page that it could happen to is the very 
last page in memory, and you'll never hit that one in practice.

> (my serial log on this box goes back about 6 months, and that alone 
> shows more than 3500 successful kernel bootups on that particular 
> testsystem, each kernel built by this compiler - and there's another 
> testsystem that i use even more frequently. Despite that, a compiler bug 
> is still possible of course.)

It's not about "possible". It's a fact. Send me your "seq_file.s" output 
for that function to be sure - it *could* be memory corruption that 
changes a "movb" into a "movl", and maybe the compiler did a byte move to 
start with, but quite frankly, that is such a remote possibility that I 
don't consider it realistic.

> BUG: unable to handle kernel paging request at virtual address f6207000
>  printing eip:
> c016ecf1
> *pdpt = 0000000000003001
> *pde = 0000000000ac1067
> *pte = 0000000036207000
> Oops: 0000 [#1]
> SMP DEBUG_PAGEALLOC
> Modules linked in:
> CPU:    1
> EIP:    0060:[<c016ecf1>]    Not tainted VLI
> EFLAGS: 00010297   (2.6.23-rc9 #20)
> EIP is at seq_path+0x60/0xca
> eax: f6206ffe   ebx: c2de0f50   ecx: 0000002b   edx: f6206ffe
> esi: f6206007   edi: c2dddfb0   ebp: f6503f18   esp: f6503f00
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process awk (pid: 1160, ti=f6503000 task=f73a8390 task.ti=f6503000)
> Stack: 00000ff9 f6e5cf70 f6206ffe c2dddf80 f6e5cf70 c2dddfb0 f6503f30 c016ce40 
>        c05d71b5 f6730f38 f6e5cf70 c2dddfb0 f6503f70 c016f05d 00000400 08098f18 
>        f6730f38 f6e5cf90 00000000 0806bc2e 00000003 08094320 f6503fb0 00000000 
> Call Trace:
>  [<c0103c8d>] show_trace_log_lvl+0x19/0x2e
>  [<c0103d3f>] show_stack_log_lvl+0x9d/0xa5
>  [<c0104083>] show_registers+0x1af/0x281
>  [<c0104338>] die+0x11a/0x1e8
>  [<c01138d1>] do_page_fault+0x632/0x715
>  [<c04e7372>] error_code+0x72/0x80
>  [<c016ce40>] show_vfsmnt+0x43/0x120
>  [<c016f05d>] seq_read+0xf1/0x269
>  [<c0159783>] vfs_read+0x90/0x10e
>  [<c0159f9e>] sys_read+0x3f/0x63
>  [<c0102876>] sysenter_past_esp+0x5f/0x89
>  =======================
> Code: f0 ff ff 76 77 eb 7a 8b 55 ec 8b 02 89 c2 8b 4d ec 03 51 0c 89 f7 29 c7 89 79 0c 89 f0 29 d0 eb 6c 89 f8 88 06 46 eb 54 8b 55 f0 <8b> 3a 42 89 55 f0 89 f9 84 c9 74 d0 0f be d9 89 da 8b 45 08 e8 

This looks like *exactly* the same thing, except you're in 
"show_vfsmnt()" this time.

Again: the oopsing instruction (8b 3a) is "movl". And again, the address 
is f6206ffe, and it oopses because the (incorrect) 32-bit access will 
touch the next page, so you get a paging request fault on f6207000 - which 
is some *totally* different allocation, and one that isn't mapped because 
it doesn't exist, so DEBUG_PAGE_ALLOC has removed it.

.. and again: exact same thing.

> EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6503f00
> BUG: unable to handle kernel paging request at virtual address f63d1000
> eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002c   edx: f63d0ffe
> Code: .. <8b> 3a ..

.. and again:

> EIP: [<c016ecf1>] seq_path+0x60/0xca SS:ESP 0068:f6367f00
> BUG: unable to handle kernel paging request at virtual address f63d1000
> eax: f63d0ffe   ebx: c2de0f50   ecx: 0000002c   edx: f63d0ffe
> Code: ..  <8b> 3a ..

And I can even tell you exactly what path it is:

 - it's going to be the first path that shows up in the path list, since 
   the seq_file interface will re-use that page, so if you hit it, you'll 
   hit it on the first entry (unless seq_file has *lots* of data and needs 
   more than a single-page allocation)

 - it must be a single-byte path, because otheriwse you'd have oopsed one 
   byte earlier (you'd have oopsed already on access .....ffd, which would 
   *also* overflow to the next page

 - ergo, it's "/".

but that doesn't really even matter. Disassembling the code stream from 
your oops shows clearly that it's a 32-bit access. No ifs, buts or maybes 
about it. If you don't trust the gdb disassembly (I didn't, entirely, so I 
looked it up) byte 0x8b is "mov Gv,Ev" in the Intel opcode map.

A 8-bit move would have been 0x8a.

			Linus
