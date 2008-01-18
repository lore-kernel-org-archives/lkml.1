Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbYARBoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbYARBoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbYARBnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:43:43 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:35352 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbYARBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nnbsdIDObn5dE3ivTZbmbTa9xpFaT6dVlmcOdiuT50eDGp2/JOjDm54I6ObhZ0jO9mtXHtm3ysOdqVEeLgao/jWdQ+7STwV+tc6ucCPjsTin73oxjFfSdlYQwD5nDT0RcSm/nUgaHWr6tw5Q5W7K5343uUBJI76FnG4N6SXVghQ=
Message-ID: <70b6f0bf0801171743g610c4a96qf42b268ccc777db4@mail.gmail.com>
Date: Thu, 17 Jan 2008 17:43:37 -0800
From: "Valerie Henson" <val.henson@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       "Andreas Dilger" <adilger@clusterfs.com>, "Ric Wheeler" <ric@emc.com>
In-Reply-To: <20080118011542.GQ155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com>
	 <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
	 <20080118011542.GQ155259@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 5:15 PM, David Chinner <dgc@sgi.com> wrote:
> On Wed, Jan 16, 2008 at 01:30:43PM -0800, Valerie Henson wrote:
> > Hi y'all,
> >
> > This is a request for comments on the rewrite of the e2fsck IO
> > parallelization patches I sent out a few months ago.  The mechanism is
> > totally different.  Previously IO was parallelized by issuing IOs from
> > multiple threads; now a single thread issues fadvise(WILLNEED) and
> > then uses read() to complete the IO.
>
> Interesting.
>
> We ultimately rejected a similar patch to xfs_repair (pre-population
> the kernel block device cache) mainly because of low memory
> performance issues and it doesn't really enable you to do anything
> particularly smart with optimising I/O patterns for larger, high
> performance RAID arrays.
>
> The low memory problems were particularly bad; the readahead
> thrashing cause a slowdown of 2-3x compared to the baseline and
> often it was due to the repair process requiring all of memory
> to cache stuff it would need later. IIRC, multi-terabyte ext3
> filesystems have similar memory usage problems to XFS, so there's
> a good chance that this patch will see the same sorts of issues.

That was one of my first concerns - how to avoid overflowing memory?
Whenever I screw it up on e2fsck, it does go, oh, 2 times slower due
to the minor detail of every single block being read from disk twice.
:)

I have a partial solution that sort of blindly manages the buffer
cache.  First, the user passes e2fsck a parameter saying how much
memory is available as buffer cache.  The readahead thread reads
things in and immediately throws them away so they are only in buffer
cache (no double-caching).  Then readahead and e2fsck work together so
that readahead only reads in new blocks when the main thread is done
with earlier blocks.  The already-used blocks get kicked out of buffer
cache to make room for the new ones.

What would be nice is to take into account the current total memory
usage of the whole fsck process and factor that in.  I don't think it
would be hard to add to the existing cache management framework.
Thoughts?

> Promising results, though....

Thanks!  It's solving a rather simpler problem than XFS check/repair. :)

-VAL
