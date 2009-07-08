Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZGHLHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZGHLHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZGHLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:07:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:33035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753051AbZGHLHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:07:24 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+EMp8jfROEurPAYr46UwtI1i8I7QkIu9yaxP9Smk
	4maQ2HnmYxqQKW
Date: Wed, 8 Jul 2009 13:07:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: kernel@avr32linux.org, linux-mm@kvack.org
Subject: [BUG 2.6.30] Bad page map in process
Message-ID: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

with a 2.6.30 kernel with only platform-specific modifications and this 
avr32 patch:

http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=bb6e647051a59dca5a72b3deef1e061d7c1c34da

we're seeing kernel BUGs following an application segfault. Here's an 
example:

[60254.432000] application[465]: segfault at 4377f876 pc 2aaabbde sp 7faa77f0 ecr 24
[60255.396000] BUG: Bad page map in process application  pte:13f26ed4 pmd:92fdd000
[60255.404000] page:902c44c0 flags:0000002c count:1 mapcount:-1 mapping:9345765c index:5
[60255.412000] addr:2ae4f000 vm_flags:08000075 anon_vma:(null) mapping:93454dd4 index:0
[60255.420000] vma->vm_ops->fault: filemap_fault+0x0/0x26c
[60255.424000] vma->vm_file->f_op->mmap: generic_file_readonly_mmap+0x0/0x18
[60255.432000] Call trace:
[60255.432000]  [<90027b7c>] dump_stack+0x18/0x20
[60255.432000]  [<9005f2e8>] print_bad_pte+0x120/0x13c
[60255.432000]  [<90060964>] unmap_vmas+0x230/0x3e4
[60255.432000]  [<90061ed2>] exit_mmap+0x5e/0xd0
[60255.432000]  [<9002d380>] mmput+0x24/0x7c
[60255.432000]  [<9002fd70>] exit_mm+0xb4/0xb8
[60255.432000]  [<90030ede>] do_exit+0xde/0x3d8
[60255.432000]  [<90031222>] do_group_exit+0x4a/0x64
[60255.432000]  [<9003688e>] get_signal_to_deliver+0x22a/0x24c
[60255.432000]  [<900272ce>] do_signal+0x52/0x3f0
[60255.432000]  [<90027698>] do_notify_resume+0x2c/0xfc
[60255.432000]  [<900233d2>] fault_exit_work+0x24/0x36
[60255.432000] 
[60255.432000] Disabling lock debugging due to kernel taint
[60255.432000] BUG: Bad page state in process application  pfn:13f26
[60255.440000] page:902c44c0 flags:0000000c count:0 mapcount:-1 mapping:9345765c index:5
[60255.448000] Call trace:
[60255.448000]  [<90027b7c>] dump_stack+0x18/0x20
[60255.448000]  [<90054c76>] bad_page+0xa6/0xd0
[60255.448000]  [<900557e6>] free_hot_cold_page+0xa2/0x160
[60255.448000]  [<900558dc>] free_hot_page+0x8/0xc
[60255.448000]  [<90057bae>] put_page+0xca/0xe8
[60255.448000]  [<900662a4>] free_page_and_swap_cache+0x38/0x3c
[60255.448000]  [<90060972>] unmap_vmas+0x23e/0x3e4
[60255.448000]  [<90061ed2>] exit_mmap+0x5e/0xd0
[60255.448000]  [<9002d380>] mmput+0x24/0x7c
[60255.448000]  [<9002fd70>] exit_mm+0xb4/0xb8
[60255.448000]  [<90030ede>] do_exit+0xde/0x3d8
[60255.448000]  [<90031222>] do_group_exit+0x4a/0x64
[60255.448000]  [<9003688e>] get_signal_to_deliver+0x22a/0x24c
[60255.448000]  [<900272ce>] do_signal+0x52/0x3f0
[60255.448000]  [<90027698>] do_notify_resume+0x2c/0xfc
[60255.448000]  [<900233d2>] fault_exit_work+0x24/0x36
[60255.448000] 

Questions: can this BUG be caused by the segfault (it better not)? If not, 
what can be the reason? The problem occurs sporadically, I've only had one 
such case since yesterday. Yet one more application segfault last night 
didn't produce a BUG. This is with a kernel configured with SLAB. With 
SLUB we also observed similar BUGs on application exit but without signal 
handling path in the backtrace. But, I think, I've had other problems with 
SLUB before, so, we switched back to SLAB for now...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
