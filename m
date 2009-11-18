Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZKRWQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZKRWQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbZKRWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:16:46 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:53480 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753491AbZKRWQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:16:45 -0500
Date: Thu, 19 Nov 2009 09:16:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
Message-ID: <20091118221642.GN9467@discord.disaster>
References: <20091117162235.3DEB.A69D9226@jp.fujitsu.com> <20091117221108.GK9467@discord.disaster> <20091118153302.3E20.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091118153302.3E20.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:56:46PM +0900, KOSAKI Motohiro wrote:
> > On Tue, Nov 17, 2009 at 04:23:43PM +0900, KOSAKI Motohiro wrote:
> > > 
> > > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> > > memory, anyone must not prevent it. Otherwise the system cause
> > > mysterious hang-up and/or OOM Killer invokation.
> > 
> > The xfsbufd is a woken run by a registered memory shaker. i.e. it
> > runs when the system needs to reclaim memory. It forceѕ the
> > delayed write metadata buffers (of which there can be a lot) to disk
> > so that they can be reclaimed on IO completion. This IO submission
> > may require ѕome memory to be allocated to be able to free that
> > memory.
> > 
> > Hence, AFAICT the use of PF_MEMALLOC is valid here.
> 
> Thanks a lot. 
> I have one additional question, may I ask you?
> 
> How can we calculate maximum memory usage in xfsbufd?

It doesn't get calculated at the moment. It is very difficult to
calculate a usable size metric for it because there are multiple
caches (up to 3 per filesystem), and dentry/inode reclaim causes the
size of the cache to grow.  Hence the size of the cache is not
really something that can be considered a stable or predictable
input into a "reclaim now" calculation. As such we simply cause
xfsbufd run simultaneously with the shrinkers that cause it to
grow....

> I'm afraid that VM and XFS works properly but adding two makes memory exhaust.

I don't understand what you are trying to say here.

> And, I conclude XFS doesn't need sharing reservation memory with VM,
> it only need non failed allocation. right? IOW I'm prefer perter's
> suggestion.

Right. However, it is worth keeping in mind that this is a
performance critical path for inode reclaim.  Hence any throttling
of allocation will slow down the rate at which memory is freed by
the system....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
