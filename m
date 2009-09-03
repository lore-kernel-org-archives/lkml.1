Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZICBYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZICBYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZICBYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:24:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023AbZICBYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:24:31 -0400
Date: Wed, 2 Sep 2009 15:23:28 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <200909012042.59856.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Sep 2009, Rafael J. Wysocki wrote:
> On Tuesday 01 September 2009, Mikael Pettersson wrote:
> > 
> > Starting with 2.6.31-rc8 and reverting
> > 
> > 85dfd81dc57e8183a277ddd7a56aa65c96f3f487 pty: fix data loss when stopped (^S/^Q)
> > d945cb9cce20ac7143c2de8d88b187f62db99bdc pty: Rework the pty layer to use the normal buffering logic
> > 
> > in that order gives me a kernel that works on both x86 and powerpc64.
> > 
> > So the bug is definitely limited to the pty buffering logic change.
> 
> Thanks a lot for this information, adding somme CCs to the list.

Mikael, is there any way to get the gcc testsuite to show the "expected" 
vs "result" cases when the failures occur, so that we can see what the 
pattern is ("it drops one character every 8kB" or something like that).

However, I get the feeling that it's really the same bug that 
OGAWA-san already fixed - and that his fix just doesn't always do a 100% 
of the job. 

So what Ogawa did was to make sure that we flush any pending data whenever 
we;re checking "do we have any data left". He did that by calling out to 
tty_flush_to_ldisc(), which should flush the data through to the ldisc. 

The keyword here being "should". In flush_to_ldisc(), we have at least one 
case where we say "we'll delay it a bit more":

		if (!tty->receive_room) {
			schedule_delayed_work(&tty->buf.work, 1);
			break;
		}

and while I think this _should_ be ok (because if there is no 
receive-room, then we'll hopefully always return non-zero from 
"input_available_p()". However, we do have this really odd case that the 
reader side will do "n_tty_set_room()" onlyl _after_ having checked for 
input_available_p(), and so maybe we do sometimes trigger the case that

 - input_available_p() tries to flush to the input buffer before checking 
   how much data is available, by calling 'tty_flush_to_ldisc()'

 - but 'tty_flush_to_ldisc()' won't do anything, because tty->receive_room 
   is zero.

 - so now input_available_p will say "I don't have any data", even though 
   there was data in the write buffers.

 - we'll notice that the other end has hung up, and return EOF/EIO.

 - which is very WRONG, because the other end may have hung up, but before 
   it did that, it wrote data that is still in the write queues, and we 
   should have returned that data.

Anyway, I'm not at all sure that the "receive_room == 0" case can happen 
at all, but maybe it can. Ogawa-san?

Here's a totally untested trial patch. I only have this dead-slow netbook  
for reading email with me, and I don't have a failing test-case anyway, 
but if my analysis is right, then the patch might fix it. It just forces 
the re-calculation of the receive buffer before flushing the ldisc.

(And btw, from a performance standpoint, it might make more sense to only 
do this whole read-room / ldisc-flush thing if we are about to return 
zero. If we already have data available, we probably shouldn't waste time 
trying to see if we need to do anything fancy like this.)

CAVEAT EMPTOR. Not tested. It compiled for me, but maybe that was due to 
me compiling the wrong file or something.

		Linus

---
 drivers/char/n_tty.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 973be2f..7fa3452 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1583,6 +1583,7 @@ static int n_tty_open(struct tty_struct *tty)
 
 static inline int input_available_p(struct tty_struct *tty, int amt)
 {
+	n_tty_set_room(tty);
 	tty_flush_to_ldisc(tty);
 	if (tty->icanon) {
 		if (tty->canon_data)
