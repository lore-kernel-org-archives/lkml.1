Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbXIEWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbXIEWvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 18:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbXIEWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:50:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:56358 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756492AbXIEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:50:35 -0400
Cc: rdunlap@xenotime.net, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net,
       akpm@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 06 Sep 2007 00:50:33 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709051251290.11804@alien.or.mcafeemobile.com>
Message-ID: <20070905225033.236700@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
 <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net>
 <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904204932.208520@gmx.net>
 <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
 <20070905000831.313400@gmx.net>
 <Pine.LNX.4.64.0709050901420.11426@alien.or.mcafeemobile.com>
 <20070905162352.236680@gmx.net>
 <Pine.LNX.4.64.0709051251290.11804@alien.or.mcafeemobile.com>
Subject: Re: [PATCH] Revised timerfd() interface
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19n9DMprOBn8Me7VxzDJ2fP3XtHEPErivHZW8ifUl
 9k7jYT6kgKfY1LpT2/muO3S00Mo2PDB26x9Q== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 11+9EjF8bXB+MsPtSTU2yBEiLyUmZUgZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

> > > > > > As I think about this more, I see more problems with
> > > > > > your argument.  timerfd needs the ability to get and 
> > > > > > get-while-setting just as much as the earlier APIs.
> > > > > > Consider a library that creates a timerfd file descriptor that
> > > > > > is handed off to an application: that library may want
> > > > > > to modify the timer settings without having to create a
> > > > > > new file descriptor (the app mey not be able to be told about
> > > > > > the new fd).  Your argument just doesn't hold, AFAICS.
> > > > > 
> > > > > Such hypotethical library, in case it really wanted to offer such 
> > > > > functionality, could simply return an handle instead of the raw
> > > > > fd, and take care of all that stuff in userspace.
> > > > 
> > > > Did I miss something?  Is it not the case that as soon as the
> > > > library returns a handle, rather than an fd, then the whole
> > > > advantage of timerfd() (being able to select/poll/epoll on 
> > > > the timer as well as other fds) is lost?  
> > > 
> > > Why? The handle would simply be a little struct where the timerfd fd
> > > is 
> > > stored, and a XXX_getfd() would return it.
> > > So my point is, I doubt such functionalities are really needed, and I 
> > > also argue that the kernel is the best place for such wrapper code
> > > to go.
> > 
> > So what happens if one thread (via the library) wants modify
> > a timer's settings at the same timer as another thread is 
> > select()ing on it?  The first thread can't do this by creating
> > a new timerfd timer, since it wants to affect the select()
> > in the other thread?
> 
> It can be done w/out any problems. The select thread will be notified 
> whenever the new timer setting expires.

We are going in circles here.  I think you are missing my point.
Consider the following

[[
Thread A: calls library function which creates a timerfd file
descriptor.

Thread B: calls select() on the timerfd file descriptor.

Thread A: calls library function which wants to:
   a) modify timer settings, and retrieve copy of current timer
      settings, and later
   b) restore old timer settings.
]]

This seems a quite reasonable use-case to me, and the existing
interface simply can't support it.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

