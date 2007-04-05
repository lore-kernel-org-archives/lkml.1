Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbXDEQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbXDEQ1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXDEQ1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:27:30 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:6427 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbXDEQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:27:13 -0400
X-AuditID: d80ac287-976cabb000000c42-b4-461523612883 
Date: Thu, 5 Apr 2007 17:26:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Pat <patchu1@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Invalid operand: kernel BUG at mm/rmap.c:434! and
 arch/i386/mm/highmem.c:42!)
In-Reply-To: <214905.55943.qm@web32511.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0704051700240.3137@blonde.wat.veritas.com>
References: <214905.55943.qm@web32511.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 05 Apr 2007 16:27:12.0858 (UTC) FILETIME=[440D5BA0:01C7779F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Pat wrote:

> I'm running kernel 2.6.9-22.ELsmp on dual Xeon

You'd do better to ask Red Hat support than here.

> servers. I've received kernel panics occasionally in
> the past, but they are more frequent now as the load
> on the system has increased. Below is a capture of the
> kernel panic. 

Are the initial BUGs usually of that kind - rmap.c:434?

(The subsequent scheduling-while-atomics and highmem.c:42s
are not interesting, just consequences of the original BUG
in an untidy place.)

> If anything below screams it's coming from a certain
> source (defective RAM? Bad application or device
> driver?), please let me know as I'm pulling what
> little hair I have left out on this one. Suggestions
> on what to try would be greatly appreciated. Thanks! 

I've never seen a BUG in page_add_anon_rmap before:
there's one in page_remove_rmap which comes up from time
to time, but this is different.

The page allocator has just dished out a PageReserved page
(at physical 1G+8k: interesting that it's so close to 1G),
which should never happen - but there was less checking
for that in 2.6.9-based kernels.

Do check your RAM (memtest86 overnight), maybe that
PG_reserved bit is spurious.  But if rmap.c:434 is
what's happening to you again and again, I'd wonder
if a driver has been allocating a high-order page,
marking the constituent pages as reserved, later
clearing reserved from the first constituent page,
then freeing the high-order page while leaving other
reserved bits behind - I believe that could sneak a
PageReserved page back into the 2.6.9 allocator.

If it were a particular application triggering this,
it'd still be a kernel bug to allow it to happen.

Hugh

> ------------[ cut here ]------------
> kernel BUG at mm/rmap.c:434!
> invalid operand: 0000 [#1]
> SMP 
> Modules linked in: fusedriver(U) md5 ipv6 parport_pc
> lp parport autofs4 i2c_dev i2c_core sunrpc
> dm_multipath button battery ac uhci_hcd ehci_hcd e1000
> floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
> 3w_9xxx(U) sd_mod scsi_mod
> CPU:    5
> EIP:    0060:[<c01518c6>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.9-22.ELsmp) 
> EIP is at page_add_anon_rmap+0xe/0x66
> eax: 40000964   ebx: c1800040   ecx: 090a100c   edx:
> e5b5a544
> esi: d1837e8c   edi: fff25508   ebp: c1800040   esp:
> cf12ae40
> ds: 007b   es: 007b   ss: 0068
> Process check-enqueued- (pid: 17602,
> threadinfo=cf12a000 task=f57577b0)
> Stack: 40002067 80000000 c014d034 fff29000 40002025
> 80000000 00000163 e5b5a544 
>        f35b9080 00000000 fff25508 fff25508 090a100c
> c014d0e2 cc5a2240 00000001 
>        090a100c ffffffff ffffffff 00000000 00000000
> 80000000 00000000 00000000 
> Call Trace:
>  [<c014d034>] do_anonymous_page+0x19c/0x1db
>  [<c014d0e2>] do_no_page+0x6f/0x2f9
>  [<c014d503>] handle_mm_fault+0xbd/0x175
>  [<c011addb>] do_page_fault+0x1ae/0x5c6
>  [<c014e58e>] vma_adjust+0x286/0x2d6
>  [<c014e762>] vma_merge+0xe1/0x165
>  [<c011d3d5>] finish_task_switch+0x30/0x66
>  [<c02cf368>] schedule+0x844/0x87a
>  [<c011ac2d>] do_page_fault+0x0/0x5c6
>  [<c02d1bab>] error_code+0x2f/0x38
> Code: 83 7b 10 00 74 0b 89 ca 89 d8 e8 fb fe ff ff 01
> c6 89 d8 e8 ac df fe ff 5b 89 f0 5e c3 56 53 89 c3 8b
> 00 8b 72 44 f6 c4 08 74 08 <0f> 0b b2 01 ce 52 2e c0
> 85 f6 75 08 0f 0b b3 01 ce 52 2e c0 8b 
