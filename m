Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYBNBpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYBNBpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYBNBpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:45:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:27054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYBNBpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:45:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,349,1199692800"; 
   d="scan'208";a="257823100"
Subject: Re: [PATCH] x86: EFI runtime code mapping enhancement
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, ThomasGleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47B2D54F.1000302@suse.de>
References: <1202894561.5026.14.camel@caritas-dev.intel.com>
	 <47B2D54F.1000302@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 14 Feb 2008 09:46:20 +0800
Message-Id: <1202953580.5026.39.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 14 Feb 2008 01:45:23.0258 (UTC) FILETIME=[439859A0:01C86EAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 12:32 +0100, Andi Kleen wrote:
> Huang, Ying wrote:
> > This patch enhances EFI runtime code memory mapping as following:
> > 
> > - Move __supported_pte_mask & _PAGE_NX checking before invoking
> >   runtime_code_page_mkexec(). This makes it possible for compiler to
> >   eliminate runtime_code_page_mkexec() on machine without NX support.
> > 
> > - Use set_memory_x/nx in early_mapping_set_exec(). This eliminates the
> >   duplicated implementation.
> 
> It's a inefficiency because you split up the 2MB (or 1GB) pages
> in the direct mapping, although that is not strictly needed. This
> means everybody who happens to use memory in same 2M/1G region
> will eat unnecessary TLB misses.
> 
> It would be generally better to only execute your code in
> ioremap_cache() because that won't affect anybody else.
> 
> Eventually set_memory_x() will work correctly for ioremap() too
> so that should work then.

For EFI runtime service in virtual mode, using direct mapping is mainly
for kexec, where EFI runtime memory area need to be mapped at same
virtual address across kexec. For performance reason, it may be better
to use fixmap only instead. But this will waste some fixmap space.

But this patch is for EFI runtime service in physical mode (in 64 mode,
this needs a direct mapping page table), there are two choice.

- Use direct mapping of kernel, clean NX bit from kernel page table
temporarily before/after EFI calling. This needs not split 2M page into
4K pages, because the region changed is aligned with 2M. And, because
the changing is temporary, a little larger region is not a big issue.

- Construct a direct mapping page table for EFI only. I think this is
not good too. The code will be duplicated with kernel page table
initialization code.


An issue of this patch is that it does not work with 1G page. Aligning
EFI runtime code region with 1G seems not a good idea too. I think a
better method is adding a non-split mode to c_p_a(), where the region
changed is enlarged if necessary to avoid page allocation. This can be
used to implement early_set_memory_xx(). The early_set_memory_xx()
instead of duplicated c_p_a() variant can be used by EFI code.

Best Regards,
Huang Ying

