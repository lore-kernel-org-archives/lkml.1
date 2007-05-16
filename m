Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbXEPIXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbXEPIXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXEPIX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:23:26 -0400
Received: from gw.goop.org ([64.81.55.164]:36413 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbXEPIXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:23:25 -0400
Message-ID: <464ABF7C.1000307@goop.org>
Date: Wed, 16 May 2007 01:23:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc1-mm1: boot failure under qemu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-rc1-mm1 doesn't boot for me under qemu or kvm.  Under qemu it
just hangs sullenly, but kvm gives a more useful dump:

(qemu) exception 13 (0)
rax 000000004050ffff rbx 0000000000009000 rcx 0000000000000000 rdx 0000000000007b00
rsi 000000000001fc05 rdi 0000000000040000 rsp 0000000000008f9a rbp 0000000000008100
r8  0000000000000000 r9  0000000000000000 r10 0000000000000000 r11 0000000000000000
r12 0000000000000000 r13 0000000000000000 r14 0000000000000000 r15 0000000000000000
rip 0000000000001062 rflags 00033046
cs 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
ds 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
es 8100 (00081000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
ss 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
fs 9900 (00099000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
gs 9000 (00090000/0000ffff p 1 dpl 3 db 0 s 1 type 3 l 0 g 0 avl 0)
tr 0000 (30850000/00002088 p 1 dpl 0 db 0 s 0 type b l 0 g 0 avl 0)
ldt 0000 (00000000/0000ffff p 1 dpl 0 db 0 s 0 type 2 l 0 g 0 avl 0)
gdt fa4e4/30
idt 0/3ff
cr0 60000010 cr2 0 cr3 0 cr4 0 cr8 0 efer 0

rip/eip 0x1062 seems to correspond to:

        else
                while (num != 0)
                        tmp[i++] = digits[do_div(num, base)];
    1050:       66 89 f0                mov    %esi,%eax
    1053:       66 31 d2                xor    %edx,%edx
    1056:       66 f7 f5                div    %ebp
    1059:       66 89 c6                mov    %eax,%esi
    105c:       67 66 8b 44 24 28       addr32 mov 0x28(%esp),%eax
    1062:       67 8a 14 10             addr32 mov (%eax,%edx,1),%dl
    1066:       67 66 8b 44 24 2c       addr32 mov 0x2c(%esp),%eax
    106c:       67 88 54 04 3e          addr32 mov %dl,0x3e(%esp,%eax,1)


0x1062 is in number (/home/jeremy/hg/xen/paravirt/linux/arch/i386/boot/printf.c:109).
104             i = 0;
105             if (num == 0)
106                     tmp[i++] = '0';
107             else
108                     while (num != 0)
109                             tmp[i++] = digits[do_div(num, base)];
110             if (i > precision)
111                     precision = i;
112             size -= precision;
113             if (!(type & (ZEROPAD + LEFT)))


I haven't tried booting on real hardware, but this is a definite
regression from the old setup code.

    J
