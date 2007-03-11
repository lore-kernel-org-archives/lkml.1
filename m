Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXCKQ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXCKQ3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 12:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933816AbXCKQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 12:29:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51660 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814AbXCKQ3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 12:29:20 -0400
Date: Sun, 11 Mar 2007 09:29:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicholas Miell <nmiell@comcast.net>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173593917.2958.150.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703110917500.9690@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
  <1173563796.2958.28.camel@entropy>  <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
  <1173572751.2958.107.camel@entropy>  <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
  <1173577759.2958.124.camel@entropy>  <Pine.LNX.4.64.0703102119020.10330@woody.linux-foundation.org>
 <1173593917.2958.150.camel@entropy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Nicholas Miell wrote:
> > 
> > UNIX has pid's for "process" handles, and "file descriptors" for just 
> > about everything else.
> 
> And I imagine that somebody will come up with way of getting a fd for a
> process sooner or later. 

Well, /proc/<pid>/ is about as close as you get. And that's largely 
inspired by a Plan-9'ish thing that does indeed expose processes as files.

The problem with processes is that they are actually so *complicated* that 
trying to describe them with a single file isn't all that useful (you 
could use tons of different ioctl's to do different operations, but that's 
against the "stream of bytes" model in UNIX, and even more so against the 
whole Plan-9 model).

> Actually, I was thinking reducing struct file to the bare minimum, and
> then using that as the common header shared by object-specific
> structures. I don't know how unpleasant that would be from a memory
> allocation perspective, though.

It would probably not be a bad idea, but I just doubt that it makes much 
of a difference, at least not for timerfd/signalfd files. There likely 
just won't be that many of them (I'd expect that processes that use them 
would normally just have one or two of each).

It might be more relevant for things like sockets and pty's: do a

	ls -l /proc/*/fd

and see what kind of files you have open, and I suspect most of the files 
will actually be sockets on a normal desktop setup, and even more so on 
some network server thing. And yes, it might be nice to avoid allocating 
memory for the (unnecessary) readahead and f_pos state, but in the end 
you seldom really have all *that* much memory allocated for file 
descriptors. The real memory use ends up being elsewhere..

IOW, I don't think it's a bad idea per se, I just doubt that it is worth 
the complexity and effort.

		Linus
