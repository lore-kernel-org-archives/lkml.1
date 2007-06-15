Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbXFOAHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbXFOAHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXFOAHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:07:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:38366 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbXFOAHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:07:32 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20070614125843.GA78@tv-sign.ru>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com>
	 <20070606105900.DE5E94D0592@magilla.localdomain>
	 <20070613151530.GA232@tv-sign.ru> <200706141426.45522.rjw@sisk.pl>
	 <20070614125843.GA78@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 10:06:56 +1000
Message-Id: <1181866017.14818.412.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 16:58 +0400, Oleg Nesterov wrote:
> 
> > Well, the only code path in which we'd want to call cancel_freezing() for kernel
> > threads is when the freezing of kernel threads.  However, this only happens if
> > one of the kernel threads declares itself as freezable and the fails to call
> > try_to_freeze(), which is a bug.
> 
> But this happens? We know a lot of reasons why try_to_freeze() can fail just
> because some kthread waits for already frozen task.

The freezer is a deadlock-o-matic by design. It's one of the major if
not the main reason why we don't use the code in kernel/power.c on
PowerBooks for suspend-to-ram. I don't like it and paulus hates it.

> Well, we can have very subtle problems because a kernel thread may run with
> TIF_SIGPENDING forever. This means in particualar that any wait_event_interruptible()
> can't succeed. I think this is worse than explicit failure (like -ERESSTART... leak),
> because it is hard to reproduce/debug.

Then just don't send signals to them...

> > Moreover, I'm not sure that it's a good idea at all to send signals to kernel
> > threads from the freezer, since in fact we only need to wake them up to make
> > them call try_to_freeze() (after we've set TIF_FREEZE for them).
> 
> Yes! I completely agree.

Sounds like a plan...

Freezer problem 1/102893264 solved.

Ben.


