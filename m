Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbXITRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbXITRnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXITRnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:43:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36068 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbXITRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:43:09 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Sep 2007 10:42:15 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nagendra Tomar <tomer_iisc@yahoo.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
In-Reply-To: <130356.85796.qm@web53703.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709201033120.8897@alien.or.mcafeemobile.com>
References: <130356.85796.qm@web53703.mail.re2.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Nagendra Tomar wrote:

> The tcp_check_space() function calls tcp_new_space() only if the
> SOCK_NOSPACE bit is set in the socket flags. This is causing Edge Triggered
> EPOLLOUT events to be missed for TCP sockets, as the ep_poll_callback() 
> is not called from the wakeup routine.
> 
>         The SOCK_NOSPACE bit indicates the user's intent to perform writes
> on that socket (set in tcp_sendmsg and tcp_poll). I believe the idea 
> behind the SOCK_NOSPACE check is to optimize away the tcp_new_space call
> in cases when user is not interested in writing to the socket. These two
> take care of all possible scenarios in which a user can convey his intent
> to write on that socket.
> 
> Case 1: tcp_sendmsg detects lack of sndbuf space
> Case 2: tcp_poll returns not writable
> 
> This is fine if we do not deal with epoll's Edge Triggered events (EPOLLET).
> With ET events we can have a scenario where the SOCK_NOSPACE bit is not set,
> as the user has neither done a sendmsg nor a poll/epoll call that returned
> with the POLLOUT condition not set. 

Looking back at it, I think the current TCP code is right, once you look 
at the "event" to be a output buffer full->with_space transition.
If you drop an fd inside epoll with EPOLLOUT|EPOLLET and you get an event 
(free space on the output buffer), if you do not consume it (say a 
tcp_sendmsg that re-fill the buffer), you can't see other OUT event 
anymore since they happen on the full->with_space transition.
Yes, I know, the read size (EPOLLIN) works differently and you get an 
event for every packet you receive. And yes, I do not like asymmetric 
things. But that does not make the EPOLLOUT|EPOLLET wrong IMO.



- Davide


