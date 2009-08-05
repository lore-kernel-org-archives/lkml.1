Return-Path: <linux-kernel-owner+w=401wt.eu-S934676AbZHEQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbZHEQb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934641AbZHEQb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:31:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934386AbZHEQb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:31:57 -0400
Date: Wed, 5 Aug 2009 18:31:43 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090805163143.GF23385@random.random>
References: <20090805024058.GA8886@localhost>
 <4A793B92.9040204@redhat.com>
 <4A7993F4.9020008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7993F4.9020008@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:15:16AM -0400, Rik van Riel wrote:
> Not having a hardware accessed bit would explain why
> the VM is not reactivating the pages that were accessed
> while on the inactive list.

Problem is, even with young bit functional the VM isn't reactivating
those pages anyway because of that broken check... That check should
be nuked entirely in my view as it fundamentally thinks it can
outsmart the VM intelligence by checking a bit in the vma... quite
absurd in my view.

> Can we find out which pages are EPT pages?
> 
> If so, we could unmap them when they get moved from the
> active to the inactive list, and soft fault them back in
> on access, emulating the referenced bit for EPT pages and
> making page replacement on them work like it should.
> 
> Your approximation of pretending the page is accessed the
> first time and pretending it's not the second time sounds
> like it will just lead to less efficient FIFO replacement,
> not to anything even vaguely approximating LRU.

I think it'll still better than current situation, as young bit is
always set for ptes. Otherwise EPT pages are too penalized, we need
them to stay one round more in active list like everything else. They
are too penalizied anyways because at second pass they'll be forced
out of active list and unmapped.

This is what alpha and all other archs without young bit set in
hardware have to do. They set young bit in software and clear it in
software and then set it again in software if there's a page fault
(hopefully a minor fault). Returning "not young" first time sounds
worse to me.
