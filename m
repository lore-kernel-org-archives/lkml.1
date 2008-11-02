Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYKBVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYKBVRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYKBVRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:17:16 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38770 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYKBVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:17:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 2 Nov 2008 13:17:13 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Olaf van der Spek <olafvdspek@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll behaviour after running out of descriptors
In-Reply-To: <b2cc26e40811021241t17a4fd02k32234b9e6b578b3b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811021258250.9451@alien.or.mcafeemobile.com>
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com> 
 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com> 
 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com> 
 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com> 
 <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com> 
 <Pine.LNX.4.64.0811021117050.9451@alien.or.mcafeemobile.com> 
 <b2cc26e40811021120p1fa19892m4be6e00785b79289@mail.gmail.com> 
 <Pine.LNX.4.64.0811021122530.9451@alien.or.mcafeemobile.com>
 <b2cc26e40811021241t17a4fd02k32234b9e6b578b3b@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008, Olaf van der Spek wrote:

> On Sun, Nov 2, 2008 at 8:27 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> >> I know what TIME_WAIT is. I just think it's not applicable to this situation.
> >
> > It is. You are saturating the port space, so no new POLLIN/accept events
> > are sent (until some TIME_WAIT clears), so epoll_wait() returns nothing
> > (or does not return, if INF timeo).
> > Keeping only 1K (if this is what you meant with your *only* 1K)
> > connections *alive*, does not mean the trail that does moving 1K
> > connections leave, is free.
> > If you ever played with things like httperf, you should know what I'm
> > talking about.
> 
> Wouldn't the port space require about 20+ k connects? This issue
> happens after 1 k.

The reason for "When accept returns EMFILE, I call epoll_wait and accept 
and it returns with another EMFILE." is because your sockets-close logic 
is broken. You get an event for the listening fd, you go call accept(2) 
and in one or two passes you fill up the avail fd space, then you go back 
calling epoll_wait(), and yet back to accept(2). This w/out triggering the 
file-close-relief code (yes, you fill up 1K fds *before* 30 seconds). Of 
course you get another EMFILE. When after a little while the close-loop 
triggers, likely the client quit trying, or the kernel accept backlog is 
full and no new events (remember, you chose ET) are triggered.
EMFILE is not EAGAIN, and it means that the fd can still have something 
for you. Going back to sleep with (EMFILE && ET) is bad mojo.
This is more food for linux-userspace than linux-kernel though.



- Davide


