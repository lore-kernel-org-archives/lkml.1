Return-Path: <linux-kernel-owner+w=401wt.eu-S935456AbXGQUi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456AbXGQUi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbXGQUiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:38:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbXGQUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:38:19 -0400
Date: Tue, 17 Jul 2007 13:37:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Markus <lists4me@web.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] CFS scheduler, -v19
In-Reply-To: <20070717200929.GA2426@elte.hu>
Message-ID: <alpine.LFD.0.999.0707171329370.27353@woody.linux-foundation.org>
References: <20070706173319.GA2356@elte.hu> <200707171506.37886.lists4me@web.de>
 <20070717170628.GA6002@elte.hu> <200707172142.42008.lists4me@web.de>
 <20070717200929.GA2426@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Ingo Molnar wrote:
> 
> i think the problem starts here:
> 
>   11902 1184699865.141939 read(3, "", 32) = 0 <0.000007>

Well, it's preceded by a poll() that says that it has a POLLHUP event, so 
that socket would seem to have simply been closed from the other end. 
There's also a huge amount of select() calls showing the same thing 
(except since it's just the input side, you cannot tell that it's 
POLLHUP).

Don't ask me *why*, though. It's preceded by

	..
	11902 1184699848.615201 read(3, 0x7fffb5b9c8b0, 32) = -1 EAGAIN (Resource temporarily unavailable) <0.000009>
	11902 1184699848.615252 poll([{fd=3, events=POLLIN, revents=POLLIN}], 1, -1) = 1 <0.009307>
	11902 1184699848.624614 read(3, "\1 \303!\0\0\0\0\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0b\340T\0\0\0\0\0", 32) = 32 <0.000011>

.. got data ..

	11902 1184699848.624710 ioctl(3, FIONREAD, [0]) = 0 <0.000009>
	11902 1184699848.624762 ioctl(3, FIONREAD, [0]) = 0 <0.000048>

.. ok, nothing more..

	11902 1184699848.624866 select(10, [3 4 5 7 9], [], [], NULL) = 1 (in [3]) <16.495008>
	11902 1184699865.119950 ioctl(3, FIONREAD, [0]) = 0 <0.000006>

16+ seconds pass, now it's marked as readable, but returns zero bytes of 
data: the other end closed it.

Tons of unnecessary and stupid sequences of:

	11902 1184699865.119988 select(10, [3 4 5 7 9], [], [], NULL) = 1 (in [3]) <0.000007>
	11902 1184699865.120031 ioctl(3, FIONREAD, [0]) = 0 <0.000005>
	..

and then finally:

	...
	11902 1184699865.141809 poll([{fd=3, events=POLLIN, revents=POLLIN|POLLHUP}], 1, 0) = 1 <0.000005>
	11902 1184699865.141838 ioctl(3, FIONREAD, [0]) = 0 <0.000005>
	11902 1184699865.141939 read(3, "", 32) = 0 <0.000007>

ie now konqueror noticed that it was *really* closed, and read the EOF.

But why does that happen? And why would the scheduler have *anything* to 
do with this? No idea. Maybe timing. Maybe the time.c changes. Dunno.

		Linus
