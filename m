Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZLAMbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZLAMbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZLAMbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:31:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49308 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZLAMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:31:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] high system time & lock contention running large mixed workload
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20091201100444.GN30235@random.random>
References: <1259618429.2345.3.camel@dhcp-100-19-198.bos.redhat.com> <20091201100444.GN30235@random.random>
Message-Id: <20091201212357.5C3A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Dec 2009 21:31:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 30, 2009 at 05:00:29PM -0500, Larry Woodman wrote:
> > Before the splitLRU patch shrink_active_list() would only call
> > page_referenced() when reclaim_mapped got set.  reclaim_mapped only got
> > set when the priority worked its way from 12 all the way to 7. This
> > prevented page_referenced() from being called from shrink_active_list()
> > until the system was really struggling to reclaim memory.
> 
> page_referenced should never be called and nobody should touch ptes
> until priority went down to 7. This is a regression in splitLRU that
> should be fixed. With light VM pressure we should never touch ptes ever.

Ummm. I can't agree this. 7 is too small priority. if large system have prio==7,
the system have unacceptable big latency trouble.
if only prio==DEF_PRIOTIRY or something, I can agree you probably.


> > On way to prevent this is to change page_check_address() to execute a
> > spin_trylock(ptl) when it was called by shrink_active_list() and simply
> > fail if it could not get the pte_lockptr spinlock.  This will make
> > shrink_active_list() consider the page not referenced and allow the
> > anon_vma->lock to be dropped much quicker.
> > 
> > The attached patch does just that, thoughts???
> 
> Just stop calling page_referenced there...
> 
> Even if we ignore the above, one problem later in skipping over the PT
> lock, is also to assume the page is not referenced when it actually
> is, so it won't be activated again when page_referenced is called
> again to move the page back in the active list... Not the end of the
> world to lose a young bit sometime though.
> 
> There may be all reasons in the world why we have to mess with ptes
> when there's light VM pressure, for whatever terabyte machine or
> whatever workload that performs better that way, but I know in 100% of
> my systems I don't ever want the VM to touch ptes when there's light
> VM pressure, no matter what. So if you want the default to be messing
> with ptes, just give me a sysctl knob to let me run faster.

Um.
Avoiding lock contention on light VM pressure is important than
strict lru order. I guess we don't need knob.


