Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZHYQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZHYQ32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZHYQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:29:28 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53800 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbZHYQ31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uOqrL4Y7ai1VONbqPS0xXS4SOJDfyLIGDyTpaSqkZQuzXmiRw7E1Rd4cu9CVorJX4Q
         ICvmizsurjAu3T4sYdPjDBKc5O7Hq3hk51azM6uZxANtdMqtO+YnBSFrptoQZevTnaDJ
         YbGwUqJ2J245YoSIwQCP1LQq8rH+Ybqj4jA1U=
MIME-Version: 1.0
In-Reply-To: <4A9407B1.6020400@nets.rwth-aachen.de>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 19:29:27 +0300
X-Google-Sender-Auth: 53ecd7b0f67adc4f
Message-ID: <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel@lists.xensource.com, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Aug 25, 2009 at 6:48 PM, Arnd
Hannemann<hannemann@nets.rwth-aachen.de> wrote:
> current 2.6.31 fails to boot on our xen host (32bit pae).
> Unfortunately it fails in a way that there is absolutely no output
> on the console. Config is as 32bit guest.
>
> Git bisect gave the following:
>
> 83b519e8b9572c319c8e0c615ee5dd7272856090 is first bad commit
> commit 83b519e8b9572c319c8e0c615ee5dd7272856090
> Author: Pekka Enberg <penberg@cs.helsinki.fi>
> Date:   Wed Jun 10 19:40:04 2009 +0300
>
>    slab: setup allocators earlier in the boot sequence
>
>    This patch makes kmalloc() available earlier in the boot sequence so we can get
>    rid of some bootmem allocations. The bulk of the changes are due to
>    kmem_cache_init() being called with interrupts disabled which requires some
>    changes to allocator boostrap code.
>
>    Note: 32-bit x86 does WP protect test in mem_init() so we must setup traps
>    before we call mem_init() during boot as reported by Ingo Molnar:
>
>      We have a hard crash in the WP-protect code:
>
>      [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
>      [    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
>      [    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
>      [    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
>      [    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
>      [    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
>      [    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
>      [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
>      [    0.000000] Call Trace:
>      [    0.000000]  [<c15357c2>] ? printk+0x14/0x16
>      [    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
>      [    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
>      [    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
>      [    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
>      [    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
>      [    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f
>
>    Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>    Acked-by Linus Torvalds <torvalds@linux-foundation.org>
>    Cc: Christoph Lameter <cl@linux-foundation.org>
>    Cc: Ingo Molnar <mingo@elte.hu>
>    Cc: Matt Mackall <mpm@selenic.com>
>    Cc: Nick Piggin <npiggin@suse.de>
>    Cc: Yinghai Lu <yinghai@kernel.org>
>    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> However a
> git revert 83b519e8b9572c319c8e0c615ee5dd7272856090
> to verify that current git without that commit would work,
> didn't succeed right away, so I was not able to test that.

Thanks for doing the bisect! Can we also see your .config also?

I doubt this is a slab allocator initialization issue so I'm CC'ing
some Xen folks. Jeremy, I don't know Xen well but on quick read, the
only thing that I can see is that trap_init() is called before
sched_init() now. I see Xen doing preempt_enable()/preempt_disable so
maybe that's a problem now?

                                 Pekka
