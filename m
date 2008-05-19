Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYESF1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYESF1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYESF1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:27:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbYESF1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:27:12 -0400
From: Neil Brown <neilb@suse.de>
To: "Mike Snitzer" <snitzer@gmail.com>
Date: Mon, 19 May 2008 15:27:01 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18481.4005.570022.160686@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
In-Reply-To: message from Mike Snitzer on Monday May 19
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18464.134.236488.251879@notabene.brown>
	<170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	<18466.39418.578722.92979@notabene.brown>
	<170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	<18467.43895.220708.254814@notabene.brown>
	<170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	<18467.59565.676987.926988@notabene.brown>
	<170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
	<18477.30199.992302.271647@notabene.brown>
	<170fa0d20805182133o46501cc4va81b087fb6b417bf@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 19, snitzer@gmail.com wrote:
> 
> Hi Neil,
> 
> Sorry about not getting back with you sooner.  Thanks for putting
> significant time to chasing this problem.
> 
> I tested your most recent patch and unfortunately still hit the case
> where the nbd member becomes degraded yet the array continues to clear
> bits (events_cleared of the non-degraded member is higher than the
> degraded member).  Is this behavior somehow expected/correct?

It shouldn't be..... ahhh.
There is a delay between noting that the bit can be cleared, and
actually writing the zero to disk.  This is obviously intentional
in case the bit gets set again quickly.
I'm sampling the event count at the latter point instead of the
former, and there is time for it to change.

Maybe this patch on top of what I recently sent out?

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   10 ++++++++--
 ./include/linux/raid/bitmap.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-19 15:23:42.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-19 15:24:56.000000000 +1000
@@ -1092,9 +1092,9 @@ void bitmap_daemon_work(struct bitmap *b
 			/* We are possibly going to clear some bits, so make
 			 * sure that events_cleared is up-to-date.
 			 */
-			if (bitmap->events_cleared < bitmap->mddev->events) {
+			if (bitmap->need_sync) {
 				bitmap_super_t *sb;
-				bitmap->events_cleared = bitmap->mddev->events;
+				bitmap->need_sync = 0;
 				wait_event(bitmap->mddev->sb_wait,
 				    !test_bit(MD_CHANGE_CLEAN,
 					      &bitmap->mddev->flags));
@@ -1273,6 +1273,12 @@ void bitmap_endwrite(struct bitmap *bitm
 			return;
 		}
 
+		if (success &&
+		    bitmap->events_cleared < bitmap->mddev->events) {
+			bitmap->events_cleared = bitmap->mddev->events;
+			bitmap->need_sync = 1;
+		}
+
 		if (!success && ! (*bmc & NEEDED_MASK))
 			*bmc |= NEEDED_MASK;
 

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2008-05-19 15:23:50.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2008-05-19 15:24:56.000000000 +1000
@@ -221,6 +221,7 @@ struct bitmap {
 	unsigned long syncchunk;
 
 	__u64	events_cleared;
+	int need_sync;
 
 	/* bitmap spinlock */
 	spinlock_t lock;
