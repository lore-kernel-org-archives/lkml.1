Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbXLGMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbXLGMOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXLGMOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:14:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34936 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXLGMON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:14:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 4/4 -mm] kexec based hibernation -v7 : kimgcore
Date: Fri, 7 Dec 2007 13:33:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1197042824.24045.64.camel@caritas-dev.intel.com>
In-Reply-To: <1197042824.24045.64.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071333.06836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 7 of December 2007, Huang, Ying wrote:
> This patch adds a file in proc file system to access the loaded
> kexec_image, which may contains the memory image of kexeced
> system. This can be used by kexec based hibernation to create a file
> image of hibernating kernel, so that a kernel booting process is not
> needed for each hibernating.

Hm, I'm not sure what you mean.

Can you explain a bit, please?


> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  fs/proc/Makefile      |    1 
>  fs/proc/kimgcore.c    |  204 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/proc_misc.c   |    5 +
>  include/linux/kexec.h |    7 +
>  kernel/kexec.c        |    5 -
>  5 files changed, 217 insertions(+), 5 deletions(-)
> 
> --- /dev/null
> +++ b/fs/proc/kimgcore.c
> @@ -0,0 +1,204 @@
> +/*
> + * fs/proc/kimgcore.c - Interface for accessing the loaded
> + * kexec_image, which may contains the memory image of kexeced system.
> + * Heavily borrowed from fs/proc/kcore.c
> + *
> + * Copyright (C) 2007, Intel Corp.
> + *      Huang Ying <ying.huang@intel.com>
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/proc_fs.h>
> +#include <linux/user.h>
> +#include <linux/elf.h>
> +#include <linux/init.h>
> +#include <linux/kexec.h>
> +#include <linux/io.h>
> +#include <linux/highmem.h>
> +#include <asm/uaccess.h>
> +
> +struct proc_dir_entry *proc_root_kimgcore;
> +
> +static u32 kimgcore_size;
> +
> +static char *elfcorebuf;
> +static size_t elfcorebuf_sz;
> +
> +static void *buf_page;
> +
> +static ssize_t kimage_copy_to_user(struct kimage *image, char __user *buf,
> +				  unsigned long offset, size_t count)
> +{
> +	kimage_entry_t *ptr, entry;
> +	unsigned long off = 0, offinp, trunk;
> +	struct page *page;
> +	void *vaddr;
> +
> +	for_each_kimage_entry(image, ptr, entry) {
> +		if (!(entry & IND_SOURCE))
> +			continue;
> +		if (off + PAGE_SIZE > offset) {
> +			offinp = offset - off;
> +			if (count > PAGE_SIZE - offinp)
> +				trunk = PAGE_SIZE - offinp;
> +			else
> +				trunk = count;
> +			page = pfn_to_page(entry >> PAGE_SHIFT);
> +			if (PageHighMem(page)) {
> +				vaddr = kmap(page);
> +				memcpy(buf_page, vaddr+offinp, trunk);
> +				kunmap(page);
> +				vaddr = buf_page;
> +			} else
> +				vaddr = __va(entry & PAGE_MASK) + offinp;
> +			if (copy_to_user(buf, vaddr, trunk))
> +				return -EFAULT;
> +			buf += trunk;
> +			offset += trunk;
> +			count -= trunk;
> +			if (!count)
> +				break;
> +		}
> +		off += PAGE_SIZE;
> +	}
> +	return count;
> +}
> +
> +static ssize_t read_kimgcore(struct file *file, char __user *buffer,
> +			     size_t buflen, loff_t *fpos)
> +{
> +	size_t acc = 0;
> +	size_t tsz;
> +	ssize_t ssz;
> +
> +	if (buflen == 0 || *fpos >= kimgcore_size)
> +		return 0;
> +
> +	/* trim buflen to not go beyond EOF */
> +	if (buflen > kimgcore_size - *fpos)
> +		buflen = kimgcore_size - *fpos;
> +	/* Read ELF core header */
> +	if (*fpos < elfcorebuf_sz) {
> +		tsz = elfcorebuf_sz - *fpos;
> +		if (buflen < tsz)
> +			tsz = buflen;
> +		if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
> +			return -EFAULT;
> +		buflen -= tsz;
> +		*fpos += tsz;
> +		buffer += tsz;
> +		acc += tsz;
> +
> +		/* leave now if filled buffer already */
> +		if (buflen == 0)
> +			return acc;
> +	}
> +
> +	ssz = kimage_copy_to_user(kexec_image, buffer,
> +				  *fpos - elfcorebuf_sz, buflen);
> +	if (ssz < 0)
> +		return ssz;
> +
> +	*fpos += (buflen - ssz);
> +	acc += (buflen - ssz);
> +
> +	return acc;
> +}
> +
> +static int init_kimgcore(void)
> +{
> +	Elf64_Ehdr *ehdr;
> +	Elf64_Phdr *phdr;
> +	struct kexec_segment *seg;
> +	Elf64_Off off;
> +	unsigned long i;
> +
> +	elfcorebuf_sz = sizeof(Elf64_Ehdr) +
> +		kexec_image->nr_segments * sizeof(Elf64_Phdr);
> +	elfcorebuf = kzalloc(elfcorebuf_sz, GFP_KERNEL);
> +	if (!elfcorebuf)
> +		return -ENOMEM;
> +	ehdr = (Elf64_Ehdr *)elfcorebuf;
> +	memcpy(ehdr->e_ident, ELFMAG, SELFMAG);
> +	ehdr->e_ident[EI_CLASS] = ELFCLASS64;
> +	ehdr->e_ident[EI_DATA]	= ELFDATA2LSB;
> +	ehdr->e_ident[EI_VERSION] = EV_CURRENT;
> +	ehdr->e_ident[EI_OSABI] = ELFOSABI_NONE;
> +	memset(ehdr->e_ident+EI_PAD, 0, EI_NIDENT-EI_PAD);
> +	ehdr->e_type = ET_CORE;
> +	ehdr->e_machine = ELF_ARCH;
> +	ehdr->e_version = EV_CURRENT;
> +	ehdr->e_entry = kexec_image->start;
> +	ehdr->e_phoff = sizeof(Elf64_Ehdr);
> +	ehdr->e_shoff = 0;
> +	ehdr->e_flags = 0;
> +	ehdr->e_ehsize = sizeof(Elf64_Ehdr);
> +	ehdr->e_phentsize = sizeof(Elf64_Phdr);
> +	ehdr->e_phnum = kexec_image->nr_segments;
> +	ehdr->e_shentsize = 0;
> +	ehdr->e_shnum = 0;
> +	ehdr->e_shstrndx = 0;
> +
> +	off = elfcorebuf_sz;
> +	phdr = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
> +	seg = kexec_image->segment;
> +	for (i = 0; i < kexec_image->nr_segments; i++, phdr++, seg++) {
> +		phdr->p_type = PT_LOAD;
> +		phdr->p_flags = PF_R|PF_W|PF_X;
> +		phdr->p_offset = off;
> +		phdr->p_paddr = seg->mem;
> +		phdr->p_filesz = seg->memsz;
> +		phdr->p_memsz = seg->memsz;
> +		phdr->p_align = PAGE_SIZE;
> +		off += seg->memsz;
> +	}
> +	kimgcore_size = off;
> +
> +	buf_page = (void *)__get_free_page(GFP_KERNEL);
> +	if (!buf_page) {
> +		kfree(elfcorebuf);
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static void destroy_kimgcore(void)
> +{
> +	kfree(elfcorebuf);
> +	free_page((unsigned long)buf_page);
> +	elfcorebuf_sz = 0;
> +	kimgcore_size = 0;
> +}
> +
> +static int open_kimgcore(struct inode *inode, struct file *filp)
> +{
> +	int ret;
> +	if (xchg(&kexec_lock, 1))
> +		return -EBUSY;
> +	if (!kexec_image) {
> +		ret = -ENOENT;
> +		goto unlock;
> +	}
> +	ret = init_kimgcore();
> +	if (ret)
> +		goto unlock;
> +	return 0;
> +unlock:
> +	xchg(&kexec_lock, 0);
> +	return ret;
> +}
> +
> +static int release_kimgcore(struct inode *inode, struct file *filp)
> +{
> +	destroy_kimgcore();
> +	xchg(&kexec_lock, 0);
> +	return 0;
> +}
> +
> +const struct file_operations proc_kimgcore_operations = {
> +	.read = read_kimgcore,
> +	.open = open_kimgcore,
> +	.release = release_kimgcore,
> +};
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -10,6 +10,7 @@
>  #include <linux/elfcore.h>
>  #include <linux/elf.h>
>  #include <linux/notifier.h>
> +#include <linux/proc_fs.h>
>  #include <asm/kexec.h>
>  
>  /* Verify architecture specific macros are defined */
> @@ -108,6 +109,10 @@ struct kimage {
>  };
>  
>  
> +#define for_each_kimage_entry(image, ptr, entry) \
> +	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
> +		ptr = (entry & IND_INDIRECTION)? \
> +			phys_to_virt((entry & PAGE_MASK)): ptr + 1)
>  
>  /* kexec interface functions */
>  extern void machine_kexec(struct kimage *image);
> @@ -228,6 +233,8 @@ extern size_t vmcoreinfo_max_size;
>  int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
>  		unsigned long long *crash_size, unsigned long long *crash_base);
>  
> +extern const struct file_operations proc_kimgcore_operations;
> +extern struct proc_dir_entry *proc_root_kimgcore;
>  #else /* !CONFIG_KEXEC */
>  struct pt_regs;
>  struct task_struct;
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -14,5 +14,6 @@ proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysct
>  proc-$(CONFIG_NET)		+= proc_net.o
>  proc-$(CONFIG_PROC_KCORE)	+= kcore.o
>  proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
> +proc-$(CONFIG_KEXEC)		+= kimgcore.o
>  proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
>  proc-$(CONFIG_PRINTK)	+= kmsg.o
> --- a/fs/proc/proc_misc.c
> +++ b/fs/proc/proc_misc.c
> @@ -1034,6 +1034,11 @@ void __init proc_misc_init(void)
>  	if (proc_vmcore)
>  		proc_vmcore->proc_fops = &proc_vmcore_operations;
>  #endif
> +#ifdef CONFIG_KEXEC
> +	proc_root_kimgcore = create_proc_entry("kimgcore", S_IRUSR, NULL);
> +	if (proc_root_kimgcore)
> +		proc_root_kimgcore->proc_fops = &proc_kimgcore_operations;
> +#endif
>  #ifdef CONFIG_MAGIC_SYSRQ
>  	{
>  		struct proc_dir_entry *entry;
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -614,11 +614,6 @@ static int kimage_terminate(struct kimag
>  	return 0;
>  }
>  
> -#define for_each_kimage_entry(image, ptr, entry) \
> -	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
> -		ptr = (entry & IND_INDIRECTION)? \
> -			phys_to_virt((entry & PAGE_MASK)): ptr +1)
> -
>  static void kimage_free_entry(kimage_entry_t entry)
>  {
>  	struct page *page;
