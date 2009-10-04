Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbZJDT2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbZJDT2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZJDT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:28:08 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:42576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbZJDT2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JMdeu0V0Fu2kLNMV4IDrvTWksldcmZfNWV71BmK9lSC0hQHq/WnsZQzv877EuGza48
         4b44bu7/9A1KKfBx+1q9N72WAkgHHCtBgg8RPKM0NI0pAqC1P4LSymp+vYJCRO1f1MSm
         nxmSyvw10NkMALdu83Rn4MdRHq16oRg1XZarU=
MIME-Version: 1.0
In-Reply-To: <20091004163224.GA10493@elte.hu>
References: <20091004163224.GA10493@elte.hu>
Date: Sun, 4 Oct 2009 21:27:30 +0200
Message-ID: <19f34abd0910041227k6855aemaf80c5a6a98a90f@mail.gmail.com>
Subject: Re: [kmemcheck] visual_init(): Caught 32-bit read from unallocated 
	memory (bf820028)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/4 Ingo Molnar <mingo@elte.hu>:
>
> hi,
>
> got this kmemcheck warning in -tip testing:
>
> [    0.000000] WARNING: kmemcheck: Caught 32-bit read from unallocated memory (bf820028)
> [    0.000000] 0000000000000000000000000000000000000000000000000000000000000000
> [    0.000000]  a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a
> [    0.000000]                  ^
> [    0.000000]
> [    0.000000] Pid: 0, comm: swapper Not tainted (2.6.32-rc2-tip-01349-g1ade8d6-dirty #218) P4DC6
> [    0.000000] EIP: 0060:[<812d78c0>] EFLAGS: 00010286 CPU: 0
> [    0.000000] EIP is at visual_init+0x10/0x130
> [    0.000000] EAX: bf820000 EBX: bf820000 ECX: 00000001 EDX: 00000000
> [    0.000000] ESI: 00000200 EDI: 00000000 EBP: 81abdf7c ESP: 81c1a94c
> [    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    0.000000] CR0: 8005003b CR2: bf820028 CR3: 01c10000 CR4: 000006d0
> [    0.000000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [    0.000000] DR6: ffff4ff0 DR7: 00000400
> [    0.000000]  [<81b99d82>] con_init+0xf2/0x2b0
> [    0.000000]  [<81b99239>] console_init+0x19/0x30
> [    0.000000]  [<81b7492d>] start_kernel+0x1cd/0x340
> [    0.000000]  [<81b74091>] i386_start_kernel+0x61/0x90
> [    0.000000]  [<ffffffff>] 0xffffffff
> [    0.000000]   ok  |  ok  |  ok  |
>
> seems new at first glance. Config attached.
>
>        Ingo
>

BTW, unallocated means "the page was allocated for use by SL*B, but
the object has not been handed out to anyone yet".

The memory access that triggers this warning is the first line of the function:

00003350 <visual_init>:
...
    3366:       8b 47 28                mov    0x28(%edi),%eax

$ addr2line -e drivers/char/vt.o -i 3366
drivers/char/vt.c:721

 718 static void visual_init(struct vc_data *vc, int num, int init)
 719 {
 720         /* ++Geert: vc->vc_sw->con_init determines console size */
 721         if (vc->vc_sw)

So apparently the "vc" we got is invalid. The caller:

2833 static int __init con_init(void)
2834 {
...
2870         for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
2871                 vc_cons[currcons].d = vc = kzalloc(sizeof(struct
vc_data), GFP_NOWAIT);
2872                 INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
2873                 visual_init(vc, currcons, 1);
...
2897 }
2898 console_initcall(con_init);

Not entirely sure about the rest of the story... It would seem that we
are missing an if (!vc), but that doesn't explain how the pointer got
to be 0xbf820000. What sort of address is that, anyway, isn't that a
userspace pointer? Ah, you have CONFIG_VMSPLIT_2G=y. Can we see the
kernel virtual memory map from the dmesg?

I can't really see how this is possible, which means that kmemcheck is
probably at fault.


Vegard
