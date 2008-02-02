Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbYBBJNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbYBBJNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbYBBJLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:11:13 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55472 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbYBBJLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:11:01 -0500
Date: Sat, 2 Feb 2008 09:04:08 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Oliver Pinter (Pint?r Oliv?r)" <oliver.pntr@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       Andrea Arcangeli <andrea@suse.de>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [2.6.22.y] {01**/17} - do_anonymous_page-race - series for stable
 kernel
In-Reply-To: <alpine.LFD.1.00.0802021441290.5082@www.l.google.com>
Message-ID: <Pine.LNX.4.64.0802020821490.17733@blonde.site>
References: <6101e8c40802011733y69521724t9e02690419f55201@mail.gmail.com>
 <alpine.LFD.1.00.0802021441290.5082@www.l.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2008, Linus Torvalds wrote:
> On Sat, 2 Feb 2008, Oliver Pinter (Pint?r Oliv?r) wrote:
> >
> > NOT IN MAINLINE
> > 
> > Linus it's go or drop it?
> 
> I have no idea, because you've used some horrible and stupid attachment 
> format that I can't even read. Patches should be inline so that people can 
> see them and comment on them.

Here it is, below, from a more accessible earlier posting by Oliver.
I'd say that this is clearly not suitable to be rushed into stable
ahead of mainline (though it wouldn't do worse than tiny slowdown).

(a) It's from three years ago, what's changed around meanwhile?
(b) It's a mod to bio_endio(), I don't see how it can relate to
    the title's unexplained "do_anonymous_page race" (anonymous?).
(c) If this adds an smp_wmb, where's the corresponding smp_rmb?
(d) Comment doesn't even make sense: a lock_unlock or lock_unlock?

I suspect it relates to the smp_wmb's 2.6.9 added to clear_user_highpage
and copy_user_highpage around the same time (the ones which Nick wishes
to move to SetPageUptodate); maybe that was mainline's preferred answer
to the same problem.

Andrea, if this is still needed, I think it'd be best if you send a
proper description of the problem and argument for your solution to
Andrew cc Nick and Jens, after that it could be considered for stable.

Thanks,
Hugh (who was intrigued by the "do_anonymous_page race" title)

commit 8327e0f191341cc32fb89bf4d7bee7c2524ae4e0
Author: Andrea Arcangeli <andrea@suse.de>
Date:   Mon Jan 28 20:52:29 2008 +0100

    Subject: Race condition in userspace testcase
    References: 46948, LTC11574
    
    
    Additional Comment #103 From Andrea Arcangeli 2004-10-15 19:41
    the last patch I attached is the safest I believe.
    
    I'm not sure if a lock_unlock or lock_unlock is always guaranteed to happen
    after the I/O, and this makes sure no race can happen anymore.

diff --git a/fs/bio.c b/fs/bio.c
index 093345f..984d589 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1028,6 +1028,15 @@ void bio_endio(struct bio *bio, unsigned int bytes_done, int error)
 	bio->bi_size -= bytes_done;
 	bio->bi_sector += (bytes_done >> 9);
 
+	if (bio_data_dir(bio) == READ)
+		/*
+		 * If the current cpu has written to the page by hand
+		 * without dma, we must enforce ordering to be sure
+		 * this written data will be visible before we expose
+		 * the page contents to other cpus (for example with
+		 * a set_pte).
+		 */
+		smp_wmb();
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, bytes_done, error);
 }
