Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXL3TZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXL3TZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 14:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXL3TZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 14:25:20 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51687 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXL3TZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 14:25:19 -0500
Date: Mon, 31 Dec 2007 00:54:06 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, htejun@gmail.com,
       gregkh@suse.de, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071230192406.GA10454@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071215035200.GA22082@linux.vnet.ibm.com> <20071214220030.325f82b8.akpm@linux-foundation.org> <20071215104434.GA26325@linux.vnet.ibm.com> <20071217045904.GB31386@linux.vnet.ibm.com> <Pine.LNX.4.64.0712171143280.12871@schroedinger.engr.sgi.com> <20071217120720.e078194b.akpm@linux-foundation.org> <Pine.LNX.4.64.0712171222470.29500@schroedinger.engr.sgi.com> <20071221044508.GA11996@linux.vnet.ibm.com> <Pine.LNX.4.64.0712261258050.16862@schroedinger.engr.sgi.com> <20071230140116.GC21106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230140116.GC21106@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 03:01:16PM +0100, Ingo Molnar wrote:
> 
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Index: linux-2.6/arch/x86/mm/pgtable_32.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/mm/pgtable_32.c	2007-12-26 12:55:10.000000000 -0800
> > +++ linux-2.6/arch/x86/mm/pgtable_32.c	2007-12-26 12:55:54.000000000 -0800
> > @@ -366,6 +366,15 @@ void pgd_free(pgd_t *pgd)
> >  		}
> >  	/* in the non-PAE case, free_pgtables() clears user pgd entries */
> >  	quicklist_free(0, pgd_dtor, pgd);
> > +
> > +	/*
> > +	 * We must call check_pgd_cache() here because the pgd is freed after
> > +	 * tlb flushing and the call to check_pgd_cache. In some cases the VM
> > +	 * may not call tlb_flush_mmu during process termination (??).
> 
> that's incorrect i think: during process termination exit_mmap() calls 
> tlb_finish_mmu() unconditionally which calls tlb_flush_mmu().
> 
> > +	 * If this is repeated then we may never call check_pgd_cache.
> > +	 * The quicklist will grow and grow. So call check_pgd_cache here.
> > +	 */
> > +	check_pgt_cache();
> >  }
> 
> so we still dont seem to understand the failure mode well enough. This 
> also looks like a quite dangerous change so late in the v2.6.24 cycle. 
> Does it really fix the OOM? If yes, why exactly?
> 

No it does not. I've sent out some more information if it helps, will
send to you separately.

-- 
regards,
Dhaval
