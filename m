Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXCHR2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXCHR2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932149AbXCHR2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:28:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXCHR2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:28:34 -0500
Date: Thu, 8 Mar 2007 09:28:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <f2b55d220703080840xb0a1da0w41051a7c4a7ac4e3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703080919541.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com> 
 <1173364264.6891.3.camel@localhost>  <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
  <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
 <f2b55d220703080840xb0a1da0w41051a7c4a7ac4e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Mar 2007, Michael K. Edwards wrote:
> 
> Make it a netlink socket and fetch your structures using recvmsg().
> siginfo_t belongs in ancillary data.

Gaah. That interface is horrible.

> The UNIX philosophy is "everything's a file".  The Berkeley philosophy
> is "everything's a socket, except for files, which are feeble
> mini-sockets".  I'd go with the Berkeley crowd here.

No, the berkeley crowd is totally out to lunch.

I might agree with you *if* you could actually do "recvmsg()" on arbitrary 
file descriptors, but you cannot. 

We could fix that in Linux, of course, but the fact is, "recvmsg()" is 
*not* a superset of "read()". In general, it's a *subset*, exactly because 
very few file descriptors support it.

So the normal way to read from a file descriptor (and the *only* way in 
any generic select loop) is to use "read()". That's the only thing that 
works for everything. And we shouldn't break that.

The sad part is that there really is no reason why the BSD crowd couldn't 
have done recvmsg() as an "extended read with per-system call flags", 
which would have made things like O_NONBLOCK etc unnecessary, because you 
could do it just with MSG_DONTWAIT..

So anybody who would "go with the Berkeley crowd" really shows a lot of 
bad taste, I'm afraid. The Berkeley crowd really messed up here, and it's 
so long ago that I don't think there is any point in us trying to fix it 
any more.

(But if somebody makes recvmgs a general VFS interface and makes it just 
work for everything, I'd probably take the patch as a cleanup. I really 
think it should have been a "struct file_operations" thing rather than 
being a socket-only thing.. But since you couldn't portably use it 
anyway, the thing is pretty moot)

				Linus
