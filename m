Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZITOe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZITOe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 10:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZITOe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 10:34:26 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:62420 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZITOeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 10:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <20090920122411.GA5413@n2100.arm.linux.org.uk>
References: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name>
	 <20090919110316.GA23452@n2100.arm.linux.org.uk>
	 <20090920081550.GA830@n2100.arm.linux.org.uk>
	 <cc557aab0909200235sbb4c1f5tdc84434732222988@mail.gmail.com>
	 <20090920122411.GA5413@n2100.arm.linux.org.uk>
Date: Sun, 20 Sep 2009 17:34:28 +0300
Message-ID: <cc557aab0909200734j719370d5q67a32f6c0c69b0e5@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 3:24 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Sep 20, 2009 at 12:35:19PM +0300, Kirill A. Shutemov wrote:
>> Ok, so __do_page_fault() should know where we are: in data abort or in
>> prefetch abort. What is right way to do it? Should we create one more
>> argument or use one of reserved bits IFSR?
>
> Well, this is my solution to the problem - could you test it please?

I'll test it on Monday.

Do you want to ignore IFSR? I don't think that it's a good idea. We will
get infinite loop of faults on an unexpected for kernel type of fault, like
we have now for permission faults. Better to call do_bad() in this case.

> This patch is actually the result of several patches merged together,
> so I won't supply a proper description etc.
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index cc8829d..8fbb22d 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -25,6 +25,19 @@
>
>  #include "fault.h"
>
> +/*
> + * Fault status register encodings.  We steal bit 31 for our own purposes.
> + */
> +#define FSR_LNX_PF             (1 << 31)
> +#define FSR_WRITE              (1 << 11)
> +#define FSR_FS4                        (1 << 10)
> +#define FSR_FS3_0              (15)
> +
> +static inline int fsr_fs(unsigned int fsr)
> +{
> +       return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
> +}
> +
>  #ifdef CONFIG_MMU
>
>  #ifdef CONFIG_KPROBES
> @@ -182,18 +195,35 @@ void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  #define VM_FAULT_BADMAP                0x010000
>  #define VM_FAULT_BADACCESS     0x020000
>
> -static int
> +/*
> + * Check that the permissions on the VMA allow for the fault which occurred.
> + * If we encountered a write fault, we must have write permission, otherwise
> + * we allow any permission.
> + */
> +static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
> +{
> +       unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
> +
> +       if (fsr & FSR_WRITE)
> +               mask = VM_WRITE;
> +       if (fsr & FSR_LNX_PF)
> +               mask = VM_EXEC;
> +
> +       return vma->vm_flags & mask ? false : true;
> +}
> +
> +static noinline int __kprobes
>  __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
>                struct task_struct *tsk)
>  {
>        struct vm_area_struct *vma;
> -       int fault, mask;
> +       int fault;
>
>        vma = find_vma(mm, addr);
>        fault = VM_FAULT_BADMAP;
> -       if (!vma)
> +       if (unlikely(!vma))
>                goto out;
> -       if (vma->vm_start > addr)
> +       if (unlikely(vma->vm_start > addr))
>                goto check_stack;
>
>        /*
> @@ -201,47 +231,24 @@ __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
>         * memory access, so we can handle it.
>         */
>  good_area:
> -       if (fsr & (1 << 11)) /* write? */
> -               mask = VM_WRITE;
> -       else
> -               mask = VM_READ|VM_EXEC|VM_WRITE;
> -
> -       fault = VM_FAULT_BADACCESS;
> -       if (!(vma->vm_flags & mask))
> +       if (access_error(fsr, vma)) {
> +               fault = VM_FAULT_BADACCESS;
>                goto out;
> +       }
>
>        /*
> -        * If for any reason at all we couldn't handle
> -        * the fault, make sure we exit gracefully rather
> -        * than endlessly redo the fault.
> +        * If for any reason at all we couldn't handle the fault, make
> +        * sure we exit gracefully rather than endlessly redo the fault.
>         */
> -survive:
> -       fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, (fsr & (1 << 11)) ? FAULT_FLAG_WRITE : 0);
> -       if (unlikely(fault & VM_FAULT_ERROR)) {
> -               if (fault & VM_FAULT_OOM)
> -                       goto out_of_memory;
> -               else if (fault & VM_FAULT_SIGBUS)
> -                       return fault;
> -               BUG();
> -       }
> +       fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, (fsr & FSR_WRITE) ? FAULT_FLAG_WRITE : 0);
> +       if (unlikely(fault & VM_FAULT_ERROR))
> +               return fault;
>        if (fault & VM_FAULT_MAJOR)
>                tsk->maj_flt++;
>        else
>                tsk->min_flt++;
>        return fault;
>
> -out_of_memory:
> -       if (!is_global_init(tsk))
> -               goto out;
> -
> -       /*
> -        * If we are out of memory for pid1, sleep for a while and retry
> -        */
> -       up_read(&mm->mmap_sem);
> -       yield();
> -       down_read(&mm->mmap_sem);
> -       goto survive;
> -
>  check_stack:
>        if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
>                goto good_area;
> @@ -278,6 +285,13 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>                if (!user_mode(regs) && !search_exception_tables(regs->ARM_pc))
>                        goto no_context;
>                down_read(&mm->mmap_sem);
> +       } else {
> +               /*
> +                * The above down_read_trylock() might have succeeded in
> +                * which case, we'll have missed the might_sleep() from
> +                * down_read()
> +                */
> +               might_sleep();
>        }
>
>        fault = __do_page_fault(mm, addr, fsr, tsk);
> @@ -289,6 +303,16 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>        if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
>                return 0;
>
> +       if (fault & VM_FAULT_OOM) {
> +               /*
> +                * We ran out of memory, call the OOM killer, and return to
> +                * userspace (which will retry the fault, or kill us if we
> +                * got oom-killed)
> +                */
> +               pagefault_out_of_memory();
> +               return 0;
> +       }
> +
>        /*
>         * If we are in kernel mode at this point, we
>         * have no context to handle this fault with.
> @@ -296,16 +320,6 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>        if (!user_mode(regs))
>                goto no_context;
>
> -       if (fault & VM_FAULT_OOM) {
> -               /*
> -                * We ran out of memory, or some other thing
> -                * happened to us that made us unable to handle
> -                * the page fault gracefully.
> -                */
> -               printk("VM: killing process %s\n", tsk->comm);
> -               do_group_exit(SIGKILL);
> -               return 0;
> -       }
>        if (fault & VM_FAULT_SIGBUS) {
>                /*
>                 * We had some memory, but were unable to
> @@ -489,10 +503,10 @@ hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *)
>  asmlinkage void __exception
>  do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  {
> -       const struct fsr_info *inf = fsr_info + (fsr & 15) + ((fsr & (1 << 10)) >> 6);
> +       const struct fsr_info *inf = fsr_info + fsr_fs(fsr);
>        struct siginfo info;
>
> -       if (!inf->fn(addr, fsr, regs))
> +       if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
>                return;
>
>        printk(KERN_ALERT "Unhandled fault: %s (0x%03x) at 0x%08lx\n",
> @@ -508,6 +522,6 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  asmlinkage void __exception
>  do_PrefetchAbort(unsigned long addr, struct pt_regs *regs)
>  {
> -       do_translation_fault(addr, 0, regs);
> +       do_translation_fault(addr, FSR_LNX_PF, regs);
>  }
>
>
>
