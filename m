Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbYBNMGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbYBNMGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYBNMG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:06:27 -0500
Received: from ns.suse.de ([195.135.220.2]:40829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbYBNMG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:06:26 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] x86: EFI runtime code mapping enhancement
Date: Thu, 14 Feb 2008 13:06:17 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@redhat.com>, ThomasGleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <1202894561.5026.14.camel@caritas-dev.intel.com> <47B2D54F.1000302@suse.de> <1202953580.5026.39.camel@caritas-dev.intel.com>
In-Reply-To: <1202953580.5026.39.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141306.17642.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For EFI runtime service in virtual mode, using direct mapping is mainly
> for kexec, where EFI runtime memory area need to be mapped at same
> virtual address across kexec. 

I see. I didn't consider this aspect.

> - Use direct mapping of kernel, clean NX bit from kernel page table
> temporarily before/after EFI calling. This needs not split 2M page into
> 4K pages, because the region changed is aligned with 2M. And, because
> the changing is temporary, a little larger region is not a big issue.

I would just do it permanently. 

> Aligning 
> EFI runtime code region with 1G seems not a good idea too. I think a
> better method is adding a non-split mode to c_p_a(), where the region
> changed is enlarged if necessary to avoid page allocation. This can be
> used to implement early_set_memory_xx(). The early_set_memory_xx()
> instead of duplicated c_p_a() variant can be used by EFI code.

I attempted something like this with my advisory vs required static
protections last week, but it was rejected.

But yes having such a mode would make sense agreed. 

The easiest way (as in least amount of code) to implement it actually 
is to just bypass set_memory_*() and just do the lookup_address() yourself 
and clear NX and do a global TLB flush. For the special case of NX
that is fine because you don't need to worry about fixing up any aliases.

-Andi
 
