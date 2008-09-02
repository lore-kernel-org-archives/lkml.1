Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYIBVGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYIBVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYIBVGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:06:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:61038 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYIBVGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Kj6uipv0z9r7NgaU01p30JUyWdn3hKCOE0YH0Gycu45K7nFPQ6lbJDqhnk9LJgtwY7
         WYRRXymF9bdQ/+w+QXGv24C4So6jTHnTmKFRIRfQpHOk6SiKXeW5CgsQkO9D1d3C1Wzg
         GtcREInuPHdCIwL8LcoL7OZq6BE1ieY+GKS1A=
Date: Tue, 2 Sep 2008 23:06:46 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com
Subject: [2.6.27] early exception - lockdep related?
Message-ID: <20080902210646.GA10925@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm seeing an early exception (0e) - which seems related to lockdep - at
boot with many 2.6.27 kernels and I'm having troubles to track it down.
The strange thing is that it comes and goes with different kernel
versions, but a "bad" kernel consistently fails across reboots. It also
seems to be sensitive to the configuration (attached), at least in one
case the difference between a non-working kernel and a working one is
CONFIG_DEBUG enabled in the latter.

The address printed is inside the function __lock_acqurie:

in __lock_acquire (/home/kronos/src/linux-2.6.git/kernel/lockdep.c:727).
722
723             /*
724              * We can walk the hash lockfree, because the hash only
725              * grows, and we are careful when adding entries to the end:
726              */
727             list_for_each_entry(class, hash_head, hash_entry) {
728                     if (class->key == key) {
729                             WARN_ON_ONCE(class->name != lock->name);
730                             return class;
731                     }

And the disassembly (faulting address is 0xffffffff80253b66)

0xffffffff80253b00 <__lock_acquire+299>:        shr    $0x34,%rax
0xffffffff80253b04 <__lock_acquire+303>:        shl    $0x4,%rax
0xffffffff80253b08 <__lock_acquire+307>:        lea    -0x7f57e9b0(%rax),%rdx
0xffffffff80253b0f <__lock_acquire+314>:        mov    -0x7f57e9b0(%rax),%r13
0xffffffff80253b16 <__lock_acquire+321>:        jmp    0xffffffff80253b66 <__lock_acquire+401>
0xffffffff80253b18 <__lock_acquire+323>:        cmp    %r8,0x20(%r13)
0xffffffff80253b1c <__lock_acquire+327>:        jne    0xffffffff80253b63 <__lock_acquire+398>
0xffffffff80253b1e <__lock_acquire+329>:        mov    -0x90(%rbp),%r10
0xffffffff80253b25 <__lock_acquire+336>:        mov    0x10(%r10),%r10
0xffffffff80253b29 <__lock_acquire+340>:        cmp    %r10,0x140(%r13)
0xffffffff80253b30 <__lock_acquire+347>:        je     0xffffffff80253ea0 <__lock_acquire+1227>
0xffffffff80253b36 <__lock_acquire+353>:        cmpl   $0x0,0x51dc4f(%rip)
  # 0xffffffff8077178c <__warned.16970>
0xffffffff80253b3d <__lock_acquire+360>:        jne    0xffffffff80253ea0 <__lock_acquire+1227>
0xffffffff80253b43 <__lock_acquire+366>:        mov    $0x2d9,%esi
0xffffffff80253b48 <__lock_acquire+371>:        mov    $0xffffffff805691c7,%rdi
0xffffffff80253b4f <__lock_acquire+378>:        callq  0xffffffff80232bae <warn_on_slowpath>
0xffffffff80253b54 <__lock_acquire+383>:        movl   $0x1,0x51dc2e(%rip)
  # 0xffffffff8077178c <__warned.16970>
0xffffffff80253b5e <__lock_acquire+393>:        jmpq   0xffffffff80253ea0 <__lock_acquire+1227>
0xffffffff80253b63 <__lock_acquire+398>:        mov    %rax,%r13 
0xffffffff80253b66 <__lock_acquire+401>:        mov    0x0(%r13),%rax <-- HERE
0xffffffff80253b6a <__lock_acquire+405>:        cmp    %rdx,%r13
0xffffffff80253b6d <__lock_acquire+408>:        prefetcht0 (%rax)
0xffffffff80253b70 <__lock_acquire+411>:        jne    0xffffffff80253b18 <__lock_acquire+323>
0xffffffff80253b72 <__lock_acquire+413>:        callq  0xffffffff802513ba <static_obj>
0xffffffff80253b77 <__lock_acquire+418>:        test   %eax,%eax
0xffffffff80253b79 <__lock_acquire+420>:        jne    0xffffffff80253ba8 <__lock_acquire+467>
0xffffffff80253b7b <__lock_acquire+422>:        callq  0xffffffff8031db50 <debug_locks_off>
0xffffffff80253b80 <__lock_acquire+427>:        mov    $0xffffffff80569212,%rdi
0xffffffff80253b87 <__lock_acquire+434>:        xor    %eax,%eax
0xffffffff80253b89 <__lock_acquire+436>:        callq  0xffffffff80487bd3 <printk>
0xffffffff80253b8e <__lock_acquire+441>:        mov    $0xffffffff8056923c,%rdi
0xffffffff80253b95 <__lock_acquire+448>:        xor    %eax,%eax
0xffffffff80253b97 <__lock_acquire+450>:        callq  0xffffffff80487bd3 <printk>
0xffffffff80253b9c <__lock_acquire+455>:        mov    $0xffffffff8056926c,%rdi
0xffffffff80253ba3 <__lock_acquire+462>:        jmpq   0xffffffff8025477c <__lock_acquire+3495>
0xffffffff80253ba8 <__lock_acquire+467>:        mov    -0x90(%rbp),%rdx
0xffffffff80253baf <__lock_acquire+474>:        mov    (%rdx),%rax
0xffffffff80253bb2 <__lock_acquire+477>:        pushfq
0xffffffff80253bb3 <__lock_acquire+478>:        popq   -0x68(%rbp)
0xffffffff80253bb6 <__lock_acquire+481>:        cli
0xffffffff80253bb7 <__lock_acquire+482>:        mov    $0x100,%ebx
0xffffffff80253bbc <__lock_acquire+487>:        lock xadd %bx,0x51dbcb(%rip)
    # 0xffffffff80771790 <lockdep_lock>
0xffffffff80253bc5 <__lock_acquire+496>:        cmp    %bh,%bl
0xffffffff80253bc7 <__lock_acquire+498>:        je     0xffffffff80253bd3 <__lock_acquire+510>
0xffffffff80253bc9 <__lock_acquire+500>:        pause
0xffffffff80253bcb <__lock_acquire+502>:        mov    0x51dbbf(%rip),%bl
 # 0xffffffff80771790 <lockdep_lock>
0xffffffff80253bd1 <__lock_acquire+508>:        jmp    0xffffffff80253bc5 <__lock_acquire+496>
0xffffffff80253bd3 <__lock_acquire+510>:        cmpl   $0x0,0x397676(%rip)
  # 0xffffffff805eb250 <debug_locks>
0xffffffff80253bda <__lock_acquire+517>:        jne    0xffffffff80253beb <__lock_acquire+534>
0xffffffff80253bdc <__lock_acquire+519>:        incb   0x51dbae(%rip)        # 0xffffffff80771790 <lockdep_lock>
0xffffffff80253be2 <__lock_acquire+525>:        pushq  -0x68(%rbp)
0xffffffff80253be5 <__lock_acquire+528>:        popfq

I actually tried to bisect it using an early working kernel and this first
(read: the first pull from Linus' tree that gave me a broken kernel). The
result is inconclusive, the commit pointed out was:

e5f363e358cf16e4ad13a6826e15088c5495efe9 is first bad commit
commit e5f363e358cf16e4ad13a6826e15088c5495efe9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Aug 11 12:37:27 2008 +0200

    lockdep: increase MAX_LOCKDEP_KEYS

    certain configs produce:

     [   70.076229] BUG: MAX_LOCKDEP_KEYS too low!
     [   70.080230] turning off the locking correctness validator.

    tune them up.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

but reverting it didn't make any difference.

Is there any other action that I can take to debug this issue? Btw, do you
think that kgdb can be usefull? I can give it a try in the weekend...

Luca
-- 
Carpe diem, quam minimum credula postero. (Q. Horatius Flaccus)
