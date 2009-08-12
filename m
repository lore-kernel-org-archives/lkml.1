Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZHLFpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZHLFpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 01:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZHLFpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 01:45:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44169 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZHLFpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 01:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FYnCT06NKMAFCeflXjwphFKZoHsd8+FDfPkUqsHQRax9UdRDHdcqV+KMa+JkWQ+yF/
         EjJVil9p2sUnvIiJdYeEwYI64tzHOXZI0fbQovOYSK6nn168R9B5UOkUs5a6LHT3Eg7/
         U5sUKaOVrlnDCfVcVdHyiFk3We0AeXtEmclCc=
MIME-Version: 1.0
In-Reply-To: <a45eb555ca7d9e23e5eb051e27f757ae70a6b0c5.1249999949.git.ebmunson@us.ibm.com>
References: <cover.1249999949.git.ebmunson@us.ibm.com>
	 <2154e5ac91c7acd5505c5fc6c55665980cbc1bf8.1249999949.git.ebmunson@us.ibm.com>
	 <a45eb555ca7d9e23e5eb051e27f757ae70a6b0c5.1249999949.git.ebmunson@us.ibm.com>
Date: Wed, 12 Aug 2009 08:45:09 +0300
X-Google-Sender-Auth: a436d5b01f47025d
Message-ID: <84144f020908112245g139564erbe56bac668a68bef@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add MAP_LARGEPAGE for mmaping pseudo-anonymous huge 
	page regions
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, Aug 12, 2009 at 1:13 AM, Eric B Munson<ebmunson@us.ibm.com> wrote:
> This patch adds a flag for mmap that will be used to request a huge
> page region that will look like anonymous memory to user space.  This
> is accomplished by using a file on the internal vfsmount.  MAP_LARGEPAGE
> is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
> region will behave the same as a MAP_ANONYMOUS region using small pages.
>
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>

I would love to see something like this in the kernel. Huge pages are
useful for garbage collection and JIT text in the userspace but
unfortunately obtaining them is a real PITA at the moment.

Is there any way to drop the
CAP_IPC_LOCK/in_group_p(hugetlbfs_shm_group) requirement, btw? That
would make huge pages even more accessible to user-space virtual
machines.

                        Pekka

> ---
>  include/asm-generic/mman-common.h |    1 +
>  include/linux/hugetlb.h           |    7 +++++++
>  mm/mmap.c                         |   16 ++++++++++++++++
>  3 files changed, 24 insertions(+), 0 deletions(-)
>
> diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
> index 3b69ad3..60b6be7 100644
> --- a/include/asm-generic/mman-common.h
> +++ b/include/asm-generic/mman-common.h
> @@ -19,6 +19,7 @@
>  #define MAP_TYPE       0x0f            /* Mask for type of mapping */
>  #define MAP_FIXED      0x10            /* Interpret addr exactly */
>  #define MAP_ANONYMOUS  0x20            /* don't use a file */
> +#define MAP_LARGEPAGE  0x40            /* create a large page mapping */
>
>  #define MS_ASYNC       1               /* sync memory asynchronously */
>  #define MS_INVALIDATE  2               /* invalidate the caches */
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 78b6ddf..b84361c 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -109,12 +109,19 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
>
>  #endif /* !CONFIG_HUGETLB_PAGE */
>
> +#define HUGETLB_ANON_FILE "anon_hugepage"
> +
>  enum {
>        /*
>         * The file will be used as an shm file so shmfs accounting rules
>         * apply
>         */
>        HUGETLB_SHMFS_INODE     = 0x01,
> +       /*
> +        * The file is being created on the internal vfs mount and shmfs
> +        * accounting rules do not apply
> +        */
> +       HUGETLB_ANONHUGE_INODE  = 0x02,
>  };
>
>  #ifdef CONFIG_HUGETLBFS
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 34579b2..c2c729a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -29,6 +29,7 @@
>  #include <linux/rmap.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/perf_counter.h>
> +#include <linux/hugetlb.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
> @@ -954,6 +955,21 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>        if (mm->map_count > sysctl_max_map_count)
>                return -ENOMEM;
>
> +       if (flags & MAP_LARGEPAGE) {
> +               if (file)
> +                       return -EINVAL;
> +
> +               /*
> +                * VM_NORESERVE is used because the reservations will be
> +                * taken when vm_ops->mmap() is called
> +                */
> +               len = ALIGN(len, huge_page_size(&default_hstate));
> +               file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
> +                                               HUGETLB_ANONHUGE_INODE);
> +               if (IS_ERR(file))
> +                       return -ENOMEM;
> +       }
> +
>        /* Obtain the address to map to. we verify (or select) it and ensure
>         * that it represents a valid section of the address space.
>         */
> --
> 1.6.3.2
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
