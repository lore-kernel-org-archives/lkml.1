Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbYARBQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbYARBQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbYARBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:16:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52092 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760037AbYARBQD (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:16:03 -0500
Date: Fri, 18 Jan 2008 12:15:42 +1100
From: David Chinner <dgc@sgi.com>
To: Valerie Henson <val@vahconsulting.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080118011542.GQ155259@sgi.com>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 01:30:43PM -0800, Valerie Henson wrote:
> Hi y'all,
> 
> This is a request for comments on the rewrite of the e2fsck IO
> parallelization patches I sent out a few months ago.  The mechanism is
> totally different.  Previously IO was parallelized by issuing IOs from
> multiple threads; now a single thread issues fadvise(WILLNEED) and
> then uses read() to complete the IO.

Interesting.

We ultimately rejected a similar patch to xfs_repair (pre-population
the kernel block device cache) mainly because of low memory
performance issues and it doesn't really enable you to do anything
particularly smart with optimising I/O patterns for larger, high
performance RAID arrays.

The low memory problems were particularly bad; the readahead
thrashing cause a slowdown of 2-3x compared to the baseline and
often it was due to the repair process requiring all of memory
to cache stuff it would need later. IIRC, multi-terabyte ext3
filesystems have similar memory usage problems to XFS, so there's
a good chance that this patch will see the same sorts of issues.

> Single disk performance doesn't change, but elapsed time drops by
> about 50% on a big RAID-5 box.  Passes 1 and 2 are parallelized.  Pass
> 5 is left as an exercise for the reader.

Promising results, though....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
