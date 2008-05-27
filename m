Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYE0G40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYE0G40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYE0G4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:56:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:55096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYE0G4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:56:12 -0400
From: Neil Brown <neilb@suse.de>
To: "Mike Snitzer" <snitzer@gmail.com>
Date: Tue, 27 May 2008 16:56:03 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18491.45187.557090.225552@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
In-Reply-To: message from Mike Snitzer on Tuesday May 20
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18466.39418.578722.92979@notabene.brown>
	<170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	<18467.43895.220708.254814@notabene.brown>
	<170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	<18467.59565.676987.926988@notabene.brown>
	<170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
	<18477.30199.992302.271647@notabene.brown>
	<170fa0d20805182133o46501cc4va81b087fb6b417bf@mail.gmail.com>
	<18481.4005.570022.160686@notabene.brown>
	<170fa0d20805200830w184709dch221f8b9636f3bc0e@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 20, snitzer@gmail.com wrote:
> 
> Hi Neil,
> 
> We're much closer.  The events_cleared is symmetric on both the failed
> and active member of the raid1.  But there have been some instances
> where the md thread hits a deadlock during my testing.  What follows
> is the backtrace and live crash info:
...
> 
> So running with your latest patches seems to introduce a race in
> bitmap_daemon_work's if (unlikely((*bmc & COUNTER_MAX) ==
> COUNTER_MAX)) { } block.

As you not, that block is in the wrong place.
It is actually locking up in 
				wait_event(bitmap->mddev->sb_wait,
				    !test_bit(MD_CHANGE_CLEAN,
					      &bitmap->mddev->flags));

which the patch adds.  However with my last update that wait_event
isn't needed any more.  I was using it to ensure mddev->events matched
what was on disk.  But we now read mddev->events much earlier and it
will definitely be on disc by this time.

So: this combined patch should do it.

Thanks for all your testing.

NeilBrown


---------------------------
Improve setting of "events_cleared" for write-intent bitmaps.

When an array is degraded, bits in the write-intent bitmap are not
cleared, so that if the missing device is re-added, it can be synced
by only updated those parts of the device that have changed since
it was removed.

The enable this a 'events_cleared' value is stored. It is the event
counter for the array the last time that any bits were cleared.

Sometimes - if a device disappears from an array while it is 'clean' -
the events_cleared value gets updated incorrectly (there are subtle
ordering issues between updateing events in the main metadata and the
bitmap metadata) resulting in the missing device appearing to require
a full resync when it is re-added.

With this patch, we update events_cleared precisely when we are about
to clear a bit in the bitmap.  We record events_cleared when we clear
the bit internally, and copy that to the superblock which is written
out before the bit on storage.  This makes it more "obviously correct".

We also need to update events_cleared when the event_count is going
backwards (as happens on a dirty->clean transition of a non-degraded
array).

Thanks to Mike Snitzer for identifying this problem and testing early
"fixes".


Cc:  "Mike Snitzer" <snitzer@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   29 ++++++++++++++++++++++++-----
 ./include/linux/raid/bitmap.h |    1 +
 2 files changed, 25 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-27 16:50:04.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-27 16:50:53.000000000 +1000
@@ -454,8 +454,11 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (!bitmap->mddev->degraded)
-		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
+	if (bitmap->mddev->events < bitmap->events_cleared) {
+		/* rocking back to read-only */
+		bitmap->events_cleared = bitmap->mddev->events;
+		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
+	}
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1085,9 +1088,19 @@ void bitmap_daemon_work(struct bitmap *b
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
-/*
-			printk("bitmap clean at page %lu\n", j);
-*/
+
+			/* We are possibly going to clear some bits, so make
+			 * sure that events_cleared is up-to-date.
+			 */
+			if (bitmap->need_sync) {
+				bitmap_super_t *sb;
+				bitmap->need_sync = 0;
+				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				sb->events_cleared =
+					cpu_to_le64(bitmap->events_cleared);
+				kunmap_atomic(sb, KM_USER0);
+				write_page(bitmap, bitmap->sb_page, 1);
+			}
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
@@ -1257,6 +1270,12 @@ void bitmap_endwrite(struct bitmap *bitm
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
--- .prev/include/linux/raid/bitmap.h	2008-05-26 09:46:04.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2008-05-27 16:50:19.000000000 +1000
@@ -221,6 +221,7 @@ struct bitmap {
 	unsigned long syncchunk;
 
 	__u64	events_cleared;
+	int need_sync;
 
 	/* bitmap spinlock */
 	spinlock_t lock;
