Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXEEToN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXEEToN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbXEEToN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:44:13 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:43516 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbXEEToM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:44:12 -0400
X-Greylist: delayed 1790 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 15:44:12 EDT
Date: Sat, 5 May 2007 21:17:07 +0200
From: Clifford Wolf <clifford@clifford.at>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Interrupt-Handling in User Space
Message-ID: <20070505191707.GA9300@clifford.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

afaics there is no mechanism in the official kernel tree to handle
interrupts in user space yet. I'd need that for an embedded project I'm
woking on atm and are so far not sure if I'm going to implement such a
generic interface or just write a simple driver that does the job for my
application. So I'd like to find out what the chances are that such a
feature will get accepted in the official kernel..

Rationale: I'm not a fried of 'device drivers in userland'. But sometimes
one wants to talk to the hardware directly without anything like a 'device
driver' at all (e.g. for hardwaretesting, prototyping and debugging). In
my application I have my hardware block memory mmapped in the application
using /dev/mem to avoid additional copying steps between kernel and
userland. All I need now is an easy way to handle interrupts in my
application.

My plan is to extend drivers/char/mem.c to implement an additional /dev/irq
device file with the following ICOTLs:

IOCTL_IRQ_REGISTER
	Integer argument: Interrupt Number
	Must be the first ioctl issued after opening the device file. It
	registeres an interrupt handler which is associated with the fd
	and gets unregisteredwhen the fd is closed.

IOCTL_IRQ_AUTHORITIVE
	Argument is ignored
	Usually the interrupt handler returns IRQ_NONE. After this ioctl
	has been called it returns IRQ_HANDLED instead.

IOCTL_IRQ_FLUSH
	Argument is ignored.
	Returns the number of interrupts since the last IOCTL_IRQ_FLUSH,
	IOCTL_IRQ_WAIT or read() call.

IOCTL_IRQ_WAIT
	Argument is ignored.
	Returns without blocking if there have been any interrupts since
	the last IOCTL_IRQ_FLUSH or IOCTL_IRQ_WAIT call or blocks until
	the next interrupt otherwise.
	Returns the number of interrupts since the last IOCTL_IRQ_FLUSH,
	IOCTL_IRQ_WAIT or read() call.

Reading from the device file has the same effect as calling IOCTL_IRQ_WAIT
when reading in blocking or IOCTL_IRQ_FLUSH when reading in non-blocking
mode. When the read buffer len is 4 or more and there have been any
interrupts the first 4 bytes are filled with the number of interrupts
since the last IOCTL_IRQ_FLUSH, IOCTL_IRQ_WAIT or read() call and 4 is
returned. Using select() or epoll() will also be possible. Reading returns
zero (EOF) when there haven't been any interrupts and the read is
non-blocking.

What do you think? Any arguments against approach? Does anyone else also
feel the need for something like that in the kernel?

yours,
 - clifford

-- 
Once you have something that grows faster than education grows, you're
always going to get a pop culture. -- Alan Kay
