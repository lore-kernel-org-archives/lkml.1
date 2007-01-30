Return-Path: <linux-kernel-owner+w=401wt.eu-S965068AbXA3AH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068AbXA3AH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965080AbXA3AH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:07:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:47906 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068AbXA3AH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QnYHohSLhVXmDmGkojO9lx6wjnCMfWg1UKW+f+dWvoKjj/R8aoR7rSx7VitXU1naULUOaPe8pcqvKt6hvHfPxZ185azPbVK5lKJiHevIb0e5y/EDEFeW5Y2tRo08XsBiGDX/50XAph9eVCh0zjvCN1ii/Z3FXmTUIfNuq+yPGLE=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Andrea Arcangeli <andrea@suse.de>
Subject: Re: O_DIRECT question
Date: Tue, 30 Jan 2007 01:05:28 +0100
User-Agent: KMail/1.8.2
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@suse.de
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random>
In-Reply-To: <20070129170056.GJ8030@opteron.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701300105.28849.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 January 2007 18:00, Andrea Arcangeli wrote:
> On Sun, Jan 28, 2007 at 06:03:08PM +0100, Denis Vlasenko wrote:
> > I still don't see much difference between O_SYNC and O_DIRECT write
> > semantic.
> 
> O_DIRECT is about avoiding the copy_user between cache and userland,
> when working with devices that runs faster than ram (think >=100M/sec,
> quite standard hardware unless you've only a desktop or you cannot
> afford raid).

Yes, I know that, but O_DIRECT is also "overloaded" with
O_SYNC-like semantic too ("write doesnt return until data hits
physical media"). To have two ortogonal things "mixed together"
in one flag feels "not Unixy" to me. So I am trying to formulate
saner semantic. So far I think that this looks good:

O_SYNC - usual meaning
O_STREAM - do not try hard to cache me. This includes "if you can
	(buffer is sufficiently aligned, yadda, yadda), do not
	copy_user into pagecache but just DMA from userspace
	pages" - exactly because user told us that he is not
	interested in caching!

Then O_DIRECT is approximately = O_SYNC + O_STREAM, and I think
maybe Linus will not hate this "new" O_DIRECT - it doesn't
bypass pagecache.

> O_SYNC is about working around buggy or underperforming VM growing the
> dirty levels beyond optimal levels, or to open logfiles that you want
> to save to disk ASAP (most other journaling usages are better done
> with fsync instead).

I've got a feeling that db people use O_DIRECT (its O_SYNCy behaviour)
as a poor man's write barrier when they must be sure that their redo
logs have hit storage before they start to modify datafiles.
Another reason why they want sync writes is write error detection.
They cannot afford delaying it.
--
vda
