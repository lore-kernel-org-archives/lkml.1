Return-Path: <linux-kernel-owner+w=401wt.eu-S932477AbXGRGel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbXGRGel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764338AbXGRGeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:34:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13836 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764036AbXGRGeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:34:24 -0400
Date: Wed, 18 Jul 2007 14:32:14 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070718063214.GA26481@joejin-pc.cn.oracle.com>
References: <20070712221842.f5e47065.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com> <20070717093228.3a3638aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com> <20070717115849.9f5e435c.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com> <20070717130118.bc78d31a.akpm@linux-foundation.org> <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com> <20070718014027.GA23559@joejin-pc.cn.oracle.com> <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2007-07-18 05:49, Hugh Dickins wrote:
> On Wed, 18 Jul 2007, Joe Jin wrote:
> > 
> > With your patch, I have reproduced the panic:
> 
> That is... surprising to me.  (I hadn't been able to reproduce it with
> or without the patches: maybe I just need to try harder.)  Please post
> your gcc --version, and the disassembly (objdump -d) output for
> alloc_fresh_huge_page.
> 

It will easy to reproduce, just run following scripts on *2* difference
terminal at the same time, I think you will hit it in a short time.

#!/bin/bash
while : ; do
        echo 1000000000000 > /proc/sys/vm/nr_hugepages
        echo 1 > /proc/sys/vm/nr_hugepages
        echo 10000000000000000000 > /proc/sys/vm/nr_hugepages
        echo 0 > /proc/sys/vm/nr_hugepages
done

# gcc --version
gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-52)
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

------------------------------------------------------------------------------------------------------------------------
Disassembly alloc_fresh_huge_page with gdb:

0xffffffff810719cf <alloc_fresh_huge_page+0>:   mov    3651606(%rip),%r8d        # 0xffffffff813ed1ec <prev_nid.16422>
0xffffffff810719d6 <alloc_fresh_huge_page+7>:   mov    2841027(%rip),%rdi        # 0xffffffff813273a0 <node_online_map>
0xffffffff810719dd <alloc_fresh_huge_page+14>:  mov    $0x3f,%eax
0xffffffff810719e2 <alloc_fresh_huge_page+19>:  push   %rbx
0xffffffff810719e3 <alloc_fresh_huge_page+20>:  lea    0x1(%r8),%esi
0xffffffff810719e7 <alloc_fresh_huge_page+24>:  sub    %r8d,%eax
0xffffffff810719ea <alloc_fresh_huge_page+27>:  mov    %rdi,%rdx
0xffffffff810719ed <alloc_fresh_huge_page+30>:  cltq   
0xffffffff810719ef <alloc_fresh_huge_page+32>:  mov    %sil,%cl
0xffffffff810719f2 <alloc_fresh_huge_page+35>:  shr    %cl,%rdx
0xffffffff810719f5 <alloc_fresh_huge_page+38>:  bsf    %rdx,%rcx
0xffffffff810719f9 <alloc_fresh_huge_page+42>:  cmove  %rax,%rcx
0xffffffff810719fd <alloc_fresh_huge_page+46>:  lea    (%rsi,%rcx,1),%ecx
0xffffffff81071a00 <alloc_fresh_huge_page+49>:  mov    $0x40,%eax
0xffffffff81071a05 <alloc_fresh_huge_page+54>:  cmp    $0x40,%ecx
0xffffffff81071a08 <alloc_fresh_huge_page+57>:  cmovg  %eax,%ecx
0xffffffff81071a0b <alloc_fresh_huge_page+60>:  cmp    $0x40,%ecx
0xffffffff81071a0e <alloc_fresh_huge_page+63>:  mov    %ecx,3651540(%rip)        # 0xffffffff813ed1e8 <nid.16423>
0xffffffff81071a14 <alloc_fresh_huge_page+69>:  jne    0xffffffff81071a2f <alloc_fresh_huge_page+96>
0xffffffff81071a16 <alloc_fresh_huge_page+71>:  mov    $0x40,%eax
0xffffffff81071a1b <alloc_fresh_huge_page+76>:  bsf    %rdi,%rdx
0xffffffff81071a1f <alloc_fresh_huge_page+80>:  cmove  %rax,%rdx
0xffffffff81071a23 <alloc_fresh_huge_page+84>:  cmp    $0x40,%edx
0xffffffff81071a26 <alloc_fresh_huge_page+87>:  cmovle %edx,%ecx
0xffffffff81071a29 <alloc_fresh_huge_page+90>:  mov    %ecx,3651513(%rip)        # 0xffffffff813ed1e8 <nid.16423>
0xffffffff81071a2f <alloc_fresh_huge_page+96>:  mov    3651507(%rip),%eax        # 0xffffffff813ed1e8 <nid.16423>
0xffffffff81071a35 <alloc_fresh_huge_page+102>: test   %eax,%eax
0xffffffff81071a37 <alloc_fresh_huge_page+104>: mov    %eax,3651503(%rip)        # 0xffffffff813ed1ec <prev_nid.16422>
0xffffffff81071a3d <alloc_fresh_huge_page+110>: jns    0xffffffff81071a47 <alloc_fresh_huge_page+120>
0xffffffff81071a3f <alloc_fresh_huge_page+112>: mov    %gs:0x30,%eax
0xffffffff81071a47 <alloc_fresh_huge_page+120>: cltq   
0xffffffff81071a49 <alloc_fresh_huge_page+122>: mov    $0x9,%esi
0xffffffff81071a4e <alloc_fresh_huge_page+127>: mov    $0x242d2,%edi
0xffffffff81071a53 <alloc_fresh_huge_page+132>: mov    0xffffffff813260e0(,%rax,8),%rdx
0xffffffff81071a5b <alloc_fresh_huge_page+140>: add    $0x1860,%rdx
0xffffffff81071a62 <alloc_fresh_huge_page+147>: callq  0xffffffff8105d4b8 <__alloc_pages>
0xffffffff81071a67 <alloc_fresh_huge_page+152>: mov    %rax,%rbx
0xffffffff81071a6a <alloc_fresh_huge_page+155>: xor    %eax,%eax
0xffffffff81071a6c <alloc_fresh_huge_page+157>: test   %rbx,%rbx
0xffffffff81071a6f <alloc_fresh_huge_page+160>: je     0xffffffff81071ab4 <alloc_fresh_huge_page+229>
0xffffffff81071a71 <alloc_fresh_huge_page+162>: movq   $0xffffffff81072a02,0x60(%rbx)
0xffffffff81071a79 <alloc_fresh_huge_page+170>: mov    $0xffffffff812e6c68,%rdi
0xffffffff81071a80 <alloc_fresh_huge_page+177>: callq  0xffffffff81217952 <_spin_lock>
0xffffffff81071a85 <alloc_fresh_huge_page+182>: incq   3651428(%rip)        # 0xffffffff813ed1f0 <nr_huge_pages>
0xffffffff81071a8c <alloc_fresh_huge_page+189>: mov    (%rbx),%rax
0xffffffff81071a8f <alloc_fresh_huge_page+192>: shr    $0x2d,%rax
0xffffffff81071a93 <alloc_fresh_huge_page+196>: and    $0x3f,%eax
0xffffffff81071a96 <alloc_fresh_huge_page+199>: incl   0xffffffff813ed620(,%rax,4)
0xffffffff81071a9d <alloc_fresh_huge_page+206>: movl   $0x1,2576833(%rip)        # 0xffffffff812e6c68 <hugetlb_lock>
0xffffffff81071aa7 <alloc_fresh_huge_page+216>: mov    %rbx,%rdi
0xffffffff81071aaa <alloc_fresh_huge_page+219>: callq  0xffffffff8105f9cc <put_page>
0xffffffff81071aaf <alloc_fresh_huge_page+224>: mov    $0x1,%eax
0xffffffff81071ab4 <alloc_fresh_huge_page+229>: pop    %rbx
0xffffffff81071ab5 <alloc_fresh_huge_page+230>: retq   


Thanks,
Joe
