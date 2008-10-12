Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbYJLPrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbYJLPrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 11:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759756AbYJLPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 11:47:06 -0400
Received: from mail.vyatta.com ([76.74.103.46]:44146 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbYJLPrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 11:47:04 -0400
Date: Sun, 12 Oct 2008 08:47:01 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: davids@webmaster.com
Cc: <linux-net@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: recv() hangs until SIGCHLD ?
Message-ID: <20081012084701.21275a3a@extreme>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEFHAFAD.davids@webmaster.com>
References: <48F063C5.3000707@motion-twin.com>
	<MDEHLPKNGKAHNMBLJOLKKEFHAFAD.davids@webmaster.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 05:20:37 -0700
"David Schwartz" <davids@webmaster.com> wrote:

> 
> Nicolas Cannasse wrote:
> 
> > The sockets are non-blocking.
> 
> Ouch, that's a serious bug. Non-blocking operations shouldn't block!
> 
> > Checking with netstat and ss I can confirm that both Send and Recv
> > queues are empty, which makes the recv() behavior consistent.
> >
> > However since this problem does not occur without threads, we can be
> > sure that the blame is still on the receiver.
> >
> > In a practical case, we have a thread blocked in recv() for more than 12
> > hours, which is way beyond the timeout of the sender connection. The
> > socket has already been closed by the sender so recv() should at least
> > be noticed and returns 0.
> 
> Can you clarify what you mean by "the socket has already been closed by the
> sender"? You mean the other end of the TCP connection shut it down? By "the
> socket", you don't mean the socket you called 'recv' on, right? You mean the
> socket on the other end that's connected to it?
> 
> > Is it safe to assume that when either send() or recv() get interrupted
> > by a signal and returns EINTR, no actual data has been either sent or
> > consumed ? And if it's not, is there any other way around this ?
> 
> EINTR can only be return if 'send' or 'recv' have not sent or received
> anything. Otherwise the connection would be left in an indeterminate state.

Does application correctly handle the case where recv() returns 0?
This indicates the TCP connection is closed by the other end.
It is incorrect to assume that a return of 0 in non-blocking mode
is the same as -1. The only correct action after receiving 0 bytes
(even in non-blocking mode), is to close the socket. If you attempt
to do another receive, the result could be that the recv() waits for
another event (more data or FIN), which can never happen since socket
is closed.
