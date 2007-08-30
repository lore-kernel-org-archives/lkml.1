Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXH3Qmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXH3Qmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759284AbXH3Qmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:42:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:64216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022AbXH3Qmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=aEBbQt8XuohEcPOZcnJcPLA+ocrXtZLtInhE3pR60U8JImwwvESUKBl06ctmVAqjcvtWpxWmnulAWDCR/+livI/AOyPTzT1tdwdVbQ6c4S/GBMuSInKeicX5A/RsaCnEie85YP91Ar7OYu1M4FYPyRbWNWMaZPeBB4KQ74AjZPE=
Date: Thu, 30 Aug 2007 18:38:12 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lguest <lguest@ozlabs.org>
Subject: Re: [PATCH] Fix lguest page-pinning logic ("lguest: bad stack page 0xc057a000")
Message-ID: <20070830163812.GA22190@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <20070823145038.9895784f.akpm@linux-foundation.org> <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org> <20070824082249.GG31846@slug> <1188043649.20041.81.camel@localhost.localdomain> <20070825122324.GA6138@slug> <20070825211405.GA18217@slug> <1188230999.5531.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188230999.5531.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 02:09:59AM +1000, Rusty Russell wrote:
> If the stack pointer is 0xc057a000, then the first stack page is at
> 0xc0579000 (the stack pointer is decremented before use).  Not
> calculating this correctly caused guests with CONFIG_DEBUG_PAGEALLOC=y
> to be killed with a "bad stack page" message: the initial kernel stack
> was just preceeding the .smp_locks section which
> CONFIG_DEBUG_PAGEALLOC marks read-only when freeing.
> 
Hello Rusty,

I just could try the patch, sorry for the delay. Albeit it allows to
progress a little further in the boot process, lguest seems to like that
"section that was just freed" :)

Please note that:
- It could progress to "Freeing SMP alternatives: 13k freed", which is new.
  Indeed, your patch made the Host to pin 0xc04d3000, which is the
  good page.
- 0xc04d4000 is the __smp_locks section:
 $ objdump -h vmlinux
 [...]
 20 .data.init_task 00001000  c04d3000  004d3000  003d4000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 21 .smp_locks    000036c8  c04d4000  004d4000  003d5000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 [...]

[    0.128503] SMP alternatives: switching to UP code
[    0.132846] Freeing SMP alternatives: 13k freed
[    0.135177] BUG: unable to handle kernel paging request at virtual address c04d4000
[    0.135417]  printing eip:
[    0.135505] c01051df
[    0.135564] *pde = 00005067
[    0.135645] *pte = 004d4000
[    0.135756] Oops: 0000 [#1]
[    0.135825] PREEMPT SMP DEBUG_PAGEALLOC
[    0.136039] Modules linked in:
[    0.136205] CPU:    0
[    0.136206] EIP:    0061:[<c01051df>]    Not tainted VLI
[    0.136207] EFLAGS: 00010097   (2.6.23-rc3 #5)
[    0.136665] EIP is at dump_trace+0x5f/0x97
[    0.136738] eax: c0614954   ebx: c04d3ffc   ecx: c0497b00   edx: c04ef641
[    0.136883] esi: c04d3000   edi: c04d3ffd   ebp: c04d3da0   esp: c04d3d90
[    0.137058] ds: 0069   es: 0069   fs: 00d8  gs: 0000  ss: 0069
[    0.137235] Process swapper (pid: 0, ti=c04d3000 task=c04953e0 task.ti=c04d3000)
[    0.137447] Stack: c0109d95 c0614954 c04953e0 00000000 c04d3db4 c010a1f1 c0497b00 c0614954
[    0.137831]        c0614954 c04d3dc4 c0140921 c0144252 c04959c8 c04d3dec c014272f c02eccf5
[    0.138119]        c04959c8 c0614938 c04d3dec 00000001 c04959c8 c0614938 c04953e0 c04d3e4c
[    0.138497] Call Trace:
[    0.138603]  [<c0105231>] show_trace_log_lvl+0x1a/0x2f
[    0.138798]  [<c01052e1>] show_stack_log_lvl+0x9b/0xa3
[    0.138942]  [<c01054c1>] show_registers+0x1d8/0x30d
[    0.139120]  [<c010571d>] die+0x127/0x20a
[    0.139272]  [<c011c470>] do_page_fault+0x512/0x5e6
[    0.139470]  [<c038ec02>] error_code+0x72/0x78
[    0.139678]  [<c010a1f1>] save_stack_trace+0x23/0x3e
[    0.139869]  [<c0140921>] save_trace+0x3a/0x8e
[    0.140049]  [<c014272f>] mark_lock+0x7b/0x471
[    0.140223]  [<c01436fc>] __lock_acquire+0x51a/0xc99
[    0.140374]  [<c0143f0c>] lock_acquire+0x91/0xb5
[    0.140546]  [<c038e491>] _spin_lock_irq+0x47/0x71
[    0.140693]  [<c01354c9>] alloc_pid+0x1ce/0x22f
[    0.140867]  [<c0125ce5>] do_fork+0x15/0x1bf
[    0.141011]  [<c0102339>] kernel_thread+0x88/0x90
[    0.141170]  [<c038b2b8>] rest_init+0x14/0x63
[    0.141345]  [<c04d895e>] start_kernel+0x317/0x31f
[    0.141565]  [<c04ef641>] lguest_init+0x2af/0x2d5
[    0.141736] BUG: unable to handle kernel paging request at virtual address c04d4000
[    0.142195]  printing eip:
[    0.142259] c01051df
[    0.142335] *pde = 00005067
[    0.142418] *pte = 004d4000
[    0.142501] Oops: 0000 [#2]
[    0.142581] PREEMPT SMP DEBUG_PAGEALLOC
[    0.142775] Modules linked in:
[    0.142929] CPU:    0
[    0.142930] EIP:    0061:[<c01051df>]    Not tainted VLI
[    0.142931] EFLAGS: 00010097   (2.6.23-rc3 #5)
[    0.143296] EIP is at dump_trace+0x5f/0x97
[    0.143409] eax: c0430e58   ebx: c04d3ffc   ecx: c0497058   edx: 00000000
[    0.143611] esi: c04d3000   edi: c04d3ffd   ebp: c04d3c1c   esp: c04d3c0c
[    0.143800] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0069
[    0.143988] Process swapper (pid: 0, ti=c04d3000 task=c04953e0 task.ti=c04d3000)
[    0.144213] Stack: 34373331 c0430e58 00000018 00000000 c04d3c30 c0105231 c0497058 c0430e58
[    0.144634]        c04d3df3 c04d3c54 c01052e1 c0430e58 c0430e58 c04d3d58 c04d3d90 00000000
[    0.145055]        0000002b c04d3d58 c04d3cc0 c01054c1 c0430e58 00000010 c0495614 00000000
[    0.145439] Call Trace:
[    0.145511]  [<c0105231>] show_trace_log_lvl+0x1a/0x2f
[    0.145607]  [<c01052e1>] show_stack_log_lvl+0x9b/0xa3
[    0.145723]  [<c01054c1>] show_registers+0x1d8/0x30d
[    0.145849]  [<c010571d>] die+0x127/0x20a
[    0.145980]  [<c011c470>] do_page_fault+0x512/0x5e6
[    0.146125]  [<c038ec02>] error_code+0x72/0x78
[    0.146281]  [<c0105231>] show_trace_log_lvl+0x1a/0x2f
[    0.146423]  [<c01052e1>] show_stack_log_lvl+0x9b/0xa3
[    0.146587]  [<c01054c1>] show_registers+0x1d8/0x30d
[    0.146746]  [<c010571d>] die+0x127/0x20a
[    0.146895]  [<c011c470>] do_page_fault+0x512/0x5e6
[    0.147061]  [<c038ec02>] error_code+0x72/0x78
[    0.147213]  [<c010a1f1>] save_stack_trace+0x23/0x3e
[    0.147361]  [<c0140921>] save_trace+0x3a/0x8e
[    0.147531]  [<c014272f>] mark_lock+0x7b/0x471
[    0.147681]  [<c01436fc>] __lock_acquire+0x51a/0xc99
[    0.147839]  [<c0143f0c>] lock_acquire+0x91/0xb5
[    0.147987]  [<c038e491>] _spin_lock_irq+0x47/0x71
[    0.148136]  [<c01354c9>] alloc_pid+0x1ce/0x22f
[    0.148284]  [<c0125ce5>] do_fork+0x15/0x1bf
[    0.148458]  [<c0102339>] kernel_thread+0x88/0x90
[    0.148619]  [<c038b2b8>] rest_init+0x14/0x63
[    0.148766]  [<c04d895e>] start_kernel+0x317/0x31f
[    0.148923]  [<c04ef641>] lguest_init+0x2af/0x2d5
[    0.149076] BUG: unable to handle kernel paging request at virtual address c04d4000
[    0.149297]  printing eip:
[    0.149371] c01051df
[    0.149473] *pde = 00005067
[    0.149547] *pte = 004d4000
[    0.149623] Recursive die() failure, output suppressed
[    0.149807] Kernel panic - not syncing: Attempted to kill the idle task!



Regards,
Frederik
