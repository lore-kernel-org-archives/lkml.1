Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbYBOCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbYBOCU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbYBOCUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:20:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:9681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800AbYBOCUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:20:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,355,1199692800"; 
   d="scan'208";a="379292690"
Subject: Re: [PATCH] x86: EFI runtime code mapping enhancement
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, ThomasGleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200802141306.17642.ak@suse.de>
References: <1202894561.5026.14.camel@caritas-dev.intel.com>
	 <47B2D54F.1000302@suse.de> <1202953580.5026.39.camel@caritas-dev.intel.com>
	 <200802141306.17642.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 10:10:09 +0800
Message-Id: <1203041409.27930.11.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 02:09:08.0707 (UTC) FILETIME=[BFA45B30:01C86F77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 13:06 +0100, Andi Kleen wrote:
> > For EFI runtime service in virtual mode, using direct mapping is mainly
> > for kexec, where EFI runtime memory area need to be mapped at same
> > virtual address across kexec. 
> 
> I see. I didn't consider this aspect.
> 
> > - Use direct mapping of kernel, clean NX bit from kernel page table
> > temporarily before/after EFI calling. This needs not split 2M page into
> > 4K pages, because the region changed is aligned with 2M. And, because
> > the changing is temporary, a little larger region is not a big issue.
> 
> I would just do it permanently. 

Because during early boot stage, alloc_page() is not available. If we do
it there, we must make more pages executable to avoid alloc_page(). It
may be acceptable for 2M mapping (aligned memory range with 2M), but I
think it is not acceptable for 1G mapping (aligned memory range with
1G).

Maybe it is the better method that always using the fixmap (efi_ioremap)
to map executable memory area to avoid split large mapping.

> > Aligning 
> > EFI runtime code region with 1G seems not a good idea too. I think a
> > better method is adding a non-split mode to c_p_a(), where the region
> > changed is enlarged if necessary to avoid page allocation. This can be
> > used to implement early_set_memory_xx(). The early_set_memory_xx()
> > instead of duplicated c_p_a() variant can be used by EFI code.
> 
> I attempted something like this with my advisory vs required static
> protections last week, but it was rejected.
> 
> But yes having such a mode would make sense agreed. 
> 
> The easiest way (as in least amount of code) to implement it actually 
> is to just bypass set_memory_*() and just do the lookup_address() yourself 
> and clear NX and do a global TLB flush. For the special case of NX
> that is fine because you don't need to worry about fixing up any aliases.

This is the original method. The issue is that it must be synced with
set_memory_*() and lookup_address() implementation. For example, it
lacked 1G support when that is added to lookup_address().

Best Regards,
Huang Ying

