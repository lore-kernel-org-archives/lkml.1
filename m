Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZKYSjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZKYSjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbZKYSjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:39:32 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49419 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZKYSja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:39:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gBF74VNILAcKSErMp/lcxa8tyJa2kfxkqLN3wId3U0hcb1oqYaUkW+lm/LEfFXINuh
         QInxINuCXq38E9hvGpJ0OCPsVVj39hwUFLmiNEm3APSf1M/8rol+dID7vPhkxg9dj2xt
         K705FYS1H6B4B0P947nl0Bs3RIGBHonxNBUgY=
MIME-Version: 1.0
In-Reply-To: <20091125114908.GA21778@shareable.org>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> 
	<20091125061640.GB17203@shareable.org> <4B0CCE4A.5000602@analog.com> 
	<20091125114908.GA21778@shareable.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 25 Nov 2009 13:39:17 -0500
Message-ID: <8bd0f97a0911251039v6d568229md62a93cd5abb716f@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH] NOMMU: use copy_*_user_page() in 
	access_process_vm()
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Jie Zhang <jie.zhang@analog.com>, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 06:49, Jamie Lokier wrote:
> Jie Zhang wrote:
>> On 11/25/2009 02:16 PM, Jamie Lokier wrote:
>> >Mike Frysinger wrote:
>> >>From: Jie Zhang<jie.zhang@analog.com>
>> >>
>> >>The mmu code uses the copy_*_user_page() variants in access_process_vm()
>> >>rather than copy_*_user() as the former includes an icache flush.  This is
>> >>important when doing things like setting software breakpoints with gdb.
>> >>So switch the nommu code over to do the same.
>> >
>> >Reasonable, but it's a bit subtle don't you think?
>> >How about a one-line comment saying why it's using copy_*_user_page()?
>> >
>> >(If it was called copy_*_user_flush_icache() I wouldn't say anything,
>> >but it isn't).
>> >
>> But I think it's well known in Linux kernel developers that
>> copy_to_user_page and copy_from_user_page should do cache flushing. It's
>> documented in Documentation/cachetlb.txt. I don't think it's necessary
>> to replicate it here.
>
> You're right, however I now think the commit message is misleading.
>
> Since this is the *only place in the entire kernel* where these
> functions are used (plus the mmu equivalent), I'm not sure I'd agree
> about well known, and the name could be better (copy_*_user_ptrace()),
> but I agree now, it doesn't need a comment.
>
> It was the talk of icache flush which bothered me, as I (wrongly)
> assumed copy_*_user_page() was used elsewhere, without knowledge of
> icache vs non-icache differences - which are often the responsibility
> of userspace to get right, so often the kernel does not care.
>
> In fact, it's not just icache.  copy_*_user_page() has to do some
> *data* cache flushing too, on some architecures.  For example, see
> arch/sparc/include/asm/cacheflush_64.h:
>
>    #define copy_to_user_page(vma, page, vaddr, dst, src, len)              \
>            do {                                                            \
>                    flush_cache_page(vma, vaddr, page_to_pfn(page));        \
>                    memcpy(dst, src, len);                                  \
>                    flush_ptrace_access(vma, page, vaddr, src, len, 0);     \
>            } while (0)
>
>    #define copy_from_user_page(vma, page, vaddr, dst, src, len)            \
>            do {                                                            \
>                    flush_cache_page(vma, vaddr, page_to_pfn(page));        \
>                    memcpy(dst, src, len);                                  \
>                    flush_ptrace_access(vma, page, vaddr, dst, len, 1);     \
>            } while (0)
>
> I'm not sure why I don't see the same dcache flushing on ARM, so I
> wonder if the ARM implementation of these buggy.
>
> Anyway, that means the commit message is a little misleading, saying
> it's for the icache flush.  It is for whatever icache and dcache
> flushes are needed for a ptrace access.
>
> Which is why, given they are only used for ptrace (have just grepped),
> I'm inclined to think it'd be clearer to rename the functions to
> copy_*_user_ptrace().  And make your no-mmu change of course :-)
> Any thoughts on the rename?

these are all good points, but i think unrelated to the patch in
question ;).  they can be done as a follow up.
-mike
