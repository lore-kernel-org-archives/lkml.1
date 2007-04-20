Return-Path: <linux-kernel-owner+w=401wt.eu-S1767115AbXDTOr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767115AbXDTOr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767116AbXDTOr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:47:26 -0400
Received: from holomorphy.com ([66.93.40.71]:57087 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767115AbXDTOrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:47:14 -0400
Date: Fri, 20 Apr 2007 07:47:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
Message-ID: <20070420144726.GI31925@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com> <20070420134226.GA16878@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420134226.GA16878@skynet.ie>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 02:42:27PM +0100, Mel Gorman wrote:
> That's fair enough for the moment but relaxing would make ramfs
> potentially usable as a replacement for hugetlbfs so there would be just
> one ram-based filesystem instead of two.

Careful there. mmap() needs more than this.

(1) mapping->order is variable within an fs, so the architectural code
	would need some vague awareness of the underlying page size
	being variable unless the fs restricts it properly.
(2) by and large even large ptes are assumed to map a single object;
	where mapping->order exceeds the next smallest TLB entry size
	some potentially intricate machinations are required unless
	mapping->order restriction is used to avoid it.
(3) a backward compatibility wrapper for expand-on-mmap() semantics
	is needed, among other things.
(4) various odd hugetlb things like quotas are in there
(5) There are doubtless several oddities about SHM_HUGETLB to emulate
	that would not be automatic when substituting such an extended
	ramfs for hugetlbfs in ipc/shm.c
(6) ->get_unmapped_area() horrors.

The hugetlbfs fs stub has by and large been a huge embarrassment to me,
so I'd welcome the opportunity to foist off the vfs lifting onto ramfs.
I'd be happier with real superpages, but it's not my kernel.


-- wli
