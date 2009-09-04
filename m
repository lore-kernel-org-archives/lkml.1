Return-Path: <linux-kernel-owner+w=401wt.eu-S932315AbZIDBlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbZIDBlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZIDBlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:41:23 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54392 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZIDBlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:41:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<87pra89sgp.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org>
Date: Fri, 04 Sep 2009 10:41:20 +0900
In-Reply-To: <alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 3 Sep 2009 14:01:54 -1000 (HST)")
Message-ID: <87ab1bmqpr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 3 Sep 2009, OGAWA Hirofumi wrote:
>> 
>> If I'm not missing, I think it doesn't have big change with old
>> code. But I would need to check more deeply.
>
> The thing is, the old pty code pushed _directly_ to the receiving ldisc, 
> with no buffering.

Yes.

> I'm not entirely sure why Alan felt it needed changing, 
> but moving over to the generic tty buffering code did get rid of some 
> duplicate logic, and the locking is now done in one place, so that's 
> probably the main reason.

IIRC, ppp had the locking issue without that patch?

> Anyway, the old pty code would be entirely synchronous, and would do the 
>
> 	ld->ops->receive_buf(to, buf, NULL, c);
>
> to push the data all the way to the receive side frm pty_write(). So with 
> the old code, the destination "receive_room" was always accurate, because 
> both the reading side and the writing side basically accessed it directly.
>
> With the new code, it all goes through tty_buffer.c, and the bugs have 
> been mostly about the receiving side not seeing all the data in the 
> buffers. And those buffers simply didn't use to exist before.

Yes. However, pty_write() checks tty_buffer instead of receive_room. So
I thought, the change of write side is mainly buffer size (receive_room
size + tty_buffer size). It will stop after filling tty_buffer, not
receive_room.

And (I hope) the read side guarantees to consume both buffers. If it is
right, I guessed the change is timing issues with more larger buffer
size.

>> Um.., If "receive_room == 0 && tty->read_cnt == 0" is possible, I wonder
>> why reverting buffer handling fixes the problem.
>
> In the old code, if 'receive_room' was zero, then the writer would simply 
> stop writing (no buffers in between). So in the old code, you could never 
> get into a situation where receive_room was zero and there was still 
> pending data.
>
> At least that's how I read the situation.

Another possibility in my guess is the change of pty_flush_buffer() and
pty_chars_in_buffer().  I'm not sure at all though, especially, I'm
suspecting pty_flush_buffer() may change the behaviors.

> If I'm right, I'm hoping that the patch I sent out fixes it, and if so, 
> we'll do that for 2.6.31 (and then after that maybe re-think whether the 
> extra buffering is worth all this pain).

I also hope it works.

> And if it _doesn't_ fix it, then I think we'll just have to revert the 
> commits in question. We won't have time to root-cause it if the above 
> isn't it.

At least for me, it sounds like good if revert works. I have no
preference about it.

FWIW, meanwhile, I'll just try to see the root-cause of this as
another/fallback solution.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
