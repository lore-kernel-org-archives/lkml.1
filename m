Return-Path: <linux-kernel-owner+w=401wt.eu-S935227AbXHGVGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227AbXHGVGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935728AbXHGUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:52:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56475 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935723AbXHGUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:52:47 -0400
Date: Tue, 7 Aug 2007 13:46:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, neilb@suse.de, agr@powerkom-dd.de
Subject: [2.6.22.2 review 38/84] md: handle writes to broken raid10 arrays
	gracefully
Message-ID: <20070807204601.GN23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-handle-writes-to-broken-raid10-arrays-gracefully.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arne Redlich <agr@powerkom-dd.de>

When writing to a broken array, raid10 currently happily emits empty bio
lists.  IOW, the master bio will never be completed, sending writers to
UNINTERRUPTIBLE_SLEEP forever.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -917,6 +917,13 @@ static int make_request(request_queue_t 
 		bio_list_add(&bl, mbio);
 	}
 
+	if (unlikely(!atomic_read(&r10_bio->remaining))) {
+		/* the array is dead */
+		md_write_end(mddev);
+		raid_end_bio_io(r10_bio);
+		return 0;
+	}
+
 	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);

-- 
