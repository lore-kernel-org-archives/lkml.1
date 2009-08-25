Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZHYPsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZHYPsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZHYPsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:48:42 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:63446 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbZHYPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:48:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
X-IronPort-AV: E=Sophos;i="4.44,273,1249250400";   d="scan'208";a="23636580"
Message-id: <4A9407B1.6020400@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 17:48:01 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: LKML <linux-kernel@vger.kernel.org>
Cc: penberg@cs.helsinki.fi, hannes@cmpxchg.org, torvalds@linux-foundation.org
Subject: [bisected] 2.6.31 regression: fails to boot as xen guest
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

current 2.6.31 fails to boot on our xen host (32bit pae).
Unfortunately it fails in a way that there is absolutely no output
on the console. Config is as 32bit guest.

Git bisect gave the following:

83b519e8b9572c319c8e0c615ee5dd7272856090 is first bad commit
commit 83b519e8b9572c319c8e0c615ee5dd7272856090
Author: Pekka Enberg <penberg@cs.helsinki.fi>
Date:   Wed Jun 10 19:40:04 2009 +0300

    slab: setup allocators earlier in the boot sequence

    This patch makes kmalloc() available earlier in the boot sequence so we can get
    rid of some bootmem allocations. The bulk of the changes are due to
    kmem_cache_init() being called with interrupts disabled which requires some
    changes to allocator boostrap code.

    Note: 32-bit x86 does WP protect test in mem_init() so we must setup traps
    before we call mem_init() during boot as reported by Ingo Molnar:

      We have a hard crash in the WP-protect code:

      [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
      [    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
      [    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
      [    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
      [    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
      [    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
      [    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
      [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
      [    0.000000] Call Trace:
      [    0.000000]  [<c15357c2>] ? printk+0x14/0x16
      [    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
      [    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
      [    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
      [    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
      [    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
      [    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f

    Acked-by: Johannes Weiner <hannes@cmpxchg.org>
    Acked-by Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Christoph Lameter <cl@linux-foundation.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Matt Mackall <mpm@selenic.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

However a
git revert 83b519e8b9572c319c8e0c615ee5dd7272856090
to verify that current git without that commit would work,
didn't succeed right away, so I was not able to test that.

BTW: I only included Acked-by and Signed-off-by as Cc: and dropped
the other Cc: mentioned in the commit, hope that was ok...

Best regards,
Arnd
