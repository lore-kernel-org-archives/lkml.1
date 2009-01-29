Return-Path: <linux-kernel-owner+w=401wt.eu-S1765878AbZA2Aeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765878AbZA2Aeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762383AbZA2A20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:28:26 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41811 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761066AbZA2A2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:28:24 -0500
Message-Id: <1233188902.29314.1297315165@webmail.messagingengine.com>
X-Sasl-Enc: NawIL15HRM/ywpeaVC6MhBfAxnrtIXzJRbcFku85a/T2 1233188902
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Davide Libenzi" <davidel@xmailserver.org>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <gregkh@suse.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20090128033824.GA1662@brong.net>
 <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
 <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
 <20090128053204.GB8720@brong.net>
 <19f34abd0901280308w18407fd5rd4d7d95e3799cf60@mail.gmail.com><alpine.DEB.1.10.0901280849340.20724@alien.or.mcafeemobile.com>
 <20090128205119.GA8587@brong.net>
 <alpine.DEB.1.10.0901281538400.21401@alien.or.mcafeemobile.com>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
In-Reply-To: <alpine.DEB.1.10.0901281538400.21401@alien.or.mcafeemobile.com>
Date: Thu, 29 Jan 2009 11:28:22 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Jan 2009 15:51 -0800, "Davide Libenzi" <davidel@xmailserver.org> wrote:
> On Thu, 29 Jan 2009, Bron Gondwana wrote:
> 
> > On Wed, Jan 28, 2009 at 08:52:51AM -0800, Davide Libenzi wrote:
> > > On Wed, 28 Jan 2009, Vegard Nossum wrote:
> > > 
> > > > On Wed, Jan 28, 2009 at 6:32 AM, Bron Gondwana <brong@fastmail.fm> wrote:
> > > > > That's clearly not happening here - so it seems that maybe our "happy
> > > > > medium" is actually in closer inspection of what's going on rather than
> > > > > a blanket low N to keep N^2 down.
> > > > 
> > > > Mh, could another solution to this all be to limit the number times
> > > > you can add a single epoll descriptor to another descriptor's set?
> > > 
> > > In the example that was posted, a single fd was added a single time inside 
> > > the other 1000+ fds. Epoll already has detection for too long chains and 
> > > closed loops, but you can't put those in the fast path. And epoll_ctl() is 
> > > one of those.
> > 
> > Not even if you're adding an epoll watcher inside another epoll watcher?
> 
> Adding an epoll fd inside another epoll fd is perfectly legal. It would
> kinda suck if epoll itself wouldn't expose a pollable interface too.

Yeah, I'm not suggesting killing it completely, just putting the limit
at that level rather than limiting watches completely.

The other thing I've looked at is just limiting watches per process to
rlim[RLIMIT_NFILE].  Any reason why that wouldn't be enough?  It means
you get limited to less than RLIMIT_NFILE if you add the same file
descriptor to multiple epolls... but that's not too scary.

> > The problem I have here is that "a single fd was added a single time
> > inside the other 1000+ fds" is different behaviour to the daemons out
> > there.  They're pretty much all using flat layouts:
> 
> Yes, that is not what programs normally do. Most of the times you have 
> nesting level equal zero, although we've seen recently that the 
> epoll-being-pollable feature (hence nesting) is used too. Say you have
> two 
> (or more) libraries, each own monitoring different things, and each own 
> with its own wait+dispatch loop. If these libraries didn't have a chance 
> to expose a pollable fd, you'd have to run their wait+dispatch loop in 
> seaprate threads. Whereas epoll being itself pollable allows you to:
> 
> 	epoll_wait(lib1_fd, lib2_fd)
> 	if (ready(lib1_fd))
> 		lib1_dispatch()
> 	if (ready(lib2_fd))
> 		lib2_dispatch()
> 
> This is pretty powerful, although needs care for wakeups and poll nested 
> calls.

That would only add a couple of "epoll watching epoll" instances though - you
could still limit that to a pretty low number and not impact normal use.

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

