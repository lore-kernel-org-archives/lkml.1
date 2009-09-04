Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZIDACY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZIDACY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 20:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZIDACX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 20:02:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756574AbZIDACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 20:02:22 -0400
Date: Thu, 3 Sep 2009 14:01:54 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <87pra89sgp.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <87pra89sgp.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Sep 2009, OGAWA Hirofumi wrote:
> 
> If I'm not missing, I think it doesn't have big change with old
> code. But I would need to check more deeply.

The thing is, the old pty code pushed _directly_ to the receiving ldisc, 
with no buffering. I'm not entirely sure why Alan felt it needed changing, 
but moving over to the generic tty buffering code did get rid of some 
duplicate logic, and the locking is now done in one place, so that's 
probably the main reason.

Anyway, the old pty code would be entirely synchronous, and would do the 

	ld->ops->receive_buf(to, buf, NULL, c);

to push the data all the way to the receive side frm pty_write(). So with 
the old code, the destination "receive_room" was always accurate, because 
both the reading side and the writing side basically accessed it directly.

With the new code, it all goes through tty_buffer.c, and the bugs have 
been mostly about the receiving side not seeing all the data in the 
buffers. And those buffers simply didn't use to exist before.

> Um.., If "receive_room == 0 && tty->read_cnt == 0" is possible, I wonder
> why reverting buffer handling fixes the problem.

In the old code, if 'receive_room' was zero, then the writer would simply 
stop writing (no buffers in between). So in the old code, you could never 
get into a situation where receive_room was zero and there was still 
pending data.

At least that's how I read the situation.

If I'm right, I'm hoping that the patch I sent out fixes it, and if so, 
we'll do that for 2.6.31 (and then after that maybe re-think whether the 
extra buffering is worth all this pain).

And if it _doesn't_ fix it, then I think we'll just have to revert the 
commits in question. We won't have time to root-cause it if the above 
isn't it.

		Linus
