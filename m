Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZIDBws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZIDBws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZIDBwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:52:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbZIDBwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:52:46 -0400
Date: Thu, 3 Sep 2009 15:52:16 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <87ab1bmqpr.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.0909031545010.16579@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <87pra89sgp.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org> <87ab1bmqpr.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, OGAWA Hirofumi wrote:
> 
> Yes. However, pty_write() checks tty_buffer instead of receive_room. So
> I thought, the change of write side is mainly buffer size (receive_room
> size + tty_buffer size).

The problem has never been the write side. That side works - just with 
extra buffering.

> It will stop after filling tty_buffer, not receive_room.

Yes.

> And (I hope) the read side guarantees to consume both buffers. If it is
> right, I guessed the change is timing issues with more larger buffer
> size.

That's the change. The read side only consumes the buffers it _sees_. And 
it doesn't look at the buffers that the write side has written, only at 
the 'received' buffers. That's why we had to add that 'tty_flush_to_ldisc' 
so that the buffers that got written were properly moved to the receive 
side.

And that's the part that I suspect is broken - ie tty_flush_to_ldisc 
doesn't always guarantee that it moves all the written stuff to the 
receive side.

Before, this wasn't an issue, because the writer always filled up the 
receive buffers directly, so there was never any flushing issues.

> Another possibility in my guess is the change of pty_flush_buffer() and
> pty_chars_in_buffer().  I'm not sure at all though, especially, I'm
> suspecting pty_flush_buffer() may change the behaviors.

I don't think 'pty_flush_buffer()' is ever called in any normal 
circumstances. Afaik, it's only called for a TIOCFLUSH ioctl (or whatever 
it's called) when the user asks for all the contents to be thrown away.

> FWIW, meanwhile, I'll just try to see the root-cause of this as
> another/fallback solution.

Absolutely. If you can find some other possibility, that would be great. 
I'm not really sure how that 'receive_room == 0' case would ever happen in 
practice, so my patch was really based on the assumption that the bug is 
in the flushing code.

The bug could easily be elsewhere.

		Linus
