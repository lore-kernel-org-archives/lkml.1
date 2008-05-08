Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbYEHGNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbYEHGNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYEHGN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:13:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:34746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbYEHGNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:13:25 -0400
From: Neil Brown <neilb@suse.de>
To: "Mike Snitzer" <snitzer@gmail.com>
Date: Thu, 8 May 2008 16:13:14 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18466.39418.578722.92979@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
In-Reply-To: message from Mike Snitzer on Tuesday May 6
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18464.134.236488.251879@notabene.brown>
	<170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 6, snitzer@gmail.com wrote:
> 
> It looks like bitmap_update_sb()'s incrementing of events_cleared (on
> behalf of the local member) could be racing with the fact that the NBD
> member becomes faulty (whereby making the array degraded).  This
> allows the events_cleared to reflect a clean->dirty transition last
> occurred before the array became degraded.  My reasoning is: If it was
> a clean->dirty transition the bitmap still has the associated dirty
> bit set in the local member's bitmap, so using the bitmap to resync is
> valid.
> 
> thanks,
> Mike

Thanks for persisting.  I think I understand what is going on now.

How about this patch?  It is similar to your, but instead of depending
on the odd/even state of the event counter, it directly checks the
clean/dirty state of the array.

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-02 14:49:05.000000000 +1000
+++ ./drivers/md/md.c	2008-05-08 16:10:48.000000000 +1000
@@ -843,6 +843,8 @@ static int super_90_validate(mddev_t *md
 		/* if adding to array with a bitmap, then we can accept an
 		 * older device ... but not too old.
 		 */
+		if (sb->state & (1<<MD_SB_CLEAN))
+			ev1++;
 		if (ev1 < mddev->bitmap->events_cleared)
 			return 0;
 	} else {
@@ -1218,6 +1220,9 @@ static int super_1_validate(mddev_t *mdd
 		/* If adding to array with a bitmap, then we can accept an
 		 * older device, but not too old.
 		 */
+		if (mddev->recovery_cp == MaxSector)
+			/* array was clean, so can allow 'next' event */
+			ev1++;
 		if (ev1 < mddev->bitmap->events_cleared)
 			return 0;
 	} else {
