Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672Ab0AMEzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0AMEzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 23:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774Ab0AMEzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 23:55:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0AMEzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 23:55:46 -0500
Date: Wed, 13 Jan 2010 15:55:38 +1100
From: Nick Piggin <npiggin@suse.de>
To: Yongseok Koh <yongseok.koh@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, gregkh@suse.de,
       vegard.nossum@gmail.com, mingo@elte.hu, penberg@cs.helsinki.fi,
       paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= <mw78.jang@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= 
	<jongwook.moon@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= <wonyong.cho@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/vcijJw==?= <jh.81.lee@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= <heemoon.bae@samsung.com>,
       =?utf-8?B?J++/ve+/vci/w6In?= <hyochang.nam@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= 
	<hyunjun79.lee@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= 
	<dragonwine.kim@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= <yg76.jung@samsung.com>,
       =?utf-8?B?J++/ve+/ve+/ve+/ve+/ve+/vSc=?= <tj.cho@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: I found a synchronization problem in mm/vmalloc.c
Message-ID: <20100113045538.GA3901@nick>
References: <006d01ca8f8b$b62c8ec0$2285ac40$%koh@samsung.com> <20100111163205.4d013e86.akpm@linux-foundation.org> <002201ca936a$1fc06780$5f413680$@koh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002201ca936a$1fc06780$5f413680$@koh@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 06:32:09PM +0900, Yongseok Koh wrote:
> Sorry, Mr. Morton.
> 
> Even though it is somewhat late, I am doing cc the mailing list.
> 
> Thanks.
> 
> -----Original Message-----
> 
> On Thu, 7 Jan 2010 20:22:30 +0900
> "Yongseok Koh" <yongseok.koh@samsung.com> wrote:
> 
> > Dear all,
> > 
> > I___m Yongseok Koh in Korea.
> > 
> 
> Thanks for the report.
> 
> Please do cc a mailing list when reporting bugs so that everyone else knows
> what's going on.
> 
> > 
> > I just got a new message in linux-2.6.28.10 (plz refer to the below)
> > 
> > And, one of my colleagues found that there is a synchronization 
> > problem in mm/vmalloc.c
> > 
> >  
> > 
> > In free_unmap_area_noflush(), va->flags is marked as VM_LAZY_FREE 
> > first, and then vmap_lazy_nr is increased atomically.
> > 
> > But, in __purge_vmap_area_lazy(), while traversing of vmap_are_list, 
> > nr is counted by checking VM_LAZY_FREE is set to va->flags.
> > 
> > After counting the variable nr, kernel reads vmap_lazy_nr atomically 
> > and checks a BUG_ON condition whether nr is greater than vmap_lazy_nr.
> > 
> >  
> > 
> > The problem is that, if interrupted right after marking VM_LAZY_FREE, 
> > increment of vmap_lazy_nr can be delayed.
> > 
> > Consequently, BUG_ON condition can be met because nr is counted more 
> > than vmap_lazy_nr.
> > 
> >  
> > 
> > What I mentioned is highly probable when vmalloc/vfree are called 
> > frequently.
> > 
> > And my colleagues have verified this scenario by adding delay between 
> > marking VM_LAZY_FREE and increasing vmap_lazy_nr in 
> > free_unmap_area_noflush().
> > 
> >  
> > 
> > Am I right ?
> > 
> 
> Looks plausible to me and as far as I can tell, current code has the same
> issue.

Yes, I think it's a good catch.

 
> Wakey wakey, Nick!  What makes that BUG_ON() safe?  Not purge_lock afacit?

No I think it is a bug. I would say that we can just get rid of the BUG_ON
now. atomic_t is signed, so it should be OK if it momentarily goes negative
(and anyway it's only used in a heuristic).

So, thanks for the report. Would you care to send a patch, or propose
another way to fix the problem?

Thanks,
Nick

