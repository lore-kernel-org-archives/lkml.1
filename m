Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbXE3HvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbXE3HvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXE3Hu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:50:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1195 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXE3Huz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:50:55 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, <w@1wt.edu>
Subject: RE: epoll,threading
Date: Wed, 30 May 2007 00:50:51 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEPJECAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070530072528.GP943@1wt.eu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 30 May 2007 01:51:17 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 30 May 2007 01:51:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I mostly agree with your comments, so I'm only responding to the points I
disagree with.

> So in fact, converting a threaded program to a pure async model should
> not improve it much because of the initial architectural design. But a
> program written from scratch to be purely async should perform better
> simply because it has less operations to perform. And there's no magics
> here : less cycles spend synchronizing and locking = more cycles available
> for the real job.

On the contrary, converting threaded programs to pure async is a disaster.
For one thing, you can never, ever block under any circumstances on pain of
total disaster. This means every single line of code is performance
critical. For all but the most trivial applications, this alone is a deal
killer.

The other problem is that no matter how careful you are, there is still
going to be some unexpected blocking. For example, suppose one connection
triggers some kind of error condition and the code to handle this error has
never faulted in. Now your entire application stalls until the error
handling code can fault in, which can be awhile if the disk is slow/busy.

> It's true that an async model is a lot of pain. But it's always where I
> got the best performance. For instance, with epoll(), I can achieve
> 20000 HTTP reqs/s with 40000 concurrent sessions. The best performance
> I have observed from threaded competitors was an order of magnitude below
> on either value (sometimes both).

I can't see how adding a second thread to your program could possibly make
it all that much worse. And when you do block unexpectedly, there's that
second thread to keep on working. And, of course, you can take advantage of
another CPU.

If adding a few more threads to your design makes it much worse, there's
something wrong with it. Perhaps you are conflating "threaded competitors"
with "thread-per-client competitors".

I also must be misunderstanding something you're saying, or you are very
confused. At one point you say that threaded programs are an order of
magnitude below pure async. At another point you say converting a threaded
program to pure async should not improve it much. I don't see how both of
these can be true unless you mean something different by "threaded" and
"async" in the two statements.

Thread-per-client works reasonably well up to some number of clients. On
most UNIXes, that number is around 300. On Windows, it's around 800. I
personally would only recommend it for applications that plan to handle 100
clients or fewer, or one platforms where you know the threading library
works well this way.

Pure async is just too painful. If you only have a single thread, the
program becomes unmaintainable because you must never ever block anywhere.
And you still can't avoid blocking sometimes, and this can cause a backup
from which you can never recover. (If you always wondered why your servers
were bursty, this is why.)

The best approach, in my experience, is to use multiple threads so that you
can take advantage of multiple CPUs, not be screwed if you block
unexpectedly, and even block intentionally in code that's not performance
critical. On Linux, 'epoll' is the most efficient socket discovery
technique, so you should use it in any design that's not thread-per-client.

DS


