Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYJZXMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYJZXMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 19:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYJZXMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 19:12:06 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56783 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYJZXMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 19:12:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 26 Oct 2008 16:12:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul P <ppak_98@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unexpected extra pollout events from epoll
In-Reply-To: <99943.65323.qm@web56305.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0810261600200.19212@alien.or.mcafeemobile.com>
References: <99943.65323.qm@web56305.mail.re3.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Can you try to trim lines at 80 chars or so?]


On Sun, 26 Oct 2008, Paul P wrote:

> > After that, via epoll_wait(), f_op->poll() is called to get the status 
> > of  the file, and since POLLIN|POLLOUT is returned (and since you're 
> > listening for EPOLLIN|EPOLLOUT), that gets reported back to you. The 
> > POLLOUT event, by meaning a buffer-full->buffer-avail transition, did 
> > not really happen, but since POLLOUT is true, that gets reported back 
> > too.
> 
> Ok, so make sure I understand you correctly, you're saying that 
> currently the kernel doesn't have awareness of the difference between 
> EPOLLIN and EPOLLOUT events because at the time of the event, both 
> EPOLLIN/EPOLLOUT are returned from the kernel and that at least for the 
> near term that's not going to change.  At some point, we can expect the 
> EPOLLOUT to give the correct event, but not till later than .28.

The kernel knows the difference between EPOLLIN and EPOLLOUT, of course. 
At the moment though, such condition is not reported during wakeups, and 
this is what is going to be changing.



> > The best way to do it ATM, is to wait for POLLOUT only when
> > really needed.
> 
> I'm a little unclear how to do this.  If I set the epoll_wait call to 
> wait for just epollin events, that's fine.  But when I send a large 
> buffer of data and use epoll_ctl to look for epollin|epollout events, 
> don't I have the same problem?  

You do that by writing data until it's finished, or you get EAGAIN. If you 
get EAGAIN, you listen for EPOLLOUT.
Reading is same, but you'd wait for EPOLLIN.



- Davide


