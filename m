Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXCHQ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXCHQ3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXCHQ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:29:35 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43810 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXCHQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:29:34 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 08:29:32 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Linus Torvalds wrote:

> You missed David's worry, I think.
> 
> Not only is POLLIN potentially an edge event (depending on the interface 
> you use to fetch it), but even as a level-triggered one you generally want 
> to read as much as possible per POLLIN event, and go back to the event 
> loop only when you get EAGAIN.
> 
> So that's in addition to the read/signal race with other 
> threads/processes.
> 
> You solved it by having a separate system call, but since it's a regular 
> file descriptor, why have a new system call at all, and not just make it 
> be a "read()"? In which case you definitely want O_NONBLOCK support.
> 
> The UNIX philosophy is often quoted as "everything is a file", but that 
> really means "everything is a stream of bytes".
> 
> In Windows, you have 15 different versions of "read()" with sockets and 
> files and pipes all having strange special cases and special system calls. 
> That's not the UNIX way. It should be just a "read()", and then people can 
> use general libraries and treat all sources the same.
> 
> For example, the main select/poll/epoll loop may be the one doing all the 
> reading, and then pass off "full buffers only" to the individual per-fd 
> "action routines". And that kind of model really very fundamentally wants 
> an fd to be an fd to be an fd - not "some file descriptors need 
> 'read_from_sigfd()', and some file descriptors need 'read()', and some 
> file descriptors need 'recvmsg()'" etc.
> 
> So I think you should get rid of signalfd_dequeue(), and just replace it 
> with a "read()" function.

The reason for the special function, was not to provide a non-blocking 
behaviour with zero timeout (that just a side effect), but to read the 
siginfo. I was all about using read(2) (and v1 used it), but when you have 
to transfer complex structures over it, it becomes hell. How do you 
cleanly compat over a f_op->read callback for example?



- Davide


