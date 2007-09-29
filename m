Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXI2ArK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXI2ArK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXI2Aq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:46:58 -0400
Received: from phunq.net ([64.81.85.152]:50441 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753485AbXI2Aq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:46:57 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Date: Fri, 28 Sep 2007 17:46:43 -0700
User-Agent: KMail/1.9.5
Cc: "Chakri n" <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <20070927235034.ae7bd73d.akpm@linux-foundation.org>
In-Reply-To: <20070927235034.ae7bd73d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281746.44499.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007 23:50, Andrew Morton wrote:
> Actually we perhaps could address this at the VFS level in another
> way. Processes which are writing to the dead NFS server will
> eventually block in balance_dirty_pages() once they've exceeded the
> memory limits and will remain blocked until the server wakes up -
> that's the behaviour we want.

It is not necessary to restrict total dirty pages at all.  Instead it is 
necessary to restrict total writeout in flight.  This is evident from 
the fact that making progress is the one and only reason our kernel 
exists, and writeout is how we make progress clearing memory.  In other 
words, if we guarantee the progress of writeout, we will live happily 
ever after and not have to sell the farm.

The current situation has an eerily similar feeling to the VM 
instability in early 2.4, which was never solved until we convinced 
ourselves that the only way to deal with Moore's law as applied to 
number of memory pages was to implement positive control of swapout in 
the form of reverse mapping[1].  This time round, we need to add 
positive control of writeout in the form of rate limiting.

I _think_ Peter is with me on this, and not only that, but between the 
too of us we already have patches for most of the subsystems that need 
it, and we have both been busy testing (different subsets of) these 
patches to destruction for the better part of a year.

Anyway, to fix the immediate bug before the one true dirty_limit removal 
patch lands (promise) I think you are on the right track by noticing 
that balance_dirty_pages has to become aware of how congested the 
involved block device is, since blocking a writeout process on an 
underused block device is clearly a bad idea.  Note how much this idea 
looks like rate limiting.

[1] We lost the scent for a number of reasons, not least because the 
experimental implementation of reverse mapping at the time was buggy 
for reasons entirely unrelated to the reverse mapping itself.

Regards,

Daniel
