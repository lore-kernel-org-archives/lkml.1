Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbYBCST0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbYBCST0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYBCSTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:19:06 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:36234 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYBCSTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:19:04 -0500
Date: Sun, 3 Feb 2008 21:21:35 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
Message-ID: <20080203182135.GA5827@tv-sign.ru>
References: <20080130142014.GA2164@tv-sign.ru> <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu> <20080130172646.GA2355@tv-sign.ru> <1201987065.9062.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201987065.9062.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(remove stable@kernel.org from CC)

On 02/02, Matt Helsley wrote:
> 
> On Wed, 2008-01-30 at 20:26 +0300, Oleg Nesterov wrote:
> > 
> > Offtopic. I noticed this problem while looking at this patch:
> > 
> > 	http://marc.info/?l=linux-mm-commits&m=120141116911711
> > 
> > So this (the old vma could be removed before we create the new mapping)
> > means that the patch above has another problem: if we are remapping the
> > whole VM_EXECUTABLE vma, removed_exe_file_vma() can clear ->exe_file
> > while it shouldn't (Matt Helsley cc'ed).
> > 
> > Oleg.
> 
> 	Looking at sys_remap_file_pages() it appears that the shared flag must
> be set in order to remap. Executable mappings are always MAP_PRIVATE and
> hence lack the shared flag so that any modifications to those areas
> don't get written back to the executable. I don't think userspace can
> change this flag

Yes, userspace can't change it. But if MVFS changes ->vm_file it could also
change vm_flags... But I think you are right anyway, we shouldn't care.


So I have to try to find another bug ;) Suppose that ->load_binary() does
a series of do_mmap(MAP_EXECUTABLE). It is possible that mmap_region() can
merge 2 vmas. In that case we "leak" ->num_exe_file_vmas. Unless I missed
something, mmap_region() should do removed_exe_file_vma() when vma_merge()
succeds (near fput(file)).

Oleg.

