Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZICL3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZICL3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 07:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZICL3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 07:29:49 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:56376 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZICL3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 07:29:48 -0400
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
Date: Thu, 03 Sep 2009 20:29:42 +0900
In-Reply-To: <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 2 Sep 2009 15:23:28 -1000 (HST)")
Message-ID: <87pra89sgp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 1 Sep 2009, Rafael J. Wysocki wrote:
>> On Tuesday 01 September 2009, Mikael Pettersson wrote:
>> > 
>> > Starting with 2.6.31-rc8 and reverting
>> > 
>> > 85dfd81dc57e8183a277ddd7a56aa65c96f3f487 pty: fix data loss when stopped (^S/^Q)
>> > d945cb9cce20ac7143c2de8d88b187f62db99bdc pty: Rework the pty layer to use the normal buffering logic
>> > 
>> > in that order gives me a kernel that works on both x86 and powerpc64.
>> > 
>> > So the bug is definitely limited to the pty buffering logic change.
>> 
>> Thanks a lot for this information, adding somme CCs to the list.
>
> Mikael, is there any way to get the gcc testsuite to show the "expected" 
> vs "result" cases when the failures occur, so that we can see what the 
> pattern is ("it drops one character every 8kB" or something like that).
>
> However, I get the feeling that it's really the same bug that 
> OGAWA-san already fixed - and that his fix just doesn't always do a 100% 
> of the job. 
>
> So what Ogawa did was to make sure that we flush any pending data whenever 
> we;re checking "do we have any data left". He did that by calling out to 
> tty_flush_to_ldisc(), which should flush the data through to the ldisc. 
>
> The keyword here being "should". In flush_to_ldisc(), we have at least one 
> case where we say "we'll delay it a bit more":
>
> 		if (!tty->receive_room) {
> 			schedule_delayed_work(&tty->buf.work, 1);
> 			break;
> 		}
>
> and while I think this _should_ be ok (because if there is no 
> receive-room, then we'll hopefully always return non-zero from 
> "input_available_p()". However, we do have this really odd case that the 
> reader side will do "n_tty_set_room()" onlyl _after_ having checked for 
> input_available_p(), and so maybe we do sometimes trigger the case that
>
>  - input_available_p() tries to flush to the input buffer before checking 
>    how much data is available, by calling 'tty_flush_to_ldisc()'
>
>  - but 'tty_flush_to_ldisc()' won't do anything, because tty->receive_room 
>    is zero.
>
>  - so now input_available_p will say "I don't have any data", even though 
>    there was data in the write buffers.
>
>  - we'll notice that the other end has hung up, and return EOF/EIO.
>
>  - which is very WRONG, because the other end may have hung up, but before 
>    it did that, it wrote data that is still in the write queues, and we 
>    should have returned that data.
>
> Anyway, I'm not at all sure that the "receive_room == 0" case can happen 
> at all, but maybe it can. Ogawa-san?

If I'm not missing, I think it doesn't have big change with old
code. But I would need to check more deeply.

Um.., If "receive_room == 0 && tty->read_cnt == 0" is possible, I wonder
why reverting buffer handling fixes the problem.

Well, anyway, I'd like to reproduce this on my machine. Could you tell
me the version of tools? I guess gcc testsuite using the gcc's source
(svn revision?), expect, dejagnu, tcl. (BTW, I'm using debian
testing. If it can be reproduced on kvm, I can install distro version
which you are using)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
