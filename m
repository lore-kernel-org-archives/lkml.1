Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbZAWBdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbZAWBdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbZAWBWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:22:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57722 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762314AbZAWBV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:21:58 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 22 Jan 2009 17:21:46 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
In-Reply-To: <200901230109.55706.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901221711500.7789@alien.or.mcafeemobile.com>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Pavel Pisa wrote:

> Hello Davide and all others,
> 
> I have got to implementing yet another event library and I experience
> something strange when level triggered epoll_wait() monitors another
> level triggered epoll set. Top level epoll_wait() return information
> about one event pending. The event points correctly to the monitored
> second level epoll fd, but epoll_wait() on this fd with 0 or small timeout
> returns zero/no events and top level epoll reporting is not reset at this
> point so program enters busy loop. If there are events, they are processed
> correctly.

I'm ashamed to say, I know. It has been reported to me about three months 
ago, I coded patches, but I did not have the time to test them carefully.
The problem is that inside the epoll wakeup callback, we don't know which 
even we got (and we can't call ->poll()). So we add the fd to the 
ready-list and we wake up the waiters. The current code simply does return 
EPOLLIN (from epoll's poll()) if the ready-list is not empty. The problem 
is that the even we received in the epoll callback could have been a 
POLLIN when the fd is waiting for POLLOUT. THis situations gets sorted out 
in epoll_wait(), but inside epoll's poll() only a quick test was used 
(ready-list not empty).
The patch was not exactly a one-liner, so I need a few days to double 
check it and test it. I'll try to do it this w/end.



- Davide


