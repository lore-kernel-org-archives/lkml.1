Return-Path: <linux-kernel-owner+w=401wt.eu-S1750813AbXBOVwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750813AbXBOVwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXBOVwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:52:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbXBOVwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:52:04 -0500
Date: Thu, 15 Feb 2007 13:51:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
Message-Id: <20070215135157.18085ae3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702150926560.25081@d.namei>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702150926560.25081@d.namei>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 09:28:23 -0500 (EST)
James Morris <jmorris@namei.org> wrote:

> Hit a BUG() via lvm:
> 
> 
> Scanning logical volumes
>   Reading all physical volumes.  This may take a while...
>   Found volume group "VolGroup00" using metadata type lvm2
> Activating logical volumes
> [   75.215078] ------------[ cut here ]------------
> [   75.230165] kernel BUG at mm/swap.c:442!
> [   75.244589] invalid opcode: 0000 [#1]
> [   75.258693] PREEMPT SMP 
> [   75.271894] last sysfs file: /block/ram0/dev
> [   75.286734] Modules linked in:
> [   75.300193] CPU:    0
> [   75.300195] EIP:    0060:[<c0150303>]    Not tainted VLI
> [   75.300197] EFLAGS: 00210006   (2.6.20-mm1 #1)
> [   75.341750] EIP is at __pagevec_lru_add_active+0x76/0xcc
> [   75.356722] eax: 80100060   ebx: c1bf9c48   ecx: c1e345bc   edx: 00000001
> [   75.373139] esi: c03dc680   edi: c1c4e780   ebp: f7ce3f34   esp: f7ce3f24
> [   75.389642] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [   75.405199] Process lvm (pid: 415, ti=f7ce2000 task=c1e34070 task.ti=f7ce2000)
> [   75.421908] Stack: 00000000 00000000 c1e25548 f7d58ea0 f7ce3f40 c01504fc c1e25548 f7ce3f70 
> [   75.451375]        c0157b22 c0579820 f7ce5478 00000000 f7d58420 f7d58f00 00000000 00000000 
> [   75.481458]        c1e25548 f7d58420 f7d58420 f7ce3fa0 c0158539 b7fa1000 b7fa2000 b7fa1000 
> [   75.512233] Call Trace:
> [   75.536111]  [<c01039ca>] show_trace_log_lvl+0x1a/0x2f
> [   75.552228]  [<c0103a7a>] show_stack_log_lvl+0x9b/0xaa
> [   75.568329]  [<c0103c6f>] show_registers+0x1e6/0x325
> [   75.584336]  [<c0103ed4>] die+0x126/0x225
> [   75.599300]  [<c010404c>] do_trap+0x79/0x91
> [   75.614358]  [<c0104951>] do_invalid_op+0x97/0xa1
> [   75.629892]  [<c02f8a4c>] error_code+0x7c/0x84
> [   75.645097]  [<c01504fc>] lru_add_drain+0x41/0x8d
> [   75.660599]  [<c0157b22>] unmap_region+0x2a/0x129
> [   75.676116]  [<c0158539>] do_munmap+0x153/0x1b4
> [   75.691497]  [<c01585bf>] sys_munmap+0x25/0x34
> [   75.706737]  [<c01029c0>] syscall_call+0x7/0xb

That's

                VM_BUG_ON(PageMlocked(page));

Setting CONFIG_DEBUG_VM=n will shut it up.

I don't immediately see why that code isn't racy: the page can remain
in the pagevec for arbitrary amounts of time and someone can come along
and mlock it again.  But given the ease with which you're hitting this,
it may not be a race.

