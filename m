Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZHEQFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZHEQFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZHEQFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:05:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41619 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbZHEQFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:05:17 -0400
Date: Wed, 5 Aug 2009 18:05:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
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
Message-ID: <20090805160504.GD23385@random.random>
References: <20090805024058.GA8886@localhost>
 <4A793B92.9040204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A793B92.9040204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:58:10AM +0300, Avi Kivity wrote:
> How do you distinguish between kvm pages and non-kvm anonymous pages?  
> More importantly, why should you?

It can't distinguish. Besides the pages being refaulted (as minor
faults) implies they weren't collected yet. So the fact they are
allowed to stay on active list or not can't matter or alter the
refaulting issue.

> Jeff, do you see the refaults on Nehalem systems?  If so, that's likely 
> due to the lack of an accessed bit on EPT pagetables.  It would be 
> interesting to compare with Barcelona  (which does).

It seems it wasn't using EPT.

Refaulting as minor faults, still possible w/ or w/o EPT and young
bit... when young bit is found not set, we just unmap the spte/pte and
we leave the page in lru for a while until it is collected. So it can
be refaulted even with young bit perfectly functional in spte and pte.

But the _whole_ point of NPT young bit (shame on EPT) and in pte, is
to try not to unmap the pagetables to get the aging information. So
there's a one more pass with young bit functional compared to without
young bit functional, but it doesn't mean that when young bit is clear
at second pass we immediately free the page, just we go into the
"refaulting lru cache waiting to be collected". And if the page isn't
actually collected it doesn't matter if it's in active or inactive
list, so patch can't matter if it's ""minor"" refaults what we're
talking about here :).
