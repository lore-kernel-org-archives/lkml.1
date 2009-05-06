Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZEFO4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZEFO4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbZEFOtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55328 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760319AbZEFOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:49:17 -0400
Date: Wed, 6 May 2009 15:46:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, chrisw@redhat.com, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
In-Reply-To: <20090506152100.41266e4c@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0905061532240.25289@blonde.anvils>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com>
 <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com>
 <20090506131735.GW16078@random.random> <Pine.LNX.4.64.0905061424480.19190@blonde.anvils>
 <20090506140904.GY16078@random.random> <20090506152100.41266e4c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Alan Cox wrote:
> > the max number of ksm pages that can be allocated at any given time so
> > to avoid OOM conditions, like the swap-compress logic that limits the
> > swapdevice size to less than ram.

(I don't know anything about that swap-compress logic and limitation.)

> 
> Are those pages accounted for in the vm_overcommit logic, as if you
> allocate a big chunk of memory as KSM will do you need the worst case
> vm_overcommit behaviour preserved and that means keeping the stats
> correct.

As I understand it, KSM won't affect the vm_overcommit behaviour at all.
Those pages Izik refers to are not allocated up front, they're just a
limit on the number of process pages which may get held in core at any
one time, through being shared via the KSM mechanism.

KSM is not evading vm_committed_space at all, not opening a backdoor
away from the ordinary mmaps: just collapsing duplicated pages in
what's been mapped in the usual way, down to single copies.

So the vm_commited_space accounting is exactly as before: it would
be a bit odd to be running KSM along with OVERCOMMIT_NEVER, but it
doesn't change its calculations at all - it will and will have to
be as pessimistic as it ever was.

The only difference would be in how much memory (mostly lowmem)
KSM's own data structures will take up - as usual, the kernel
data structures aren't being accounted, but do take up memory.

Hugh
