Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXHVBGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXHVBGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXHVBGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:06:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37310 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbXHVBGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:06:21 -0400
Date: Tue, 21 Aug 2007 18:06:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822003834.GB1400@Krystal>
Message-ID: <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
References: <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
 <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
 <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de>
 <20070822003834.GB1400@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Measurements vs. simple cmpxchg on a Intel(R) Pentium(R) 4 CPU 3.20GHz 
(hyperthreading enabled). Test run with your module show only minor 
performance improvements and lots of regressions. So we must have 
cmpxchg_local to see any improvements? Some kind of a recent optimization 
of cmpxchg performance that we do not see on older cpus?


Code of kmem_cache_alloc (to show you that there are no debug options on):

Dump of assembler code for function kmem_cache_alloc:
0x4015cfa9 <kmem_cache_alloc+0>:        push   %ebp
0x4015cfaa <kmem_cache_alloc+1>:        mov    %esp,%ebp
0x4015cfac <kmem_cache_alloc+3>:        push   %edi
0x4015cfad <kmem_cache_alloc+4>:        push   %esi
0x4015cfae <kmem_cache_alloc+5>:        push   %ebx
0x4015cfaf <kmem_cache_alloc+6>:        sub    $0x10,%esp
0x4015cfb2 <kmem_cache_alloc+9>:        mov    %eax,%esi
0x4015cfb4 <kmem_cache_alloc+11>:       mov    %edx,0xffffffe8(%ebp)
0x4015cfb7 <kmem_cache_alloc+14>:       mov    0x4(%ebp),%eax
0x4015cfba <kmem_cache_alloc+17>:       mov    %eax,0xfffffff0(%ebp)
0x4015cfbd <kmem_cache_alloc+20>:       mov    %fs:0x404af008,%eax
0x4015cfc3 <kmem_cache_alloc+26>:       mov    0x90(%esi,%eax,4),%edi
0x4015cfca <kmem_cache_alloc+33>:       mov    (%edi),%ecx
0x4015cfcc <kmem_cache_alloc+35>:       test   %ecx,%ecx
0x4015cfce <kmem_cache_alloc+37>:       je     0x4015d00a <kmem_cache_alloc+97>
0x4015cfd0 <kmem_cache_alloc+39>:       mov    0xc(%edi),%eax
0x4015cfd3 <kmem_cache_alloc+42>:       mov    (%ecx,%eax,4),%eax
0x4015cfd6 <kmem_cache_alloc+45>:       mov    %eax,%edx
0x4015cfd8 <kmem_cache_alloc+47>:       mov    %ecx,%eax
0x4015cfda <kmem_cache_alloc+49>:       lock cmpxchg %edx,(%edi)
0x4015cfde <kmem_cache_alloc+53>:       mov    %eax,%ebx
0x4015cfe0 <kmem_cache_alloc+55>:       cmp    %ecx,%eax
0x4015cfe2 <kmem_cache_alloc+57>:       jne    0x4015cfbd <kmem_cache_alloc+20>
0x4015cfe4 <kmem_cache_alloc+59>:       cmpw   $0x0,0xffffffe8(%ebp)
0x4015cfe9 <kmem_cache_alloc+64>:       jns    0x4015d006 <kmem_cache_alloc+93>
0x4015cfeb <kmem_cache_alloc+66>:       mov    0x10(%edi),%edx
0x4015cfee <kmem_cache_alloc+69>:       xor    %eax,%eax
0x4015cff0 <kmem_cache_alloc+71>:       mov    %edx,%ecx
0x4015cff2 <kmem_cache_alloc+73>:       shr    $0x2,%ecx
0x4015cff5 <kmem_cache_alloc+76>:       mov    %ebx,%edi

Base

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 332 cycles kfree -> 422 cycles
10000 times kmalloc(16) -> 218 cycles kfree -> 360 cycles
10000 times kmalloc(32) -> 214 cycles kfree -> 368 cycles
10000 times kmalloc(64) -> 244 cycles kfree -> 390 cycles
10000 times kmalloc(128) -> 320 cycles kfree -> 417 cycles
10000 times kmalloc(256) -> 438 cycles kfree -> 550 cycles
10000 times kmalloc(512) -> 527 cycles kfree -> 626 cycles
10000 times kmalloc(1024) -> 678 cycles kfree -> 775 cycles
10000 times kmalloc(2048) -> 748 cycles kfree -> 822 cycles
10000 times kmalloc(4096) -> 641 cycles kfree -> 650 cycles
10000 times kmalloc(8192) -> 741 cycles kfree -> 817 cycles
10000 times kmalloc(16384) -> 872 cycles kfree -> 927 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 332 cycles
10000 times kmalloc(16)/kfree -> 327 cycles
10000 times kmalloc(32)/kfree -> 323 cycles
10000 times kmalloc(64)/kfree -> 320 cycles
10000 times kmalloc(128)/kfree -> 320 cycles
10000 times kmalloc(256)/kfree -> 333 cycles
10000 times kmalloc(512)/kfree -> 332 cycles
10000 times kmalloc(1024)/kfree -> 330 cycles
10000 times kmalloc(2048)/kfree -> 334 cycles
10000 times kmalloc(4096)/kfree -> 674 cycles
10000 times kmalloc(8192)/kfree -> 1155 cycles
10000 times kmalloc(16384)/kfree -> 1226 cycles

Slub cmpxchg.

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 296 cycles kfree -> 515 cycles
10000 times kmalloc(16) -> 193 cycles kfree -> 412 cycles
10000 times kmalloc(32) -> 188 cycles kfree -> 422 cycles
10000 times kmalloc(64) -> 222 cycles kfree -> 441 cycles
10000 times kmalloc(128) -> 292 cycles kfree -> 476 cycles
10000 times kmalloc(256) -> 414 cycles kfree -> 589 cycles
10000 times kmalloc(512) -> 513 cycles kfree -> 673 cycles
10000 times kmalloc(1024) -> 694 cycles kfree -> 825 cycles
10000 times kmalloc(2048) -> 739 cycles kfree -> 878 cycles
10000 times kmalloc(4096) -> 636 cycles kfree -> 653 cycles
10000 times kmalloc(8192) -> 715 cycles kfree -> 799 cycles
10000 times kmalloc(16384) -> 855 cycles kfree -> 927 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 354 cycles
10000 times kmalloc(16)/kfree -> 336 cycles
10000 times kmalloc(32)/kfree -> 335 cycles
10000 times kmalloc(64)/kfree -> 337 cycles
10000 times kmalloc(128)/kfree -> 337 cycles
10000 times kmalloc(256)/kfree -> 355 cycles
10000 times kmalloc(512)/kfree -> 354 cycles
10000 times kmalloc(1024)/kfree -> 337 cycles
10000 times kmalloc(2048)/kfree -> 339 cycles
10000 times kmalloc(4096)/kfree -> 674 cycles
10000 times kmalloc(8192)/kfree -> 1128 cycles
10000 times kmalloc(16384)/kfree -> 1240 cycles


