Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYDCVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYDCVu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbYDCVts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:49:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758988AbYDCVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:49:45 -0400
Date: Thu, 3 Apr 2008 14:49:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, mingo@elte.hu, davem@davemloft.net,
       tony.luck@intel.com, paulus@samba.org, tglx@linutronix.de,
       lethal@linux-sh.org
Subject: Re: [PATCH 2/3] hugetlbfs: add missing TLB flush to hugetlb_cow()
Message-Id: <20080403144913.4eb59540.akpm@linux-foundation.org>
In-Reply-To: <1207146546.4980.14.camel@localhost.localdomain>
References: <1207145843.4980.7.camel@localhost.localdomain>
	<1207146546.4980.14.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 16:29:05 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> Subject: [PATCH 2/3] hugetlbfs: add missing TLB flush to hugetlb_cow()
> 
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> A cow break on a hugetlbfs page with page_count > 1 will set a new pte
> with set_huge_pte_at(), w/o any tlb flush operation. The old pte will
> remain in the tlb and subsequent write access to the page will result
> in a page fault loop, for as long as it may take until the tlb is
> flushed from somewhere else.
> This patch introduces an architecture-specific huge_ptep_clear_flush()
> function, which is called before the the set_huge_pte_at() in
> hugetlb_cow().
> 
> NOTE: This is just a nop on all architectures for now, there will be an
> s390 implementation with our large page patch later. Other architectures
> should define their own huge_ptep_clear_flush() if needed.
> 
> +#define huge_ptep_clear_flush(vma, addr, ptep)	do { } while (0)
> +#define huge_ptep_clear_flush(vma, addr, ptep)	do { } while (0)
> +#define huge_ptep_clear_flush(vma, addr, ptep)	do { } while (0)
> +#define huge_ptep_clear_flush(vma, addr, ptep)	do { } while (0)
> +#define huge_ptep_clear_flush(vma, addr, ptep)	do { } while (0)

Again, the problem here is that the macro doesn't have typechecking so I
can merrily add

	huge_ptep_clear_flush(some_u64, some_struct_ntfs_inode, some_undefined_variable)

and the compiler will just swallow it, depending on config options.  An
inline solves this.

And the macro can lead to unused-variable warnings because the macro
doesn't count as a reference of its args.  An inline solves this too.

There is almost never any need to put any code in macros ever.  Please make
it a last resort, not a first one.

