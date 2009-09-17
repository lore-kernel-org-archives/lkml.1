Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZIQAXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZIQAXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZIQAXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:23:11 -0400
Received: from smtp-gw51.mailanyone.net ([208.70.128.77]:38461 "EHLO
	smtp-gw51.mailanyone.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZIQAXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:23:11 -0400
X-Greylist: delayed 3610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 20:23:10 EDT
From: "Gilad Benjamini" <gilad@altornetworks.com>
To: "'Davide Libenzi'" <davidel@xmailserver.org>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com>
Subject: RE: epoll and closed file descriptors
Date: Wed, 16 Sep 2009 17:23:09 -0700
Message-ID: <024601ca372d$09ad9fb0$1d08df10$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aco3Kuj0FBkj+IBsRAayZWNoHDSexQAAdHVA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide wrote:
> On Wed, 16 Sep 2009, Gilad Benjamini wrote:
> 
> > I am running repeatedly into a scenario  where epoll notifies
> userland of
> > events on a closed file descriptor.
> > I am running a single thread application, on a single CPU machine so
> > multiple threads isn't the issue.
> >
> > A sample set of events that I have seen
> > - File descriptor (13) for a socket is closed
> > - epoll_wait returns with no events.
> > - Several epoll related calls happen
> > - More than 20 seconds after the "close", epoll_wait finds an event
> on fd 13
> > with EPOLLIN|EPOLLERR|EPOLLHUP.
> > - epoll_wait continues to report this event
> 
> Epoll removes the fd from its container, when the last instance of the
> underlying kernel file pointer is released (or when you explicitly
> remove it with epoll_ctl(EPOLL_CTL_DEL)).
> If you continue to get the event, it means that someone else has an
> instance of the socket (that, looking at the events, saw a shutdown)
> open,
> by hence keeping the kernel object alive.
> If you don't want to see the events, just remove the socket from the
> epoll
> set before closing.
> Or, you remove the socket the first time you see an EPOLLHUP.
> 
> 
> 
> - Davide

I would, but epoll is preventing me from doing so.
Early in sys_epoll_ctl there are these lines

  file = fget(epfd);
  if (!file)
    goto error_return;

Leaving me in a kind of dead lock

Gilad

