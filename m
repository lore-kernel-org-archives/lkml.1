Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYBPTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYBPTW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYBPTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:22:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57540 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbYBPTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:22:19 -0500
Date: Sat, 16 Feb 2008 11:22:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks
In-Reply-To: <20080215193736.9d6e7da3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802161121130.25573@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.918191502@sgi.com>
 <20080215193736.9d6e7da3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Andrew Morton wrote:

> > @@ -287,7 +288,8 @@ static int page_referenced_one(struct pa
> >  	if (vma->vm_flags & VM_LOCKED) {
> >  		referenced++;
> >  		*mapcount = 1;	/* break early from loop */
> > -	} else if (ptep_clear_flush_young(vma, address, pte))
> > +	} else if (ptep_clear_flush_young(vma, address, pte) |
> > +		   mmu_notifier_age_page(mm, address))
> >  		referenced++;
> 
> The "|" is obviously deliberate.  But no explanation is provided telling us
> why we still call the callback if ptep_clear_flush_young() said the page
> was recently referenced.  People who read your code will want to understand
> this.

Andrea?

> >  		flush_cache_page(vma, address, pte_pfn(*pte));
> >  		entry = ptep_clear_flush(vma, address, pte);
> > +		mmu_notifier(invalidate_page, mm, address);
> 
> I just don't see how ths can be done if the callee has another thread in
> the middle of establishing IO against this region of memory. 
> ->invalidate_page() _has_ to be able to block.  Confused.

The page lock is held and that holds off I/O?

