Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbZFWLEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbZFWLEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756995AbZFWLEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:04:23 -0400
Received: from mail-yx0-f190.google.com ([209.85.210.190]:44132 "EHLO
	mail-yx0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbZFWLET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BttI8rbDkygYOTGIP3UKJx6Q65G2IdgqLPBzz2WgE0EtxqB2YWdddskEsOERNsQbkI
         H+ryGalZEH2blVIFmlx8uuX4+3pu9efS43l+57u2IusVICOB57fsH1a4M86F4uOkrXOS
         cG4XrKY66eJVFrLfpLJsXTRQ/4T6bHsi+LMRQ=
MIME-Version: 1.0
In-Reply-To: <20090622223201.34b79adb.akpm@linux-foundation.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 
	<1245140688-24871-1-git-send-email-vapier@gentoo.org> <20090622223201.34b79adb.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 07:04:02 -0400
Message-ID: <8bd0f97a0906230404n2cd3b6f6t96b4a60099677434@mail.gmail.com>
Subject: Re: [PATCH] FDPIC: add hook for arches to customize program header 
	parsing
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 01:32, Andrew Morton wrote:
> On Tue, 16 Jun 2009 04:24:48 -0400 Mike Frysinger wrote:
>> From: Jie Zhang <jie.zhang@analog.com>
>> The Blackfin port has custom program header flags/addresses for
>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>> hook for ports to leverage.
>>
>> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> CC: Bernd Schmidt <bernds_cb1@t-online.de>
>> Acked-by: David Howells <dhowells@redhat.com>
>> Acked-by: Paul Mundt <lethal@linux-sh.org>
>> Acked-by: Greg Ungerer <gerg@uclinux.org>
>> ---
>> Andrew: could you pick this up ?  same patch as before, just with the
>> additional tags added.
>
> I suppose we want to squeeze this into 2.6.31.

would be nice, but not terribly critical

>> --- a/fs/binfmt_elf_fdpic.c
>> +++ b/fs/binfmt_elf_fdpic.c
>> @@ -1105,6 +1105,13 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
>>                   ELF_FDPIC_FLAG_CONTIGUOUS)
>>                       load_addr += PAGE_ALIGN(phdr->p_memsz + disp);
>>
>> +#ifndef ELF_FDPIC_PLAT_PROCESS_PHDR
>> +# define ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, maddr, disp) 0
>> +#endif
>> +             ret = ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, &maddr, &disp);
>> +             if (ret)
>> +                     return ret;
>> +
>
> Wouldn't it be simpler to do
>
> #ifdef ELF_FDPIC_PLAT_PROCESS_PHDR
>                ret = ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, &maddr,
>                                                  &disp);
>                if (ret)
>                        return ret;
> #endif
>
> ?
>
> If there's any prospect that we'll use ELF_FDPIC_PLAT_PROCESS_PHDR() a
> second time from within this file then yes, adding a definition as
> you did is appropriate.  But it should be near the top of the file, not
> stuck stupidly in the middle of a C function.

the purpose was to stick to current conventions used in the file and
to maximize the amount of code compiled.  i dont particularly care wrt
the method used here.
-mike
