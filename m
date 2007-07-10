Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbXGJU27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbXGJU27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbXGJU2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:28:52 -0400
Received: from www.osadl.org ([213.239.205.134]:38278 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753047AbXGJU2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:28:51 -0400
Subject: Re: Efficient use of low-precision kernel timers
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.name>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0707101452570.2556-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707101452570.2556-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 22:28:49 +0200
Message-Id: <1184099329.12353.20.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Tue, 2007-07-10 at 14:59 -0400, Alan Stern wrote:
> Thomas:
> 
> Here's a question for you or anyone else who can help.
> 
> I've got a low-precision kernel timer, with a delay measured in seconds
> (and rounded off to a second boundary).  Under some circumstances the
> timer might be cancelled and restarted many times in quick succession
> (a few thousand times perhaps).  Alternatively the timer could simply
> be allowed to expire and then restarted, with the callback routine
> doing a rather small amount of work.
> 
> Which is the most efficient?  Or to put it another way, how many times 
> can I cancel and restart a low-precision timer before it uses up as 
> much CPU time as allowing the timer to expire once?

Hard to tell.

> Is there a reasonable way to answer this?  I can't think of any good 
> tests.  Or is the difference in overhead so small as to be meaningless?

The insertion / deletion needs to take the timer->base->lock, but this
is cheap as long as the insert / cancel happens on the same CPU.

The other overhead which might be "visible" is when the timer needs to
be re-cascaded in the wheel. See the table below:

         100 250 1000 HZ
[1] 256   10    4   1 ms
[2]  64 2560 1024 256 ms
[3]  64  164   66  16  s
[4]  64  175   70  17  m
[5]  64  186   75  19  h

In the 250Hz case the timer < 1024ms is never re-cascaded. A timer <66s
is re-cascaded at max. once.

So I guess your frequent cancel/restart scheme is just fine. It does not
re-trigger any kind of hardware event and the insertion/deletion is
O(1).

The network code relies on this cheap mechanism on high loaded server
machines.

Hope that helps,

	tglx


