Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbXGZKGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbXGZKGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXGZKGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:06:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbXGZKG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:06:29 -0400
Date: Thu, 26 Jul 2007 03:06:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] ELF core dump options
Message-Id: <20070726030605.a0163ec2.akpm@linux-foundation.org>
In-Reply-To: <20070726093743.4208A4D058D@magilla.localdomain>
References: <20070726093743.4208A4D058D@magilla.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 02:37:43 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> 
> This adds two sysctl items under fs.binfmt_elf for controlling how memory
> segments are dumped in ELF core files.  The core_dump_whole_segments option
> can be set to have private file mappings dumped in their entirety.  Some
> people prefer the certainty to the saving disk space and i/o at dump time,
> and a global default is easier to set than every individual mm's MMF_DUMP_*.

It's a bit disappointing to route around the newly-added
/proc/pid/coredump_filter.  It's inherited across fork so where's the
problem?  Just set init's mask appropriately at boot if that's what you
want.

Plus making it system-wide is fairly sucky compared to making it settable
per-process-tree.

And you had to add considerably more code this way.

> The more interesting new feature is the core_dump_elf_headers option.
> This dumps the first page (only) of a read-only private file mapping if it
> appears to be a mapping of an ELF file.  Including these pages in the core
> dump may give sufficient identifying information to associate the original
> DSO and executable file images and their debugging information with a core
> file in a generic way just from its contents (e.g. when those binaries were
> built with ld --build-id).  I expect this to become the default behavior
> eventually.  Existing versions of gdb can be confused by the core dumps it
> creates, so it won't enabled by default for some time to come.  Soon many
> people will have systems with a gdb that handle these dumps, so they can
> use the sysctl option.
> 
> On biarch machines, there are two sets of options.
> The native dumper uses fs.binfmt_elf.core_dump_*.
> The compat dumper uses fs.binfmt_elf.32bit.core_dump_*.

Documentation/filesystems/proc.txt...

> -static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
> +static unsigned long vma_dump_size(struct vm_area_struct *vma,
> +				   unsigned long mm_flags)
>  {
>  	/* The vma can be set up to tell us the answer directly.  */
>  	if (vma->vm_flags & VM_ALWAYSDUMP)
> -		return 1;
> +		goto whole;
>  
>  	/* Do not dump I/O mapped devices or special mappings */
>  	if (vma->vm_flags & (VM_IO | VM_RESERVED))
> @@ -1211,17 +1213,51 @@ static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
>  
>  	/* By default, dump shared memory if mapped from an anonymous file. */
>  	if (vma->vm_flags & VM_SHARED) {
> -		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0)
> -			return test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
> -		else
> -			return test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
> +		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0 ?

hm, I'm now wondering whether testing i_nlink was the best (or official)
way of determining whether a MAP_SHARED vma is anonymous or file-backed.
Hugh will know.

> +		    test_bit(MMF_DUMP_ANON_SHARED, &mm_flags) :
> +		    test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags))

It was peculiar of us to use bitops against a local variable - normally
we'd use open-coded &'s here.  Maybe it's OK - test_bit() is pretty cheap
(on x86, at least), but one wonders whether gcc could do better if it knew
what was going on.

> ...
>  
> +
> +static ctl_table elf_core_dump_sysctls[] = {
> +	{
> +		.ctl_name = CTL_UNNUMBERED,
> +		.procname = "core_dump_whole_segments",
> +		.data = &dump_whole_segments,
> +		.maxlen = sizeof(int),
> +		.mode = 0644,
> +		.proc_handler = &proc_dointvec,
> +	},
> +	{
> +		.ctl_name = CTL_UNNUMBERED,
> +		.procname = "core_dump_elf_headers",
> +		.data = &dump_elf_headers,
> +		.maxlen = sizeof(int),
> +		.mode = 0644,
> +		.proc_handler = &proc_dointvec,
> +	},
> +	{ .ctl_name = 0 }
> +};
> +
> +#if BITS_PER_LONG > 32 && ELF_CLASS == ELFCLASS32
> +static ctl_table binfmt_elf_sysctl_32bit_dir[] = {
> +	{
> +		.ctl_name = CTL_UNNUMBERED,
> +		.procname = "32bit",
> +		.mode = 0555,
> +		.child = elf_core_dump_sysctls,
> +	},
> +	{ .ctl_name = 0 }
> +};
> +#define elf_core_dump_sysctls binfmt_elf_sysctl_32bit_dir
> +#endif

The above makes elf_core_dump_sysctls[] inaccessible from here on.  It will
warn, surely?


