Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbYKMPLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbYKMPLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKMPK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:10:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:44036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKMPK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:10:56 -0500
Message-ID: <491C436C.6060603@kernel.org>
Date: Fri, 14 Nov 2008 00:10:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu> <491C2A63.1030804@kernel.org> <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu> <491C39BD.8050108@kernel.org> <E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 15:10:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
>> I kind of like the original implementation tho.  The f_ops->poll
>> interface is designed to be used like ->poll returning events if
>> available immediately and queue for later notification as necessary.
>> Notification is asynchronous and can be spurious (this actually comes
>> pretty handy for low level implementation).  When notified, upper layer
>> queries the same way using ->poll.  This is quite convenient for low
>> level implementation as the actual logic of poll can live in ->poll
>> proper while notifications can be scattered around places where events
>> can occur.
> 
> Yes, that kind of interface is nice for f_ops->poll, and for libfuse.
> 
> But for the kernel interface it's inefficient.  A wake up event is 3
> context switches instead of one.  And that's inherent in the interface
> itself for no good reason.

Event notification performance problem is usually in its scalability
not in each notification.  It's nice to optimize that too but I don't
think it weighs too much especially for FUSE.  Doing it request/reply
way could have scalability concerns, please see below.

> Also there's again the question of userspace filesystem messing with
> the caller: your original implementation allows the userspace
> filesystem to block f_ops->poll() forever, which really isn't what
> poll/select is about.

That would simply be a broken poll implementation just as O_NONBLOCK
read can block in ->read forever.

> So I'd still argue for the simple POLL-request/POLL-notify protocol on
> the kernel API, and possibly have the async notification similar to
> the kernel interface on the library API.
> 
> Implementation wise I don't care all that much, but I'd actually
> prefer if it was implemented using the traditional request/reply thing
> and optimized (possibly later) to find requests in a more efficient
> way than searching the linear list, which would benefit not just poll
> but all requests.

Given that the number of in-flight requests are not too high, I think
linear search is fine for now but switching it to b-tree shouldn't be
difficult.

So, pros for req/reply approach.

* Less context switch per event notification.

* No need for separate async notification mechanism.

Cons.

* More interface impedence matching from libfuse.

* Higher overhead when poll/select finishes.  Either all outstanding
  requests need to be cancelled using INTERRUPT whenever poll/select
  returns or kernel needs to keep persistent list of outstanding polls
  so that later poll/select can reuse them.  The problem here is that
  kernel doesn't know when or whether they'll be re-used.  We can put
  in LRU-based heuristics but it's getting too complex.  Note that
  it's different from userland server keeping track.  The same problem
  exists with userland based tracking but for many servers it would be
  just a bit in existing structure and we can be much more lax on
  userland.  ie. actual storage backed files usually don't need
  notification at all as data is always available, so the amount of
  overhead is limited in most cases but we can't assume things like
  that for the kernel.

Overall, I think being lazy about cancellation and let userland notify
asynchronously would be better performance and simplicity wise.  What
do you think?

Thanks.

-- 
tejun
