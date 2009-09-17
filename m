Return-Path: <linux-kernel-owner+w=401wt.eu-S1751227AbZIQAHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbZIQAHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZIQAHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:07:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:40554 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZIQAHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:07:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 16 Sep 2009 17:07:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gilad Benjamini <gilad@altornetworks.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll and closed file descriptors
In-Reply-To: <023c01ca3724$9f90fcb0$deb2f610$@com>
Message-ID: <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com>
References: <023c01ca3724$9f90fcb0$deb2f610$@com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Gilad Benjamini wrote:

> I am running repeatedly into a scenario  where epoll notifies userland of
> events on a closed file descriptor.
> I am running a single thread application, on a single CPU machine so
> multiple threads isn't the issue. 
> 
> A sample set of events that I have seen
> - File descriptor (13) for a socket is closed
> - epoll_wait returns with no events.
> - Several epoll related calls happen
> - More than 20 seconds after the "close", epoll_wait finds an event on fd 13
> with EPOLLIN|EPOLLERR|EPOLLHUP.
> - epoll_wait continues to report this event

Epoll removes the fd from its container, when the last instance of the 
underlying kernel file pointer is released (or when you explicitly 
remove it with epoll_ctl(EPOLL_CTL_DEL)).
If you continue to get the event, it means that someone else has an 
instance of the socket (that, looking at the events, saw a shutdown) open, 
by hence keeping the kernel object alive.
If you don't want to see the events, just remove the socket from the epoll 
set before closing.
Or, you remove the socket the first time you see an EPOLLHUP.



- Davide


