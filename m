Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbYKMOsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbYKMOsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYKMOs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:48:27 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54340 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYKMOs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:48:26 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491C39BD.8050108@kernel.org> (message from Tejun Heo on Thu, 13
	Nov 2008 23:29:17 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu> <491C2A63.1030804@kernel.org> <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu> <491C39BD.8050108@kernel.org>
Message-Id: <E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 15:48:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Tejun Heo wrote:
> poll/select/epoll can poll on massive number of files.  I don't think
> it's wise to have that many outstanding requests.  FUSE currently uses
> linear list to match replies to requests and libfuse will consume one
> thread per each poll if implemented like other requests.  It can be made
> asynchronous from libfuse tho.
> 
> I kind of like the original implementation tho.  The f_ops->poll
> interface is designed to be used like ->poll returning events if
> available immediately and queue for later notification as necessary.
> Notification is asynchronous and can be spurious (this actually comes
> pretty handy for low level implementation).  When notified, upper layer
> queries the same way using ->poll.  This is quite convenient for low
> level implementation as the actual logic of poll can live in ->poll
> proper while notifications can be scattered around places where events
> can occur.

Yes, that kind of interface is nice for f_ops->poll, and for libfuse.

But for the kernel interface it's inefficient.  A wake up event is 3
context switches instead of one.  And that's inherent in the interface
itself for no good reason.

Also there's again the question of userspace filesystem messing with
the caller: your original implementation allows the userspace
filesystem to block f_ops->poll() forever, which really isn't what
poll/select is about.

So I'd still argue for the simple POLL-request/POLL-notify protocol on
the kernel API, and possibly have the async notification similar to
the kernel interface on the library API.

Implementation wise I don't care all that much, but I'd actually
prefer if it was implemented using the traditional request/reply thing
and optimized (possibly later) to find requests in a more efficient
way than searching the linear list, which would benefit not just poll
but all requests.

Miklos
