Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbYALAfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbYALAfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 19:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbYALAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 19:35:30 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:44342 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbYALAf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 19:35:29 -0500
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <ebiederm@xmission.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hpa@zytor.co>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 09/11] PAT x86: Add ioremap_wc support
X-Message-Flag: Warning: May contain useful information
References: <20080110184840.927409000@intel.com>
	<20080110184856.379082000@intel.com> <p733at5o5vr.fsf@bingen.suse.de>
	<924EFEDD5F540B4284297C4DC59F3DEE5A281A@orsmsx423.amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 11 Jan 2008 16:18:12 -0800
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A281A@orsmsx423.amr.corp.intel.com> (Venkatesh Pallipadi's message of "Thu, 10 Jan 2008 11:25:25 -0800")
Message-ID: <ada3at3aocb.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jan 2008 00:18:12.0414 (UTC) FILETIME=[9E2325E0:01C854B0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >I don't think that's a good idea. Drivers should be able to 
 > >detect this somehow.
 > >Handling UC mappings as WC will probably give very poor results.

 > It is the other way. ioremap_wc aliases to ioremap_nocache.
 > This was based on earlier feedback from Roland.

 > >From: Roland Dreier [mailto:rdreier@cisco.com] 
 > >I think ioremap_wc() needs to be available on all archs for this to be
 > >really useful to drivers.  It can be a fallback to ioremap_nocache()
 > >everywhere except 64-bit x86, but it's not nice for every driver that
 > >wants to use this to need an "#ifdef X86" or whatever.

Yes... my basic point is simply that the kernel interfaces to this WC
stuff must be available on all architectures, even if it's stubbed out
on architectures that don't support write-combining or where it hasn't
been implemented yet.  I think the only sane way to stub it out is to
fall back to uncached...

It's not going to be useful if drivers need crazy #ifdefs to decide
whether to use ioremap_wc(), pgprot_writecombine() or whatever.  Just
look at the mess in drm_io_prot() in drm_vm.c to see what I want to
avoid.

Just to be explicit, my interest in this is that I want to be able to
merge the patch below and have the mlx4 driver still build and work on
every arch that has PCI support:

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d8287d9..5eac9c6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -381,8 +381,7 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 				       PAGE_SIZE, vma->vm_page_prot))
 			return -EAGAIN;
 	} else if (vma->vm_pgoff == 1 && dev->dev->caps.bf_reg_size != 0) {
-		/* FIXME want pgprot_writecombine() for BlueFlame pages */
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       to_mucontext(context)->uar.pfn +

