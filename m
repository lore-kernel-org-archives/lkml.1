Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYJESEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYJESEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYJESEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:04:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:39069 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbYJESEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xuKM3dRaT/wHbjBbRqQM76V1UUK60ng69SKjhHMc4sCOA32kPt2ewh1iNY1t24AyXO
         AkjO5XKIytaZf5ytXLDzL75j0X76j1BCo15A0kolJMl/oddlK2BoqpvUPTGw3efX04O3
         c3Za96GNN6jp/m6k4FjGvqQ1v+/BU5t+6QUaM=
Message-ID: <86802c440810051104o44f7a3bbu6b37d7727be46772@mail.gmail.com>
Date: Sun, 5 Oct 2008 11:04:35 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for efi_ioremap
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Huang Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
	 <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
	 <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com>
	 <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
X-Google-Sender-Auth: 88ce7d65c0ca06ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2008 at 1:56 AM, huang ying <huang.ying.caritas@gmail.com> wrote:
> On Sun, Oct 5, 2008 at 1:44 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sat, Oct 4, 2008 at 2:35 AM, huang ying <huang.ying.caritas@gmail.com> wrote:
> [...]
>>> Using __va and efi_ioremap() here is to make EFI support compatible
>>> with kexec. Because EFI provide only efi_enter_virtual_mode(), no
>>> efi_leave_virtual_mode(), we should make EFI runtime memory area
>>> mapped to same virtual memory area in original kernel and kexeced
>>> kernel, so that the EFI runtime services can be used in kexeced
>>> kernel.
>>
>> so need to make efi range all under direct-mapping like E820-RAM?
>
> Some EFI runtime range is just some RAM area used by EFI runtime
> services, they can be direct-mapped. Some EFI runtime range may be IO
> MEM range used by EFI runtime services, it is possible that these IO
> MEM range can not be direct-mapped. So I implement efi_ioremap() to
> deal with them.
>

i'm confused.

so
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -475,10 +475,7 @@ void __init efi_enter_virtual_mode(void)
               size = md->num_pages << EFI_PAGE_SHIFT;
               end = md->phys_addr + size;

-               if (PFN_UP(end) <= max_low_pfn_mapped)
-                       va = __va(md->phys_addr);
-               else
-                       va = efi_ioremap(md->phys_addr, size);
+               va = efi_ioremap(md->phys_addr, size);

               md->virt_addr = (u64) (unsigned long) va;
should be ok.

then how about use ioremap directly to replace fixed mapping in 64bit
with efi_ioremap?

YH
