Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171Ab0ASMBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0ASMBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915Ab0ASMBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:01:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34122 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0ASMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:01:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wESKEEODtHgvyKrgf/Nu28wcLtLk0dixT5bcdC/sAJFVJ1q+qnbsdMxRYmgs6ERrrJ
         dagwCa4TxLTntA3g4d9THcXbJcxXt56571D2EYJysCRqRi567lE/E1uh1RIUu4aDmRL+
         EGnq2ksvFNy3UF8W0ZL9smq4ADHN8+IVNEMWM=
Subject: Re: [PATCH] vmalloc: remove BUG_ON due to racy counting of
 VM_LAZY_FREE
From: Minchan Kim <minchan.kim@gmail.com>
To: yongseok.koh@samsung.com
Cc: "'Nick Piggin'" <npiggin@suse.de>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>, gregkh@suse.de,
       vegard.nossum@gmail.com, "'Ingo Molnar'" <mingo@elte.hu>,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <001c01ca98e2$231d8b10$6958a130$@koh@samsung.com>
References: <006d01ca8f8b$b62c8ec0$2285ac40$%koh@samsung.com>
	 <20100111163205.4d013e86.akpm@linux-foundation.org>
	 <20100113045538.GA3901@nick> <1263388030.2818.6.camel@barrios-desktop>
	 <alpine.LFD.2.00.1001130829490.13231@localhost.localdomain>
	 <20100114123328.GA7518@laptop>
	 <28c262361001150902g569683a1nbd3e0212655a87a0@mail.gmail.com>
	 <20100118073759.GB10052@laptop>
	 <001c01ca98e2$231d8b10$6958a130$@koh@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 21:01:27 +0900
Message-ID: <1263902487.2163.4.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 17:33 +0900, Yongseok Koh wrote:
> From: Yongseok Koh <yongseok.koh@samsung.com>

You don't need above line.
We use "From" when we send patch instead of someone. 

> 
> In free_unmap_area_noflush(), va->flags is marked as VM_LAZY_FREE first, and
> then vmap_lazy_nr is increased atomically.
> But, in __purge_vmap_area_lazy(), while traversing of vmap_are_list, nr is
> counted by checking VM_LAZY_FREE is set to va->flags.
> After counting the variable nr, kernel reads vmap_lazy_nr atomically and
> checks a BUG_ON condition whether nr is greater than vmap_lazy_nr to prevent
> vmap_lazy_nr from being negative.
> 
> The problem is that, if interrupted right after marking VM_LAZY_FREE,
> increment of vmap_lazy_nr can be delayed.
> Consequently, BUG_ON condition can be met because nr is counted more than
> vmap_lazy_nr.
> 
> It is highly probable when vmalloc/vfree are called frequently.
> This scenario have been verified by adding delay between marking
> VM_LAZY_FREE and increasing vmap_lazy_nr in free_unmap_area_noflush().
> 
> Even the vmap_lazy_nr is for checking high watermark, it never be the strict
> watermark.
> Although the BUG_ON condition is to prevent vmap_lazy_nr from being
> negative, vmap_lazy_nr is signed variable.
> So, it could go down to negative value temporarily.
> 
> Consequently, removing the BUG_ON condition is proper.
> 
> A possible BUG_ON message is like the below.
> 
> kernel BUG at mm/vmalloc.c:517!
> invalid opcode: 0000 [#1] SMP
> EIP: 0060:[<c04824a4>] EFLAGS: 00010297 CPU: 3
> EIP is at __purge_vmap_area_lazy+0x144/0x150
> EAX: ee8a8818 EBX: c08e77d4 ECX: e7c7ae40 EDX: c08e77ec
> ESI: 000081fe EDI: e7c7ae60 EBP: e7c7ae64 ESP: e7c7ae3c
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Call Trace:
> [<c0482ad9>] free_unmap_vmap_area_noflush+0x69/0x70
> [<c0482b02>] remove_vm_area+0x22/0x70
> [<c0482c15>] __vunmap+0x45/0xe0
> [<c04831ec>] vmalloc+0x2c/0x30
> Code: 8d 59 e0 eb 04 66 90 89 cb 89 d0 e8 87 fe ff ff 8b 43 20 89 da 8d 48
> e0 8d 43 20 3b 04 24 75 e7 fe 05 a8 a5 a3 c0 e9 78 ff ff ff <0f> 0b eb fe 90
> 8d b4 26 00 00 00 00 56 89 c6 b8 ac a5 a3 c0 31
> EIP: [<c04824a4>] __purge_vmap_area_lazy+0x144/0x150 SS:ESP 0068:e7c7ae3c
> 
> 
> Signed-off-by: Yongseok Koh <yongseok.koh@samsung.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

We discussed about this following as. 
http://marc.info/?l=linux-kernel&m=126335856228090&w=2


Thanks for contribution for linux kernel, Yongseok. :) 


-- 
Kind regards,
Minchan Kim

