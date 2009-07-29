Return-Path: <linux-kernel-owner+w=401wt.eu-S1751394AbZG2Rk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbZG2Rk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZG2Rk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:40:56 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:37805 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZG2Rkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:40:55 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 13:40:38 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3; KDE/4.2.4; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
 <20090729120704.3299ff2e@lxorguk.ukuu.org.uk>
In-reply-to: <20090729120704.3299ff2e@lxorguk.ukuu.org.uk>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907291340.38620.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Alan Cox wrote:
>On Tue, 28 Jul 2009 21:49:05 -0700 (PDT)
>
>Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Tue, 28 Jul 2009, Gene Heskett wrote:
>> > It doesn't seem to do anything for bz 13841 here.  Sorry, I wish it did.
>>
>> No, bz 13841 isn't about pty's, it's about usb serial. The patches in this
>> thread would mainly be pty-related, and would affect other tty drivers
>> (like your usb one) only purely by chance.
>>
>> could you bisect the 13841 behavior?
>
>See the thread in 13821 on linux-usb list which extends from the "why do
>we leak ttyUSB numbers" into this as well. Its been pinned down and the in
>tree fix is confirmed to do the job for that case. Not perfectly because
>it needs a further small fix as
>
>a) it should call drv->close() within the mutex on the error path if the
>tty_block_til_ready() fails without which you get a leak on a few drivers
>but nothing too harmful. (Noted by Alan Stern inspecting the patch)
>
>b) it fails the 'variable frequency generator on carrier pin' test - but
>that isn't a regression as such as all 2.6 kernels I've tried crash
>during that test with USB.  (Running my 'extreme violence' test setup)
>
>I suspect that doing
>
>        retval = tty_port_block_til_ready(&port->port, tty, filp);
>        if (retval == 0) {
>                if (!first)
>                        usb_serial_put(serial);
>                return 0;
>        }
>        mutex_lock(&port->mutex);
>
>
>	if (tty_hung_up_p(filp)) {
>		mutex_unlock(&port->mutex);
>		return retval;
>	}
>	dev->close(port);
>
>	...
>
>fixes both. The race basically is
>
>		open
>		drop mutex so we can wait for the port
>		wait for the port
>						[hangup]
>						[serial_do_down]
>		block_til_ready reports an error
>		take mutex
>			duplicate serial_do_down
>
>
>Most serial drivers don't try and do open clean up in open() instead they
>do it in close() which is called by the tty layer on an open failure
>(always has been) and which turns out to be a useful design
>decision as it means the driver doesn't have to tie itself in knots and
>tty_port_close_start() handles all the mechanics. Plus they use
>ASYNC_INITIALIZED as flag to avoid double shutdowns on a device.
>
>Simply deleting most of the clean up from serial_open and letting close()
>do its job would I think clean that up no end but not in an -rc perhaps.

I have now done a bisect, but I'm not convinced its correct.  Since the 
./configure line didn't work in that tutorial, I fell back to using my own 
"makeit" script which largely automates the build and installation of a 
kernel, all I have to do is make sure its internal $VER matches what is in the 
Makefile.

And there by hangs the tail of some mistakes.  As I ran the bisect, the 
Makefile regressed all the way to 2.6.30 and screwed up my make a few times 
because the Makefile version was not stable from bisect run to bisect run.
The final, no choices left reboot was bad cuz it Ooops when that script was 
run the last 3 times, but there were no choices left to try.
Here is that 'git bisect log >../bisect-final.log'

git bisect start
# good: [6847e154e3cd74fca6084124c097980a7634285a] Linux 2.6.31-rc3
git bisect good 6847e154e3cd74fca6084124c097980a7634285a
# bad: [4be3bd7849165e7efa6b0b35a23d6a3598d97465] Linux 2.6.31-rc4
git bisect bad 4be3bd7849165e7efa6b0b35a23d6a3598d97465
# bad: [ae42b9e1ca8969d52e51f5e461b2e89e180943dd] Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin
git bisect bad ae42b9e1ca8969d52e51f5e461b2e89e180943dd
# bad: [301d95c4dade09388f94258ee797d2d650dc00b5] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
git bisect bad 301d95c4dade09388f94258ee797d2d650dc00b5
# bad: [301d95c4dade09388f94258ee797d2d650dc00b5] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
git bisect bad 301d95c4dade09388f94258ee797d2d650dc00b5
# good: [e9e961c9a818a2f24711af493b907a8e40a69efc] Merge branch 'i2c-for-2631-
rc3' of git://aeryn.fluff.org.uk/bjdooks/linux
git bisect good e9e961c9a818a2f24711af493b907a8e40a69efc
# good: [63f7a330014ad29b662638caabd8e96fe945b9ed] Merge branch 'timers-fixes-
for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 63f7a330014ad29b662638caabd8e96fe945b9ed
# bad: [b983d0deb0e28f8880cdea79def575d96a27e603] Merge branch 'tracing-fixes-
for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad b983d0deb0e28f8880cdea79def575d96a27e603
# bad: [c20b08e3986c2dbfa6df1e880bf4f7159994d199] sched: Fix rt_rq-
>pushable_tasks initialization in init_rt_rq()
git bisect bad c20b08e3986c2dbfa6df1e880bf4f7159994d199
# bad: [a1ba4d8ba9f06a397e97cbd67a93ee306860b40a] sched_rt: Fix overload bug 
on rt group scheduling
git bisect bad a1ba4d8ba9f06a397e97cbd67a93ee306860b40a

What is needed for a mistake free bisect is a 'doesn't matter as long as it 
matches' Makefile version that survives all the way through a bisect run.  
When I was done, I had to go back to my own 2.6.30 and 2.6.31-rc3 trees and do 
a full rebuild and reinstall in order to have a clean boot newer that 2.6.29.

Because of these errors, and the fact that the final 3 2.6.30's it built were 
bad, I am not convinced I have a valid bisect, particularly since the final 3 
builds were called 2.6.30, and they were all=bad because of an Oopsen at the 
scripts invocation from rc.local, not the i/o error that makes it loop forever 
using 98+% of all 4 cores in my phenom and thrashing the disk a bit.

If this version thing can be handled in a cleaner manner, I'll be glad to 
repeat the bisect from scratch, it turns out not to be as complex as I feared.

As it stands, its a pita because its destroying perfect good fallback boot 
setups.  I should be able to set the extraversion to -rc3.5 in both the 
Makefile and in my makeit script, and run the whole bisect without molesting 
the rest of the system, creating one set of bootfiles that are simply 
overwritten with the next bisect run. 

Thanks for listening to the rant.  What do I do next?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Every program has (at least) two purposes:
	the one for which it was written and another for which it wasn't.

