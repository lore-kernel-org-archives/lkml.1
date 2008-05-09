Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbYEIBke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbYEIBke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763589AbYEIBkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:40:21 -0400
Received: from ns.suse.de ([195.135.220.2]:58753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbYEIBkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:40:18 -0400
From: Neil Brown <neilb@suse.de>
To: "Mike Snitzer" <snitzer@gmail.com>
Date: Fri, 9 May 2008 11:40:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18467.43895.220708.254814@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
In-Reply-To: message from Mike Snitzer on Thursday May 8
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18464.134.236488.251879@notabene.brown>
	<170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	<18466.39418.578722.92979@notabene.brown>
	<170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 8, snitzer@gmail.com wrote:
> On Thu, May 8, 2008 at 2:13 AM, Neil Brown <neilb@suse.de> wrote:
> > On Tuesday May 6, snitzer@gmail.com wrote:
> >  >
> >  > It looks like bitmap_update_sb()'s incrementing of events_cleared (on
> >  > behalf of the local member) could be racing with the fact that the NBD
> >  > member becomes faulty (whereby making the array degraded).  This
> >  > allows the events_cleared to reflect a clean->dirty transition last
> >  > occurred before the array became degraded.  My reasoning is: If it was
> >  > a clean->dirty transition the bitmap still has the associated dirty
> >  > bit set in the local member's bitmap, so using the bitmap to resync is
> >  > valid.
> >  >
> >  > thanks,
> >  > Mike
> >
> >  Thanks for persisting.  I think I understand what is going on now.
> >
> >  How about this patch?  It is similar to your, but instead of depending
> >  on the odd/even state of the event counter, it directly checks the
> >  clean/dirty state of the array.
> 
> Hi Neil,
> 
> Your revised patch works great and is obviously cleaner.

But I'm still not happy with it :-(
I suspect there might be other cases where it will still do the wrong
thing.
The real problem is that we are updating events_cleared to early.  We
are setting to the new event counter before that is even written out.

So I've come up with this patch, which I think more clearly
encapsulated what events_cleared means.  It is now set to the current
'events' counter immediately before we clear any bit.

If you could test it, I'd really appreciate it.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-09 11:02:13.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-09 11:38:35.000000000 +1000
@@ -465,8 +465,6 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (!bitmap->mddev->degraded)
-		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1094,9 +1092,19 @@ void bitmap_daemon_work(struct bitmap *b
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
+			if (bitmap->events_cleared < bitmap->mddev->events) {
+				bitmap_super_t *sb;
+				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				bitmap->events_cleared = bitmap->mddev->events;
+				sb->events_cleared =
+					cpu_to_le64(bitmap->events_cleared);
+				kunmap_atomic(sb, KM_USER0);
+				write_page(bitmap, bitmap->sb_page, 1);
+			}
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
