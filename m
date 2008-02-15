Return-Path: <linux-kernel-owner+w=401wt.eu-S1765899AbYBOC4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765899AbYBOC4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbYBOCzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:55:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:57742 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbYBOCzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:55:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,355,1199692800"; 
   d="scan'208";a="258013431"
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080214183819.GA19846@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org>
	 <20080214161218.GA28152@elte.hu>
	 <20080214171603.GC16255@one.firstfloor.org>
	 <20080214183819.GA19846@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Feb 2008 10:52:33 +0800
Message-Id: <1203043953.30010.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 15 Feb 2008 02:51:32.0653 (UTC) FILETIME=[ABF3B5D0:01C86F7D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 19:38 +0100, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > this is indeed a bug (we change the attributes for a larger area 
> > > than needed), but your fix is unclean. Find below a cleaner 
> > > solution.
> > 
> > You're still ignoring the other problem of set_memory_uc() not 
> > handling fixmap and ioremap correctly. [...]
> 
> No, we did not ignore it, and yes, you are wrong.
> 
> One thing that you miss is that the 64-bit EFI runtime has to be marked 
> uncacheable only if it the EFI image attribute signals an uncacheable 
> area:
> 
>                 if (!(md->attribute & EFI_MEMORY_WB))
>                         set_memory_uc(md->virt_addr, md->num_pages);
> 
> and Linux EFI does not support device EFI runtimes. So your observation, 
> while correct for non-RAM 64-bit EFI images, is theoretical at the 
> moment and has no practical relevance.

On my test machine, there is EFI runtime memory area with EFI_MEMORY_UC
attribute. The following is cut from the dmesg:

EFI: mem75: type=4, attr=0xf, range=[0x000000007f4ff000-0x000000007f500000) (0MB)
EFI: mem76: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
EFI: mem77: type=11, attr=0x8000000000000001, range=[0x00000000fffb0000-0x00000000fffb4000) (0MB)

Where:

attr is md->attribute,
#define EFI_MEMORY_RUNTIME 0x8000000000000000
#define EFI_MEMORY_UC 0x0000000000000001

But because end_pfn_map contains the above UC memory area, efi_ioremap()
is not used on EFI 64.

Best Regards,
Huang Ying

