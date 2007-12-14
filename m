Return-Path: <linux-kernel-owner+w=401wt.eu-S1765467AbXLNERh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765467AbXLNERh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbXLNER2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:17:28 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:58139 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbXLNER1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:17:27 -0500
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
X-Message-Flag: Warning: May contain useful information
References: <20071213235543.568682000@intel.com>
	<20071213235712.339088000@intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Dec 2007 20:17:14 -0800
In-Reply-To: <20071213235712.339088000@intel.com> (venkatesh pallipadi's message of "Thu, 13 Dec 2007 15:55:49 -0800")
Message-ID: <ada8x3x7vw5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Dec 2007 04:17:15.0108 (UTC) FILETIME=[3511D240:01C83E08]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > --- linux-2.6.24-rc4.orig/include/asm-x86/io_64.h	2007-12-11 14:24:56.000000000 -0800
 > +++ linux-2.6.24-rc4/include/asm-x86/io_64.h	2007-12-11 15:49:52.000000000 -0800
 > @@ -142,7 +142,8 @@
 >   * it's useful if some control registers are in such an area and write combining
 >   * or read caching is not desirable:
 >   */
 > -extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 > +extern void __iomem * ioremap_nocache(unsigned long offset, unsigned long size);
 > +extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);

I think ioremap_wc() needs to be available on all archs for this to be
really useful to drivers.  It can be a fallback to ioremap_nocache()
everywhere except 64-bit x86, but it's not nice for every driver that
wants to use this to need an "#ifdef X86" or whatever.

Also I didn't see anything like pgprot_wc() in the patchset (although
I just skimmed quickly for now).  The use case I actually have would
be in a a driver's .mmap method, where I want to map device registers
into userspace with write-combining turned on:

	vma->vm_page_prot = pgprot_wc(vma->vm_page_prot);
	io_remap_pfn_range(vma, vma->vm_start, pfn, PAGE_SIZE, vma->vm_page_prot);

where the pfn points into a PCI BAR (which will only be mapped once,
so no issues with conflicting PATs or anything like that).

 - R.
