Return-Path: <linux-kernel-owner+w=401wt.eu-S934948AbYBBVSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948AbYBBVSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbYBBVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:18:32 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36853 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbYBBVSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:18:31 -0500
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080130172646.GA2355@tv-sign.ru>
References: <20080130142014.GA2164@tv-sign.ru>
	 <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
	 <20080130172646.GA2355@tv-sign.ru>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sat, 02 Feb 2008 13:17:45 -0800
Message-Id: <1201987065.9062.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 20:26 +0300, Oleg Nesterov wrote:
> On 01/30, Miklos Szeredi wrote:
> > 
> > On Wed, 2008-01-30 at 17:20 +0300, Oleg Nesterov wrote:
> > > Fix ->vm_file accounting, mmap_region() may do do_munmap().
> > 
> > There's a small problem with the patch: the vma itself is freed at
> > unmap, so the fput(vma->vm_file) may crash.  Here's an updated patch.
> 
> Ah, indeed, thanks!
> 
> 
> Offtopic. I noticed this problem while looking at this patch:
> 
> 	http://marc.info/?l=linux-mm-commits&m=120141116911711
> 
> So this (the old vma could be removed before we create the new mapping)
> means that the patch above has another problem: if we are remapping the
> whole VM_EXECUTABLE vma, removed_exe_file_vma() can clear ->exe_file
> while it shouldn't (Matt Helsley cc'ed).
> 
> Oleg.

	Looking at sys_remap_file_pages() it appears that the shared flag must
be set in order to remap. Executable mappings are always MAP_PRIVATE and
hence lack the shared flag so that any modifications to those areas
don't get written back to the executable. I don't think userspace can
change this flag -- even using plain mremap. So, unless there's a way to
change that flag, I don't think there's anything related to
VM_EXECUTABLE vmas that needs to be done here.

Cc'ing linux-mm.

Cheers,
	-Matt Helsley

