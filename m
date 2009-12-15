Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZLOI1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZLOI1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZLOI1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:27:07 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:54960 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZLOI1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u5ia4B5RU1eYOqUngeF0/G8ygqe6pZBpspu/H1WcsAUL9gGDPWpLJ5AvHdUWbyWw+3
         9cwfa72fqNWQOYXhLmgaBmSDZ4xEpXfgtuSOE9Xxj8gRkiPuiUiQdco8nNhyqMujgE3T
         5s+snnxxHBEm0b0dIzsDDFya9CyMIChmioh50=
MIME-Version: 1.0
In-Reply-To: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
References: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 16:27:00 +0800
Message-ID: <2375c9f90912150027h2435fad9yc35bc360f743d7a6@mail.gmail.com>
Subject: Re: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering support
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
> The current ELF dumper implementation can produce broken corefiles
> if program headers exceed 65535. This number is determined by the
> number of vmas which the process have. In particular, some extreme
> programs may use more than 65535 vmas. (If you google max_map_count,
> you can find some users facing this problem.) This kind of program
> never be able to generate correct coredumps.
>
> This patch implements ``extended numbering'' that uses sh_info
> field of the first section header instead of e_phnum field in order
> to represent upto 4294967295 vmas.
>
> This is supported by AMD64-ABI(http://www.x86-64.org/documentation.html)
> and Solaris(http://docs.sun.com/app/docs/doc/817-1984/). Of course,
> we are preparing patches for gdb and binutils.
>
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>


Some comments below.

> ---
>  arch/ia64/kernel/elfcore.c |   16 ++++++++
>  arch/um/sys-i386/elfcore.c |   18 +++++++++
>  fs/binfmt_elf.c            |   88 +++++++++++++++++++++++++++++++++++++++-----
>  include/linux/elf.h        |   26 ++++++++++++-
>  4 files changed, 137 insertions(+), 11 deletions(-)
>
> diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
> index 9c0dd8b..a15d8d4 100644
> --- a/arch/ia64/kernel/elfcore.c
> +++ b/arch/ia64/kernel/elfcore.c
> @@ -73,3 +73,19 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
>        }
>        return 1;
>  }
> +
> +size_t elf_core_extra_data_size(void)
> +{
> +       const struct elf_phdr *const gate_phdrs =
> +               (const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
> +       int i;
> +       size_t size = 0;
> +
> +       for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
> +               if (gate_phdrs[i].p_type == PT_LOAD) {
> +                       size += PAGE_ALIGN(gate_phdrs[i].p_memsz);
> +                       break;
> +               }
> +       }
> +       return size;
> +}
> diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
> index 4e320f0..4e34e47 100644
> --- a/arch/um/sys-i386/elfcore.c
> +++ b/arch/um/sys-i386/elfcore.c
> @@ -76,3 +76,21 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
>        }
>        return 1;
>  }
> +
> +size_t elf_core_extra_data_size(void)
> +{
> +       if ( vsyscall_ehdr ) {
> +               const struct elfhdr *const ehdrp =
> +                       (struct elfhdr *)vsyscall_ehdr;
> +               const struct elf_phdr *const phdrp =
> +                       (const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
> +               int i;
> +
> +               for (i = 0; i < ehdrp->e_phnum; ++i) {
> +                       if (phdrp[i].p_type == PT_LOAD) {
> +                               return (size_t) phdrp[i].p_filesz;
> +                       }
> +               }

Unnecessary braces.

> +       }
> +       return 0;
> +}
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index cded1ba..ad2ad5f 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1895,6 +1895,38 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
>        return gate_vma;
>  }
>
> +static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
> +                            elf_addr_t e_shoff, int segs)
> +{
> +       elf->e_shoff = e_shoff;
> +       elf->e_shentsize = sizeof(*shdr4extnum);
> +       elf->e_shnum = 1;
> +       elf->e_shstrndx = SHN_UNDEF;
> +
> +       shdr4extnum->sh_name = 0;
> +       shdr4extnum->sh_addr = 0;
> +       shdr4extnum->sh_offset = 0;
> +       shdr4extnum->sh_type = SHT_NULL;
> +       shdr4extnum->sh_flags = 0;
> +       shdr4extnum->sh_size = elf->e_shnum;
> +       shdr4extnum->sh_link = elf->e_shstrndx;
> +       shdr4extnum->sh_info = segs;
> +       shdr4extnum->sh_addralign = 0;
> +       shdr4extnum->sh_entsize = 0;


Why not kzalloc() the struct and just fill the non-zero values?

<snip>

> @@ -2079,11 +2139,19 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>        if (!elf_core_write_extra_data(file, &size, limit))
>                goto end_coredump;
>
> +       if (e_phnum == PN_XNUM) {
> +               size += sizeof(*shdr4extnum);
> +               if (size > limit
> +                   || !dump_write(file, shdr4extnum, sizeof(*shdr4extnum)))
> +                       goto end_coredump;
> +       }
> +
>  end_coredump:

Even without the last 'goto', it will also come here finally.
So, that is unnecessary.
