Return-Path: <linux-kernel-owner+w=401wt.eu-S1765352AbZLQVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765352AbZLQVQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765321AbZLQVQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:16:13 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:63249 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765268AbZLQVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:16:10 -0500
X-Trace: 309880773/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQAAF4uKktPRRyw/2dsb2JhbAAI1lOELQQ
X-IronPort-AV: E=Sophos;i="4.47,415,1257120000"; 
   d="scan'208";a="309880773"
Date: Thu, 17 Dec 2009 21:05:23 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Rik van Riel <riel@redhat.com>
cc: lwoodman@redhat.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: FWD:  [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
In-Reply-To: <4B2A8CA8.6090704@redhat.com>
Message-ID: <Pine.LNX.4.64.0912172055570.15788@sister.anvils>
References: <20091211164651.036f5340@annuminas.surriel.com>
 <1260810481.6666.13.camel@dhcp-100-19-198.bos.redhat.com>
 <20091217193818.9FA9.A69D9226@jp.fujitsu.com> <4B2A22C0.8080001@redhat.com>
 <4B2A8CA8.6090704@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Rik van Riel wrote:

> After removing some more immediate bottlenecks with
> the patches by Kosaki and me, Larry ran into a really
> big one:
> 
> Larry Woodman wrote:
> 
> > Finally, having said all that, the system still struggles reclaiming memory
> > with
> > ~10000 processes trying at the same time, you fix one bottleneck and it 
> > moves
> > somewhere else.  The latest run showed all but one running process spinning
> > in
> > page_lock_anon_vma() trying for the anon_vma_lock.  I noticed that there are
> > ~5000 vma's linked to one anon_vma, this seems excessive!!!
> > 
> > I changed the anon_vma->lock to a rwlock_t and page_lock_anon_vma() to use
> > read_lock() so multiple callers could execute the page_reference_anon code.
> > This seems to help quite a bit.
> 
> The system has 10000 processes, all of which are child
> processes of the same parent.
> 
> Pretty much all memory is anonymous memory.
> 
> This means that pretty much every anonymous page in the
> system:
> 1) belongs to just one process, but
> 2) belongs to an anon_vma which is attached to 10,000 VMAs!
> 
> This results in page_referenced scanning 10,000 VMAs for
> every page, despite the fact that each page is typically
> only mapped into one process.
> 
> This seems to be our real scalability issue.
> 
> The only way out I can think is to have a new anon_vma
> when we start a child process and to have COW place new
> pages in the new anon_vma.
> 
> However, this is a bit of a paradigm shift in our object
> rmap system and I am wondering if somebody else has a
> better idea :)

Please first clarify whether what Larry is running is actually
a workload that people need to behave well in real life.

>From time to time such cases have been constructed, but we've
usually found better things to do than solve them, because
they've been no more than academic problems.

I'm not asserting that this one is purely academic, but I do
think we need more than an artificial case to worry much about it.

An rwlock there has been proposed on several occasions, but
we resist because that change benefits this case but performs
worse on more common cases (I believe: no numbers to back that up).

Substitute a MAP_SHARED file underneath those 10000 vmas,
and don't you have an equal problem with the prio_tree,
which would be harder to solve than the anon_vma case?

Hugh
