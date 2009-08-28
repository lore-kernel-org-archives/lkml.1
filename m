Return-Path: <linux-kernel-owner+w=401wt.eu-S1751493AbZH1JN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbZH1JN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZH1JN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:13:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:37358 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZH1JN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NlwGe7N9WwBCEJZE5ez7zJFuJKIU4qN3Q7iq0Rcvsjf4JFinhZ8oET8r19Y3Dh4q8i
         2J5fDdx4F1sewnn5LRLKqkmblTHTwW2RVZypDCqgPBCro8AY80tRR5FOxBIEGnnGuSPS
         rEOWoCaaWozMxKYkx6d7xYtD42oIrnd0j1Nms=
MIME-Version: 1.0
In-Reply-To: <20090826223126.GA20373@host0.dyn.jankratochvil.net>
References: <20090826223126.GA20373@host0.dyn.jankratochvil.net>
Date: Fri, 28 Aug 2009 17:13:29 +0800
Message-ID: <2375c9f90908280213i520e75a2wed97781ab2cd37ca@mail.gmail.com>
Subject: Re: [patch] Fix vdso32 relocation for paddr
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 6:31 AM, Jan
Kratochvil<jan.kratochvil@redhat.com> wrote:
> Hi,
>
> `readelf -Wl file-dumped-from-/proc/self/maps-[vdso]' for x86_64 process prints:
> Program Headers:
>  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
>  LOAD           0x000000 0xffffffffff700000 0xffffffffff700000 0x000890 0x000890 R E 0x1000
>  DYNAMIC        0x000410 0xffffffffff700410 0xffffffffff700410 0x0000f0 0x0000f0 R   0x8
>  NOTE           0x0002d0 0xffffffffff7002d0 0xffffffffff7002d0 0x00003c 0x00003c R   0x4
>  GNU_EH_FRAME   0x00030c 0xffffffffff70030c 0xffffffffff70030c 0x000034 0x000034 R   0x4
>
> while such dump for i386 process prints:
> Program Headers:
>  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>  LOAD           0x000000 0xffffe000 0x00000000 0x00434 0x00434 R E 0x1000
>  DYNAMIC        0x000350 0xffffe350 0x00000350 0x00078 0x00078 R   0x4
>  NOTE           0x0001c4 0xffffe1c4 0x000001c4 0x00060 0x00060 R   0x4
>  GNU_EH_FRAME   0x000224 0xffffe224 0x00000224 0x00024 0x00024 R   0x4
>
> The mapped location can be arbirary (according to the rules of PIC - Position
> Independent Code) but currently the i386 vdso (vdso32) looks as an overlayed
> code as it has LMA != VMA (rule contained in GDB function section_is_overlay,
> as suggested by Daniel Jacobowitz).
>
> Fixed vdso32 prints:
> Program Headers:
>  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>  LOAD           0x000000 0xffffe000 0xffffe000 0x00434 0x00434 R E 0x1000
>  DYNAMIC        0x000350 0xffffe350 0xffffe350 0x00078 0x00078 R   0x4
>  NOTE           0x0001c4 0xffffe1c4 0xffffe1c4 0x00060 0x00060 R   0x4
>  GNU_EH_FRAME   0x000224 0xffffe224 0xffffe224 0x00024 0x00024 R   0x4
>
> It required now a workaround in GDB patch so at least to fix it in Linux kernel:
>        http://sourceware.org/ml/gdb-patches/2009-08/msg00437.html
>
>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

This patch looks fine for me. But I think we should hear from Roland.
Roland?


> Thanks,
> Jan
>
>
> Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
>
> --- linux-2.6.30.x86_64/arch/x86/vdso/vdso32-setup.c-orig       2009-08-26 22:23:08.000000000 +0200
> +++ linux-2.6.30.x86_64/arch/x86/vdso/vdso32-setup.c    2009-08-26 22:38:10.000000000 +0200
> @@ -172,6 +172,7 @@ static __init void relocate_vdso(Elf32_E
>        phdr = (void *)ehdr + ehdr->e_phoff;
>        for (i = 0; i < ehdr->e_phnum; i++) {
>                phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
> +               phdr[i].p_paddr += VDSO_ADDR_ADJUST;
>
>                /* relocate dynamic stuff */
>                if (phdr[i].p_type == PT_DYNAMIC)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
