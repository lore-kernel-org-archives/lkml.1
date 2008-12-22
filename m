Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYLVMGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYLVMGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYLVMGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:06:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:37145 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbYLVMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LR5Hth/pbZQUjUffU1iZJ4FAd6khG9r5aFz8cT7KcOyK5VpusNhRnaLLiAhgXJxBYb
         hGy5CzrDYH2Zr7exoNTq7s908Kw2IzSpg6pgrax0axC94VyrbO41ATEYVD2lDw9DfLHU
         DT1pVndmBgJZ+Wjz6f8EiONuxZn9FM2smyQiw=
Message-ID: <19f34abd0812220406i36d5df21ka321e3eb4993c54c@mail.gmail.com>
Date: Mon, 22 Dec 2008 13:06:32 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Brad Campbell" <brad@wasp.net.au>
Subject: Re: BUG() in 2.6.28-rc8-git2 under heavy load
Cc: "Manfred Spraul" <manfred@colorfullife.com>,
       "Andi Kleen" <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <494F4C50.1070906@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494F4C50.1070906@wasp.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 9:14 AM, Brad Campbell <brad@wasp.net.au> wrote:
> I got a number of BUG()s in my kernel log during a RAID expansion. I did not
> notice any ill effects, the system recovered well and has been ok since.
> I've not had the opportunity to reboot as yet, but I thought them worth
> reporting.
>
> I'm really unsure as to the relevant details on this one, so I've attached
> everything just in case.
>
> I'm also seeing *loads* of [158921.049256] eth0: too many iterations (6) in
> nv_nic_irq.

This might be related. You may try to change the max_interrupt_work
module parameter to something greater, e.g.
forcedeth.max_interrupt_work=50 on the kernel command line or
"modprobe forcedeth max_interrupt_work=50" in the terminal.

> That's a bonus, as with 2.6.26 it was just locking up and requiring an
> down/up cycle to bring the port back. So improvements there anyway.
>
> [26328.103651] BUG: unable to handle kernel paging request at
> 000000001f4cd9db

First of all, strange address. This wasn't caused by a NULL pointer,
it was caused by a rogue chopping-off of the upper 32 bits. Let's look
at the code dump below...

> [26328.104869] IP: [<ffffffff80298d6c>] generic_fillattr+0xc/0xa0
> [26328.106049] PGD d7886067 PUD 9559067 PMD 0
> [26328.107239] Oops: 0002 [#1] SMP
> [26328.108396] last sysfs file: /sys/devices/platform/it87.656/temp1_input
> [26328.109581] CPU 0
> [26328.110712] Modules linked in: xt_iprange xt_length xt_CLASSIFY sch_sfq
> sch_htb iptable_mangle xt_TCPMSS ipt_REJECT xt_state ipt_MASQUERADE
> ipt_REDIRECT xt_tcpudp ip
> table_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> nf_defrag_ipv4 ip_tables x_tables adt7475 it87 hwmon_vid k8temp powernow_k8
> cdc_acm i2c_nforce2 usbhid r8
> 169 mii sata_sil24 forcedeth ehci_hcd sata_nv ohci_hcd usbcore sata_mv
> [26328.113358] Pid: 4766, comm: ping Tainted: G        W  2.6.28-rc8-git2
> #14
> [26328.113358] RIP: 0010:[<ffffffff80298d6c>]  [<ffffffff80298d6c>]
> generic_fillattr+0xc/0xa0
> [26328.113358] RSP: 0018:ffff8800c90ddec0  EFLAGS: 00010246
> [26328.113358] RAX: 000000001f4cda50 RBX: ffff8800bc2fb0c0 RCX:
> ffff88011f901800
> [26328.113358] RDX: ffff8800c90ddef8 RSI: ffff8800c90ddef8 RDI:
> ffff88011f4cda50
> [26328.123346] RBP: 00000000fffffff7 R08: fefefefefefefeff R09:
> 2f2f2f2f2f2f2f2f
> [26328.123346] R10: 0000000000000000 R11: 0000000000000246 R12:
> ffff8800c90ddef8
> [26328.123346] R13: 0000000000000001 R14: 0000000000000000 R15:
> 00000000ffffffff
> [26328.123346] FS:  00007f28c97656d0(0000) GS:ffffffff806c6480(0000)
> knlGS:0000000000000000
> [26328.123346] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [26328.123346] CR2: 000000001f4cd9db CR3: 000000007ec02000 CR4:
> 00000000000006e0
> [26328.123346] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [26328.123346] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [26328.123346] Process ping (pid: 4766, threadinfo ffff8800c90dc000, task
> ffff8800d7b4c8e0)
> [26328.123346] Stack:
> [26328.123346]  ffffffff80298e30 00007f557e615340 ffffffff80299467
> 00007fff8671d950
> [26328.123346]  0000000000000003 00007f557e7208e8 ffffffff802994af
> 0000000000000000
> [26328.123346]  0000000000000000 0000000000000000 0000002000000000
> fffffffffffffff2
> [26328.123346] Call Trace:
> [26328.123346]  [<ffffffff80298e30>] ? vfs_getattr+0x30/0x40
> [26328.123346]  [<ffffffff80299467>] ? vfs_fstat+0x37/0x60
> [26328.123346]  [<ffffffff802994af>] ? sys_newfstat+0x1f/0x50
> [26328.123346]  [<ffffffff80293ba6>] ? do_sys_open+0xc6/0x100
> [26328.123346]  [<ffffffff8020b64b>] ? system_call_fastpath+0x16/0x1b
> [26328.123346] Code: 00 f0 ff ff 77 0d 8b 42 08 c1 e0 14 0b 42 0c 89 03 31
> c0 5b c3 90 90 90 90 90 90 90 90 90 90 48 8b 87 f8 00 00 00 8b 40 10 89 46
> <08> 48 8b 47 40 48 89 06 0f b7 87 b2 00 00 00 66 89 46 0c 8b 47

This decodes to:

  1f:   48 8b 87 f8 00 00 00    mov    0xf8(%rdi),%rax
  26:   8b 40 10                mov    0x10(%rax),%eax
  29:   89                      .byte 0x89
  2a:   46                      rexXY

   0:   08 48 8b                or     %cl,0xffffffffffffff8b(%rax) <--- here
   3:   47 40 48 89 06          rexXYZ rex mov %rax,(%rsi)
   8:   0f b7 87 b2 00 00 00    movzwl 0xb2(%rdi),%eax
   f:   66 89 46 0c             mov    %ax,0xc(%rsi)

...but I'm having a hard time believing that this is even the correct
instruction sequence. This is what I get with a local compilation:

0000000000000000 <generic_fillattr>:
   0:   48 8b 87 f8 00 00 00    mov    0xf8(%rdi),%rax
   7:   8b 40 10                mov    0x10(%rax),%eax
   a:   89 46 08                mov    %eax,0x8(%rsi)
   d:   48 8b 47 40             mov    0x40(%rdi),%rax
  11:   48 89 06                mov    %rax,(%rsi)
  14:   0f b7 87 b2 00 00 00    movzwl 0xb2(%rdi),%eax

Doesn't fit at all. OTOH, if we move the <> (the faulting EIP) _one_
instruction ahead, i.e.:

Code: 00 f0 ff ff 77 0d 8b 42 08 c1 e0 14 0b 42 0c 89 03 31 c0 5b c3
90 90 90 90 90 90 90 90 90 90 48 8b 87 f8 00 00 00 8b 40 10 89 46 08
<48> 8b 47 40 48 89 06 0f b7 87 b2 00 00 00 66 89 46 0c 8b 47

...then we get this disassembly:

   0:   48 8b 47 40             mov    0x40(%rdi),%rax
   4:   48 89 06                mov    %rax,(%rsi)
   7:   0f b7 87 b2 00 00 00    movzwl 0xb2(%rdi),%eax
   e:   66 89 46 0c             mov    %ax,0xc(%rsi)

and that DOES fit! So we have two explanations for this oddity:

1. The CPU reported the wrong faulting instruction (seems highly
unlikely, since that means it wouldn't be able to resume properly in
other situations),
2. We really were executing at a slightly strange (offset) EIP

I'm going for #2. But how could it happen? Did the caller supply a
wrong address in its CALL? It seems unlikely. Why would it happen only
for this function, four times in a row, at the exact same location?
Was the caller's code corrupted?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
