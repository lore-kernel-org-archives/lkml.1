Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYH1Osz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYH1Osz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYH1Osr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:48:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56841 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYH1Osq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:48:46 -0400
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
From: Adam Litke <agl@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>, William Irwin <wli@holomorphy.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 28 Aug 2008 09:48:15 -0500
Message-Id: <1219934895.14358.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 14:24 +0900, KOSAKI Motohiro wrote:
> Now, hugepage's vma has VM_RESERVED flag because it cannot be swapped.
> 
> and VM_RESERVED vma isn't core dumped because its flag often be used for
> kernel internal vma (e.g. vmalloc, sound related).
> 
> So, hugepage is never dumped and it indicate hugepages's program can't be debugged easily.
> 
> In these days, demand on making use of hugepage is increasing.
> IMO, native support for coredump of hugepage is useful.
> 
> 
> I think VM_RESERVED default dumping bahavior is good,
> then I'd like to add coredump_filter mask.
> 
> This patch doesn't change dafault behavior.

I have tested this using both the provided C program and with a program
that used libhugetlbfs to back its text and data segments with huge
pages.  This seems to work as expected.  From a hugetlbfs perspective,
this seems like a reasonable patch to me.

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com>
> CC: Hugh Dickins <hugh@veritas.com>
> CC: William Irwin <wli@holomorphy.com>
> CC: Adam Litke <agl@us.ibm.com>

Tested-by: Adam Litke <agl@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>

> ---
>  Documentation/filesystems/proc.txt |    3 ++-
>  fs/binfmt_elf.c                    |    7 ++++++-
>  include/linux/sched.h              |    3 ++-
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> Index: b/Documentation/filesystems/proc.txt
> ===================================================================
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -2389,11 +2389,12 @@ will be dumped when the <pid> process is
>  of memory types. If a bit of the bitmask is set, memory segments of the
>  corresponding memory type are dumped, otherwise they are not dumped.
> 
> -The following 4 memory types are supported:
> +The following 5 memory types are supported:
>    - (bit 0) anonymous private memory
>    - (bit 1) anonymous shared memory
>    - (bit 2) file-backed private memory
>    - (bit 3) file-backed shared memory
> +  - (bit 5) hugetlb memory
> 
>    Note that MMIO pages such as frame buffer are never dumped and vDSO pages
>    are always dumped regardless of the bitmask status.
> Index: b/include/linux/sched.h
> ===================================================================
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -402,8 +402,9 @@ extern int get_dumpable(struct mm_struct
>  #define MMF_DUMP_MAPPED_PRIVATE	4
>  #define MMF_DUMP_MAPPED_SHARED	5
>  #define MMF_DUMP_ELF_HEADERS	6
> +#define MMF_DUMP_HUGETLB	7
>  #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
> -#define MMF_DUMP_FILTER_BITS	5
> +#define MMF_DUMP_FILTER_BITS	(MMF_DUMP_HUGETLB - MMF_DUMP_ANON_PRIVATE + 1)
>  #define MMF_DUMP_FILTER_MASK \
>  	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
>  #define MMF_DUMP_FILTER_DEFAULT \
> Index: b/fs/binfmt_elf.c
> ===================================================================
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1160,11 +1160,16 @@ static unsigned long vma_dump_size(struc
>  	if (vma->vm_flags & VM_ALWAYSDUMP)
>  		goto whole;
> 
> +#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
> +
> +	if ((vma->vm_flags & VM_HUGETLB) && FILTER(HUGETLB))
> +		goto whole;
> +
>  	/* Do not dump I/O mapped devices or special mappings */
>  	if (vma->vm_flags & (VM_IO | VM_RESERVED))
>  		return 0;
> 
> -#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
> 
>  	/* By default, dump shared memory if mapped from an anonymous file. */
>  	if (vma->vm_flags & VM_SHARED) {
> 
> 
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

