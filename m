Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZIYEjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZIYEjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZIYEjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:39:18 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:35551 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZIYEjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=owJ4QsFHkspE9kGvjECOBsiaxp5uphMhMxakMrwobrU/hN/3fdtv+SIxY9zhn413QY
         UF8cAEnEmYAlYTEdCV5YspL24lEQbzd5ur5ipjtMfFJflQ+nXOBn5mbeYnQtqk9v7JkF
         LM0ZWo86h3Dm0/ssFGG2x6+dsC4GhRDxCL8Ps=
MIME-Version: 1.0
In-Reply-To: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
References: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
Date: Fri, 25 Sep 2009 12:39:21 +0800
Message-ID: <7d86d44a0909242139v32a0ef6bh68386cbda31d0682@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data 
	can be mapped directly
From: graff yang <graff.yang@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Mundt <lethal@linux-sh.org>,
       Mel Gorman <mel@csn.ul.ie>, Greg Ungerer <gerg@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:13 PM, David Howells <dhowells@redhat.com> wrote:
> Fix MAP_PRIVATE mmap() of files and devices where the data in the backing store
> might be mapped directly.  Use the BDI_CAP_MAP_DIRECT capability flag to govern
> whether or not we should be trying to map a file directly.  This can be used to
> determine whether or not a region has been filled in at the point where we call
> do_mmap_shared() or do_mmap_private().
>
> The BDI_CAP_MAP_DIRECT capability flag is cleared by validate_mmap_request() if
> there's any reason we can't use it.  It's also cleared in do_mmap_pgoff() if
> f_op->get_unmapped_area() fails.
>
>
> Without this fix, attempting to run a program from a RomFS image on a
> non-mappable MTD partition results in a BUG as the kernel attempts XIP, and
> this can be caught in gdb:
>
> Program received signal SIGABRT, Aborted.
> 0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
> (gdb) bt
> #0  0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
> #1  0xc005f168 in do_mmap_pgoff (file=0xc31a6620, addr=<value optimized out>, len=3808, prot=3, flags=6146, pgoff=0) at mm/nommu.c:1373
> #2  0xc00a96b8 in elf_fdpic_map_file (params=0xc33fbbec, file=0xc31a6620, mm=0xc31bef60, what=0xc0213144 "executable") at mm.h:1145
> #3  0xc00aa8b4 in load_elf_fdpic_binary (bprm=0xc316cb00, regs=<value optimized out>) at fs/binfmt_elf_fdpic.c:343
> #4  0xc006b588 in search_binary_handler (bprm=0x6, regs=0xc33fbce0) at fs/exec.c:1234
> #5  0xc006c648 in do_execve (filename=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460, regs=0xc33fbce0) at fs/exec.c:1356
> #6  0xc0008cf0 in sys_execve (name=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460) at arch/frv/kernel/process.c:263
> #7  0xc00075dc in __syscall_call () at arch/frv/kernel/entry.S:897
>
>
> Note that this fix does the following commit differently:
>
>        commit a190887b58c32d19c2eee007c5eb8faa970a69ba
>        Author: David Howells <dhowells@redhat.com>
>        Date:   Sat Sep 5 11:17:07 2009 -0700
>        nommu: fix error handling in do_mmap_pgoff()
>
> Reported-by: Graff Yang <graff.yang@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Greg Ungerer <gerg@snapgear.com>
> ---
>
>  mm/nommu.c |   34 ++++++++++++----------------------
>  1 files changed, 12 insertions(+), 22 deletions(-)
>
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index c459aec..cc24d9f 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1074,7 +1074,7 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
>        ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
>        if (ret == 0) {
>                vma->vm_region->vm_top = vma->vm_region->vm_end;
> -               return ret;
> +               return 0;
>        }
>        if (ret != -ENOSYS)
>                return ret;
> @@ -1091,7 +1091,8 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
>  */
>  static int do_mmap_private(struct vm_area_struct *vma,
>                           struct vm_region *region,
> -                          unsigned long len)
> +                          unsigned long len,
> +                          unsigned long capabilities)
>  {
>        struct page *pages;
>        unsigned long total, point, n, rlen;
> @@ -1102,13 +1103,13 @@ static int do_mmap_private(struct vm_area_struct *vma,
>         * shared mappings on devices or memory
>         * - VM_MAYSHARE will be set if it may attempt to share
>         */
> -       if (vma->vm_file) {
> +       if (capabilities & BDI_CAP_MAP_DIRECT) {

This will breaks many drivers, e.g. some frame-buffer drivers, on NOMMU system.
Because they don't have get_unmapped_area().
These drivers depend on it's mmap() to return the frame-buffer base address.

-Graff


>                ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
>                if (ret == 0) {
>                        /* shouldn't return success if we're not sharing */
>                        BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
>                        vma->vm_region->vm_top = vma->vm_region->vm_end;
> -                       return ret;
> +                       return 0;
>                }
>                if (ret != -ENOSYS)
>                        return ret;
> @@ -1346,7 +1347,7 @@ unsigned long do_mmap_pgoff(struct file *file,
>                 * - this is the hook for quasi-memory character devices to
>                 *   tell us the location of a shared mapping
>                 */
> -               if (file && file->f_op->get_unmapped_area) {
> +               if (capabilities & BDI_CAP_MAP_DIRECT) {
>                        addr = file->f_op->get_unmapped_area(file, addr, len,
>                                                             pgoff, flags);
>                        if (IS_ERR((void *) addr)) {
> @@ -1370,15 +1371,17 @@ unsigned long do_mmap_pgoff(struct file *file,
>        }
>
>        vma->vm_region = region;
> -       add_nommu_region(region);
>
> -       /* set up the mapping */
> +       /* set up the mapping
> +        * - the region is filled in if BDI_CAP_MAP_DIRECT is still set
> +        */
>        if (file && vma->vm_flags & VM_SHARED)
>                ret = do_mmap_shared_file(vma);
>        else
> -               ret = do_mmap_private(vma, region, len);
> +               ret = do_mmap_private(vma, region, len, capabilities);
>        if (ret < 0)
> -               goto error_put_region;
> +               goto error_just_free;
> +       add_nommu_region(region);
>
>        /* okay... we have a mapping; now we have to register it */
>        result = vma->vm_start;
> @@ -1396,19 +1399,6 @@ share:
>        kleave(" = %lx", result);
>        return result;
>
> -error_put_region:
> -       __put_nommu_region(region);
> -       if (vma) {
> -               if (vma->vm_file) {
> -                       fput(vma->vm_file);
> -                       if (vma->vm_flags & VM_EXECUTABLE)
> -                               removed_exe_file_vma(vma->vm_mm);
> -               }
> -               kmem_cache_free(vm_area_cachep, vma);
> -       }
> -       kleave(" = %d [pr]", ret);
> -       return ret;
> -
>  error_just_free:
>        up_write(&nommu_region_sem);
>  error:
>
>



-- 
-Graff
