Return-Path: <linux-kernel-owner+w=401wt.eu-S1751241AbZHERyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbZHERyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZHERyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:54:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHERyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:54:23 -0400
Message-ID: <4A79C70C.6010200@redhat.com>
Date: Wed, 05 Aug 2009 13:53:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost>
In-Reply-To: <20090805024058.GA8886@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> The refaults can be drastically reduced by the following patch, which
> respects the referenced bit of all anonymous pages (including the KVM
> pages).

The big question is, which referenced bit?

All anonymous pages get the referenced bit set when they are
initially created.  Acting on that bit is pretty useless, since
it does not add any information at all.

> However it risks reintroducing the problem addressed by commit 7e9cd4842
> (fix reclaim scalability problem by ignoring the referenced bit,
> mainly the pte young bit). I wonder if there are better solutions?

Reintroducing that problem is disastrous for large systems
running eg. JVMs or certain scientific computing workloads.

When you have a 256GB system that is low on memory, you need
to be able to find a page to swap out soon.  If all 64 million
pages in your system are "recently referenced", you run into
BIG trouble.

I do not believe we can afford to reintroduce that problem.

Also, the inactive list (where references to anonymous pages
_do_ count) is pretty big.  Is it not big enough in Jeff's
test case?

Jeff, what kind of workloads are you running in the guests?

-- 
All rights reversed.
