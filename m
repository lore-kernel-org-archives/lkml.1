Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbYAaUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbYAaUHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbYAaUHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:07:05 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41718 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759320AbYAaUHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:07:02 -0500
Date: Thu, 31 Jan 2008 12:07:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/3] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080131123118.GK7185@v2.random>
Message-ID: <Pine.LNX.4.64.0801311200250.25299@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com>
 <20080131123118.GK7185@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andrea Arcangeli wrote:

> On Wed, Jan 30, 2008 at 08:57:52PM -0800, Christoph Lameter wrote:
> > @@ -211,7 +212,9 @@ asmlinkage long sys_remap_file_pages(uns
> >  		spin_unlock(&mapping->i_mmap_lock);
> >  	}
> >  
> > +	mmu_notifier(invalidate_range_begin, mm, start, start + size, 0);
> >  	err = populate_range(mm, vma, start, size, pgoff);
> > +	mmu_notifier(invalidate_range_end, mm, 0);
> >  	if (!err && !(flags & MAP_NONBLOCK)) {
> >  		if (unlikely(has_write_lock)) {
> >  			downgrade_write(&mm->mmap_sem);
> 
> This can't be enough for GRU, infact it can't work for KVM either. You
> got 1) to have some invalidate_page for GRU before freeing the page,
> and 2) to pass start, end to range_end (if you want kvm to use it
> instead of invalidate_page).

The external references are dropped when calling invalidate_range_begin. 
This would work both for the KVM and the GRU. Why would KVM not be able to 
invalidate the range before? Locking conventions is that no additional 
external reference can be added between invalidate_range_begin and 
invalidate_range_end. So KVM is fine too.

> mremap still missing as a whole.

mremap uses do_munmap which calls into unmap_region() that already has 
callbacks. So what is wrong there?
