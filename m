Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbZLOI3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbZLOI3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbZLOI3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:29:17 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:50374 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbZLOI3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:29:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uoYr2vIDt9LlxTaKFzpFATSXvWWv4NOutQqeFjVoRdqhOb19X2Yg8uDVo4B028l59S
         Vg/1AQYFYLThIDza0rqOAULioxlaJs8loQKnYNzKXMncakZxnnvfMdOjqtdcvdne3u+M
         a2AagIhEuDCV2YVFTXD5rZrrRRTphDcCH2JpQ=
MIME-Version: 1.0
In-Reply-To: <20091215.114125.71090684.d.hatayama@jp.fujitsu.com>
References: <20091215.114125.71090684.d.hatayama@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 16:29:13 +0800
Message-ID: <2375c9f90912150029w6edafb17s6fb0bcf41798263a@mail.gmail.com>
Subject: Re: [RFC, PATCH 2/4] elf_core_dump(): Remove DUMP_WRITE macro
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:41 AM, Daisuke HATAYAMA
<d.hatayama@jp.fujitsu.com> wrote:
> In DUMP_WRITE macro, some local variables and goto statement are used
> implicitly, which makes it confusing to understand how the dumping
> process behaves. So, clean up it by unfolding the macro body directly
> to the point where the original macro is used plus a bit of style
> change.
>
> Now that the previous patch replaced ELF_CORE_EXTRA_* macros in
> fs/binfmt_elf.c, there is no users for DUMP_WRITE macro in
> fs/binfmt_elf.c. Thus remove the definition of DUMP_WRITE macro.
>
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>


I assume you at least did a build test?

I like this patch:

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  fs/binfmt_elf.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 5f7be51..9666a8a 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1277,10 +1277,6 @@ static int writenote(struct memelfnote *men, struct file *file,
>  }
>  #undef DUMP_WRITE
>
> -#define DUMP_WRITE(addr, nr)   \
> -       if ((size += (nr)) > limit || !dump_write(file, (addr), (nr))) \
> -               goto end_coredump;
> -
>  static void fill_elf_header(struct elfhdr *elf, int segs,
>                            u16 machine, u32 flags, u8 osabi)
>  {
> @@ -1981,7 +1977,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>        fs = get_fs();
>        set_fs(KERNEL_DS);
>
> -       DUMP_WRITE(elf, sizeof(*elf));
> +       size += sizeof(*elf);
> +       if (size > limit || !dump_write(file, elf, sizeof(*elf)))
> +               goto end_coredump;
> +
>        offset += sizeof(*elf);                         /* Elf header */
>        offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
>        foffset = offset;
> @@ -1995,7 +1994,9 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>
>                fill_elf_note_phdr(&phdr, sz, offset);
>                offset += sz;
> -               DUMP_WRITE(&phdr, sizeof(phdr));
> +               size += sizeof(phdr);
> +               if (size > limit || !dump_write(file, &phdr, sizeof(phdr)))
> +                       goto end_coredump;
>        }
>
>        dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
> @@ -2026,7 +2027,9 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>                        phdr.p_flags |= PF_X;
>                phdr.p_align = ELF_EXEC_PAGESIZE;
>
> -               DUMP_WRITE(&phdr, sizeof(phdr));
> +               size += sizeof(phdr);
> +               if (size > limit || !dump_write(file, &phdr, sizeof(phdr)))
> +                       goto end_coredump;
>        }
>
>        if (!elf_core_write_extra_phdrs(file, offset, &size, limit))
> --
> 1.6.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
