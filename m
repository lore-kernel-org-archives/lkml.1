Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXJaKG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXJaKG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbXJaKGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:06:48 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56097 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbXJaKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:06:47 -0400
Message-ID: <472853A8.8040308@bull.net>
Date: Wed, 31 Oct 2007 11:06:32 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-mm1] Change the ida/idr_pre_get() return value
 to follow the kernel convention
References: <20071030171350.cd25b87c.pierre.peiffer@bull.net> <20071030103356.bf11d1a7.akpm@linux-foundation.org>
In-Reply-To: <20071030103356.bf11d1a7.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/10/2007 11:13:29,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/10/2007 11:13:30,
	Serialize complete at 31/10/2007 11:13:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton wrote:
> On Tue, 30 Oct 2007 17:13:50 +0100
> Pierre Peiffer <pierre.peiffer@bull.net> wrote:
> 
>> ida_pre_get() and idr_pre_get() currently return 0 in case of error, and 1
>> in case of success, what is not the conventional way to handle error cases.
>>
>> This patch makes both of them return 0 in case of success, and an errcode
>> otherwise, and then it changes each caller to let them return the error
>> reported instead of ENOMEM. This avoids to the callers to make any assumption
>> about the cause of the error.
>>
> 
> If we're going to do this (and really we should), then we risk quietly
> breaking out-of-tree code and we risk breaking in-tree or
> soon-to-be-in-tree code which we didn't know about.

Indeed...

> So what we should do is to rename these functions when we change their
> interfaces.
> 
> Happily, this means that we then don't need to remove the old functions -
> we can keep them there for a while as we transition everything over to the
> new functions.  It also means that we can sneak the new functions into the
> 2.6.24 stream and then merge these changes via the relevant maintainers
> rather than needing a single atomic megapatch.
> 
> 
> Although I'd much prefer just to remove the pathetic things - idr_pre_get()
> is a truly awful interface.
> 
> It would be slightly better if it took an `id' argument and filled in the
> nodes at the appropriate position in the tree so that the caller is
> guaranteed that the subsequent idr_get_new() will succeed.  Because at
> present there is no guarantee that the nodes which you preallocated with
> idr_pre_get() are still available when you do your idr_get_new(): some
> other CPU/task might have come in and used them all.

Yes, that's what I've understand, indeed.

> 
> Storage classes which need to allcoate memory at insertion time are hard:
> radix_tree_preload() gets it right in terms of robustness, but it's an
> awful lot of fuss.
> 
> IDR gets it all wrong and compounds the problem by implementing internal
> locking.  It shouldn't have done that: storage code like this should use
> only caller-provided locking.

Ok, but for that, I prefer to let the IDR maintainers see what they can do,
because I'm not familiar at all with the IDR implementation and can not focus on
that now.

So do you think that just providing a new API (something like
idr_pre_allocate(), as you say above) would be better than nothing ?
Or we just leave the code as is for now ?

-- 
Pierre Peiffer
