Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbZHEOPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbZHEOPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934373AbZHEOPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:15:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934363AbZHEOPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:15:47 -0400
Message-ID: <4A7993F4.9020008@redhat.com>
Date: Wed, 05 Aug 2009 10:15:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <4A793B92.9040204@redhat.com>
In-Reply-To: <4A793B92.9040204@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:

>> However it risks reintroducing the problem addressed by commit 7e9cd4842
>> (fix reclaim scalability problem by ignoring the referenced bit,
>> mainly the pte young bit). I wonder if there are better solutions?

Agreed, we need to figure out what the real problem is,
and how to solve it better.

> Jeff, do you see the refaults on Nehalem systems?  If so, that's likely 
> due to the lack of an accessed bit on EPT pagetables.  It would be 
> interesting to compare with Barcelona  (which does).

Not having a hardware accessed bit would explain why
the VM is not reactivating the pages that were accessed
while on the inactive list.

> If that's indeed the case, we can have the EPT ageing mechanism give 
> pages a bit more time around by using an available bit in the EPT PTEs 
> to return accessed on the first pass and not-accessed on the second.

Can we find out which pages are EPT pages?

If so, we could unmap them when they get moved from the
active to the inactive list, and soft fault them back in
on access, emulating the referenced bit for EPT pages and
making page replacement on them work like it should.

Your approximation of pretending the page is accessed the
first time and pretending it's not the second time sounds
like it will just lead to less efficient FIFO replacement,
not to anything even vaguely approximating LRU.

-- 
All rights reversed.
