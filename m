Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYGET6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYGET6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 15:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYGET6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 15:58:43 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:53044 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYGET6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 15:58:43 -0400
Message-ID: <486FD270.9030209@skyrush.com>
Date: Sat, 05 Jul 2008 13:58:40 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>	<486E83C3.1040509@skyrush.com>	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>	<871w29s5u2.fsf@basil.nowhere.org>	<20080704221457.1f147225@lxorguk.ukuu.org.uk>	<486E97F2.8020605@firstfloor.org>	<20080704224441.63204bc4@lxorguk.ukuu.org.uk>	<486E9F91.6010701@firstfloor.org>	<20080705113434.41109492@lxorguk.ukuu.org.uk>	<486F543D.8010409@firstfloor.org> <87y74gpkb8.fsf@denkblock.local>
In-Reply-To: <87y74gpkb8.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Now, the situation has become even more delicate. Joe has reported that
> my patch breaks echoing in the xterm and, rather to my embarrassment, I
> have to report that it doesn't even fix the issue I claumed it would.
> All it apparently does is making the problem slightly harder to
> reproduce which is why it didn't occur in my tests at the time.

Elias, thanks for your report.  I could not reproduce the originally
posted test case, but I wrote a small program that continuously produces
output as a test.  One thing I noticed was that the ease of breaking out
of this program is affected quite a bit by other system/CPU activity.
For example, if I was compiling the kernel, it became *easier* to break
out (presumably because the I/O from the test program was getting less
continuous CPU and so therefore the interrupt get "get in").  Similarly,
if I moved the xterm window around on the screen (causing other activity
by doing that) while waiting for the I/O program to terminate after
hitting ^C, it would often break out at that point.

So I do believe that one's subjective impression of how easy it is to
break out of such an I/O-bound program can be affected by the general
state of the system, and therefore it becomes fairly hard to draw a
certain conclusion.

> Since I have been concentrating on other things over the last days, it's
> been only today that I discovered this. Moreover, some more testing lead
> me to believe that the root issue has been present in mainline at least
> since 2.6.19 and Joe's change in 2.6.25 only made it visible because you
> now occasionally get something like
> ^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z

Ah!  Yes, this makes a lot of sense, actually, and is a good example of
a problem masquerading as something else.  Thanks much for this insight.
 Knowing that the problem could have been around pre-2.6.25 is very
useful info as well, and does indeed agree with Alan's thoughts that the
issue is likely caused by something else (VM, scheduler, etc.).

> Quite frankly, I'm a bit at a loss as to how I should go about debugging
> this and what kind of data might be useful to others to do so.

If you can, please try the new patch I attached to the post:

	http://marc.info/?l=linux-kernel&m=121520229900676&w=2

It removes the call to tty_driver_flush_buffer(), which comes right
after n_tty_flush_buffer() in n_tty.c.  It will probably make no
difference, but it would be good to hear either way.  I am not sure if
both calls are needed (if anyone reading this knows why both are called
from n_tty.c, let me know), but I do know that the latter
(tty_driver_flush_buffer) call ends up calling n_tty_flush_buffer as
well, causing two flushes in a row.

And also, if you can, try doing 'stty noflsh' and then the test case
again to see if this alters behavior.  This may be good to know as well,
even if the flush is not centrally involved in the issue.

						Thanks, Joe
