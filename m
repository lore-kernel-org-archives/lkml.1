Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZK2Nsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZK2Nsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 08:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZK2Nsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 08:48:30 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:40986 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZK2Ns2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 08:48:28 -0500
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com>
From: Nix <nix@esperi.org.uk>
Emacs: because idle RAM is the Devil's playground.
Date: Sun, 29 Nov 2009 13:48:16 +0000
In-Reply-To: <4B125051.6010506@redhat.com> (Avi Kivity's message of "Sun, 29 Nov 2009 12:43:29 +0200")
Message-ID: <87k4x9saqn.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Nov 2009, Avi Kivity uttered the following:
> 66 0f 7f 07              movdqa %xmm0,(%rdi)
>
> which we don't emulate.

x86-64 glibc 2.10 memset(), perhaps? On SSE-capable platforms that does
a whole bunch of

L(SSE0QB):  movdqa %xmm0,-0xb0(%rdi)
L(SSE0QA):  movdqa %xmm0,-0xa0(%rdi)
L(SSE0Q9):  movdqa %xmm0,-0x90(%rdi)
L(SSE0Q8):  movdqa %xmm0,-0x80(%rdi)
L(SSE0Q7):  movdqa %xmm0,-0x70(%rdi)
L(SSE0Q6):  movdqa %xmm0,-0x60(%rdi)
L(SSE0Q5):  movdqa %xmm0,-0x50(%rdi)
L(SSE0Q4):  movdqa %xmm0,-0x40(%rdi)
L(SSE0Q3):  movdqa %xmm0,-0x30(%rdi)
L(SSE0Q2):  movdqa %xmm0,-0x20(%rdi)
L(SSE0Q1):  movdqa %xmm0,-0x10(%rdi)
L(SSE0Q0):  retq

(multiple blocks of this, catering for alignment, I guess)

and x86-64 is always SSE-capable.

> Can you, using the qemu monitor, see where the guest is trying to write?
>
>   (qemu) info registers
>   (qemu) x/30i $eip - 20

looks like a leaveq, consistently (big flow-of-control change): want a
dump of some higher stack frames?

(qemu) info registers
RAX=0000000000000000 RBX=ffffffff81813a28 RCX=0000000000000000 RDX=0000000000000000
RSI=0000000000000001 RDI=ffffffff818f4fa8 RBP=ffffffff81769eb8 RSP=ffffffff81769eb8
R8 =0000000000000000 R9 =ffffffff81925418 R10=000000000000000e R11=0000000000ffff0e
R12=6db6db6db6db6db7 R13=ffffffff818f2000 R14=ffffffff81769fa8 R15=000000000008c000
RIP=ffffffff810316f6 RFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
FS =0000 0000000000000000 ffffffff 00000000
GS =0000 ffff8800019c5000 ffffffff 00000000
LDT=0000 0000000000000000 ffffffff 00000000
TR =0040 ffff8800019d8140 00002087 00008b00 DPL=0 TSS64-busy
GDT=     ffff8800019c9000 0000007f
IDT=     ffffffff818f2000 00000fff
CR0=8005003b CR2=0000000000f57000 CR3=000000003dc13000 CR4=000006b0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00000000
FPR0=0000000000000025 ffff FPR1=000000000000001b ffff
FPR2=12a05f24a8000000 ffff FPR3=00000002540be495 ffff
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 ffff
XMM00=0000ff0000000000000000000000ff00 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=000000000000000000000000000000ff
XMM04=0000000000000000406e000000000000 XMM05=00000000000000003fd8234618ab9d47
XMM06=00000000000000003fd8234618ab9d47 XMM07=00000000000000003fec5c5c5c5c5c5c
XMM08=00000000000000004032000000000000 XMM09=0000000000000000404e000000000000
XMM10=0000000000000000405e000000000000 XMM11=00000000000000000000000000000000
XMM12=00000000000000000000000000000000 XMM13=00000000000000000000000000000000
XMM14=00000000000000000000000000000000 XMM15=00000000000000000000000000000000

(qemu) x/30i $eip - 20
0xffffffff810316e2:  mov    %esp,%ebp
0xffffffff810316e4:  sti
0xffffffff810316e5:  leaveq
0xffffffff810316e6:  retq
0xffffffff810316e7:  nopw   0x0(%rax,%rax,1)
0xffffffff810316f0:  push   %rbp
0xffffffff810316f1:  mov    %rsp,%rbp
0xffffffff810316f4:  sti
0xffffffff810316f5:  hlt
0xffffffff810316f6:  leaveq
0xffffffff810316f7:  retq
0xffffffff810316f8:  nopl   0x0(%rax,%rax,1)
0xffffffff81031700:  push   %rbp
0xffffffff81031701:  mov    %rsp,%rbp
0xffffffff81031704:  hlt
0xffffffff81031705:  leaveq
0xffffffff81031706:  retq
0xffffffff81031707:  nopw   0x0(%rax,%rax,1)
0xffffffff81031710:  push   %rbp
0xffffffff81031711:  mov    %rsp,%rbp
0xffffffff81031714:  clts
0xffffffff81031716:  leaveq
0xffffffff81031717:  retq
0xffffffff81031718:  nopl   0x0(%rax,%rax,1)
0xffffffff81031720:  push   %rbp
0xffffffff81031721:  mov    %rsp,%rbp
0xffffffff81031724:  mov    %cr0,%rax
0xffffffff81031727:  leaveq
0xffffffff81031728:  retq
0xffffffff81031729:  nopl   0x0(%rax)
