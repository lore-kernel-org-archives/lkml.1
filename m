Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbZKYRPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbZKYRPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbZKYRMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:12:33 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:1768 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934750AbZKYRMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:30 -0500
X-Trace: 296184770/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncBAKf0DEtPRTgw/2dsb2JhbAAI1h6EMgQ
X-IronPort-AV: E=Sophos;i="4.47,287,1257120000"; 
   d="scan'208";a="296184770"
Date: Wed, 25 Nov 2009 17:12:13 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/9] ksm: mem cgroup charge swapin copy
In-Reply-To: <20091125142355.GD2970@balbir.in.ibm.com>
Message-ID: <Pine.LNX.4.64.0911251646340.19522@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
 <Pine.LNX.4.64.0911241648520.25288@sister.anvils> <20091125142355.GD2970@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Balbir Singh wrote:
> * Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-11-24 16:51:13]:
> 
> > But ksm swapping does require one small change in mem cgroup handling.
> > When do_swap_page()'s call to ksm_might_need_to_copy() does indeed
> > substitute a duplicate page to accommodate a different anon_vma (or a
> > different index), that page escaped mem cgroup accounting, because of
> > the !PageSwapCache check in mem_cgroup_try_charge_swapin().
> > 
> 
> The duplicate page doesn't show up as PageSwapCache

That's right.

> or are we optimizing
> for the race condition where the page is not in SwapCache?

No, optimization wasn't on my mind at all.  To be honest, it's slightly
worsening the case of the race in which another thread has independently
faulted it in, and then removed it from swap cache.  But I think we'll
agree that that's rare enough a case that a few more cycles doing it
won't matter.

> I should probably look at the full series.

2/9 is the one which brings the problem: it's ksm_might_need_to_copy()
(an inline which tests for the condition) and ksm_does_need_to_copy()
(which makes a duplicate page when the condition has been found so).

The problem arises because an Anon struct page contains a pointer to
its anon_vma, used to locate its ptes when swapping.  Suddenly, with
KSM swapping, an anon page may get read in from swap, faulted in and
pointed to its anon_vma, everything fine; but then faulted in again
somewhere else, and needs to be pointed to a different anon_vma...

Lose its anon_vma and it becomes unswappable, not a good choice when
trying to extend swappability: so instead we allocate a duplicate page
just to point to the different anon_vma; and if they last long enough,
unchanged, KSM will come around again to find them the same and
remerge them.  Not an efficient solution, but a simple solution,
much in keeping with the way KSM already works.

The duplicate page is not PageSwapCache: certainly it crossed my mind
to try making it PageSwapCache like the original, but I think that
raises lots of other problems (how do we make the radix_tree slot
for that offset hold two page pointers?).

Hugh
