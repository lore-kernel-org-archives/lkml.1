Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYHZDIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYHZDIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 23:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYHZDIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 23:08:10 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:30065 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbYHZDIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 23:08:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtACAI8Os0h5LD0wiGdsb2JhbACSLAEBAQ8gpC6Baw
X-IronPort-AV: E=Sophos;i="4.32,268,1217773800"; 
   d="scan'208";a="180348679"
Date: Tue, 26 Aug 2008 13:07:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>,
       Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080826030759.GY5706@disturbed>
Mail-Followup-To: Jamie Lokier <jamie@shareable.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed> <20080825120146.GC20960@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825120146.GC20960@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 01:01:47PM +0100, Jamie Lokier wrote:
> Dave Chinner wrote:
> > To keep on top of this, we keep adding new variations and types and
> > expect the filesystems to make best use of them (without
> > documentation) to optimise for certain situations. Example - the
> > new(ish) BIO_META tag that only CFQ understands. I can change the
> > way XFS issues bios to use this tag to make CFQ behave the same way
> > it used to w.r.t. metadata I/O from XFS, but then the deadline and
> > AS will probably regress because they don't understand that tag and
> > still need the old optimisations that just got removed. Ditto for
> > prioritised bio dispatch - CFQ supports it but none of the others
> > do.
> 
> There's nothing wrong with adding BIO_META (for example) and other
> hints in _principle_.  You should be able to ignore it with no adverse
> effects.  If its not used by a filesystem (and there's nothing else
> competing to use the same disk), I would hope to see the same
> performance as other kernels which don't have it.

Right, but it's what we need to do to make use of that optimisation
that is the problem. For XFS, it needs to replace the current
BIO_SYNC hints we use (even for async I/O) to get metadata
dispatched quickly. i.e. CFQ looks at the sync flag first then the
meta flag.  Hence to take advantage of it, we need to remove the
BIO_SYNC hints we currently use which will change the behaviour on
all other elevators as a side effect.

This is the optimisation problem I'm refering to - the BIO_SYNC
usage was done years ago to get metadata dispatched quickly because
that is what all the elevators did with sync I/O. Now to optimise
for CFQ we need to remove that BIO_SYNC optimisation which is still
valid for the other elevators....

> If the elevators are being changed in such a way that old filesystem
> code which doesn't use new hint bits is running significantly slower,
> surely that's blatant elevator regression, and that's where the bugs
> should be reported and fixed?

Sure, but in reality getting ppl to go through the pain of triage is
extremely rare because it only takes 10s to change elevators and 
make the problem go away...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
