Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYKMO3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYKMO3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYKMO3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:29:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:55285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbYKMO3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:29:35 -0500
Message-ID: <491C39BD.8050108@kernel.org>
Date: Thu, 13 Nov 2008 23:29:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu> <491C2A63.1030804@kernel.org> <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 14:29:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 13 Nov 2008, Tejun Heo wrote:
>> We don't need POLL_RELEASE
> 
> What happens on timeout?  Do we just let userspace continue polling
> the file descriptor, and then ignore the notification?

Yeap, spurious notifications don't cause any problems.

>>  but we still need POLL-reply (to request) to
>> send revents.  We can put that into notification too.  Hmmm... Yeah,
>> that could be simpler for FUSE servers.  I'll venture that way.
> 
> Then in fact the notification could just become the reply:
> 
> <- POLL-request (sent with request_send_nowait())
> ...
> -> POLL-reply  (calls req->end())
> 
> So there won't even be a need to implement notification (we'll need
> that for other things in the future) simplifying things even further.
> Even if we want to cancel the request because of a timeout, that could
> be done with the existing INTERRUPT request.

poll/select/epoll can poll on massive number of files.  I don't think
it's wise to have that many outstanding requests.  FUSE currently uses
linear list to match replies to requests and libfuse will consume one
thread per each poll if implemented like other requests.  It can be made
asynchronous from libfuse tho.

I kind of like the original implementation tho.  The f_ops->poll
interface is designed to be used like ->poll returning events if
available immediately and queue for later notification as necessary.
Notification is asynchronous and can be spurious (this actually comes
pretty handy for low level implementation).  When notified, upper layer
queries the same way using ->poll.  This is quite convenient for low
level implementation as the actual logic of poll can live in ->poll
proper while notifications can be scattered around places where events
can occur.

Thanks.

-- 
tejun
