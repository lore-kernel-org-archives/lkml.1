Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYGVXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYGVXUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYGVXR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:59 -0400
Received: from mail.suse.de ([195.135.220.2]:52780 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbYGVXR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:57 -0400
Date: Tue, 22 Jul 2008 16:14:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Brown <neilb@suse.de>
Subject: [patch 08/47] md: Ensure interrupted recovery completed properly
	(v1 metadata plus bitmap)
Message-ID: <20080722231442.GI8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-ensure-interrupted-recovery-completed-properly.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Neil Brown <neilb@notabene.brown>

commit 8c2e870a625bd336b2e7a65a97c1836acef07322 upstream

If, while assembling an array, we find a device which is not fully
in-sync with the array, it is important to set the "fullsync" flags.
This is an exact analog to the setting of this flag in hot_add_disk
methods.

Currently, only v1.x metadata supports having devices in an array
which are not fully in-sync (it keep track of how in sync they are).
The 'fullsync' flag only makes a difference when a write-intent bitmap
is being used.  In this case it tells recovery to ignore the bitmap
and recovery all blocks.

This fix is already in place for raid1, but not raid5/6 or raid10.

So without this fix, a raid1 ir raid4/5/6 array with version 1.x
metadata and a write intent bitmaps, that is stopped in the middle
of a recovery, will appear to complete the recovery instantly
after it is reassembled, but the recovery will not be correct.

If you might have an array like that, issueing
   echo repair > /sys/block/mdXX/md/sync_action

will make sure recovery completes properly.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |    2 ++
 drivers/md/raid5.c  |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2102,6 +2102,8 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
+			if (disk->rdev)
+				conf->fullsync = 1;
 		}
 	}
 
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4166,7 +4166,9 @@ static int run(mddev_t *mddev)
 				" disk %d\n", bdevname(rdev->bdev,b),
 				raid_disk);
 			working_disks++;
-		}
+		} else
+			/* Cannot rely on bitmap to complete recovery */
+			conf->fullsync = 1;
 	}
 
 	/*

-- 
