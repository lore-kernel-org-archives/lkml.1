Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYKMPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYKMPxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKMPxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:53:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45261 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYKMPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:53:04 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491C436C.6060603@kernel.org> (message from Tejun Heo on Fri, 14
	Nov 2008 00:10:36 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu> <491C2A63.1030804@kernel.org> <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu> <491C39BD.8050108@kernel.org> <E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu> <491C436C.6060603@kernel.org>
Message-Id: <E1L0eUz-0007D0-Tp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 16:52:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Tejun Heo wrote:
> Given that the number of in-flight requests are not too high, I think
> linear search is fine for now but switching it to b-tree shouldn't be
> difficult.
> 
> So, pros for req/reply approach.
> 
> * Less context switch per event notification.
> 
> * No need for separate async notification mechanism.
> 
> Cons.
> 
> * More interface impedence matching from libfuse.
> 
> * Higher overhead when poll/select finishes.  Either all outstanding
>   requests need to be cancelled using INTERRUPT whenever poll/select
>   returns or kernel needs to keep persistent list of outstanding polls
>   so that later poll/select can reuse them.  The problem here is that
>   kernel doesn't know when or whether they'll be re-used.  We can put
>   in LRU-based heuristics but it's getting too complex.

Why not just link the outstanding poll requests into a list anchored
in 'fuse_file'?  Easy to reuse, don't care about cancellation.

>  Note that
>   it's different from userland server keeping track.  The same problem
>   exists with userland based tracking but for many servers it would be
>   just a bit in existing structure and we can be much more lax on
>   userland.  ie. actual storage backed files usually don't need
>   notification at all as data is always available, so the amount of
>   overhead is limited in most cases but we can't assume things like
>   that for the kernel.
> 
> Overall, I think being lazy about cancellation and let userland notify
> asynchronously would be better performance and simplicity wise.  What
> do you think?

Lazy cancellation (no cancellation, esentially) sounds good.  But that
works fine with the simplified protocol.

Think of it this way, this is what a poll event would look like with
your scheme:

1) -> POLL-notification
2) <- POLL-req
3) -> POLL-reply (revents)

Notice, how 1) and 2) don't carry _any_ information (the notification
can be spurious, the events in the POLL request is just repeated from
the original request).  All the info is in 3), so I really don't see
any reason why the above would be better than just omitting the first
two steps.

Miklos
