Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZGQUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZGQUVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZGQUTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:51 -0400
Received: from kroah.org ([198.145.64.141]:43119 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbZGQUTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:34 2009
Message-Id: <20090717201234.071675916@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 15/24] md/raid5: suspend shouldnt affect read requests.
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=md-raid5-suspend-shouldn-t-affect-read-requests.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit a5c308d4d1659b1f4833b863394e3e24cdbdfc6e upstream.

md allows write to regions on an array to be suspended temporarily.
This allows user-space to participate is aspects of reshape.
In particular, data can be copied with not risk of a race.
We should not be blocking read requests though, so don't.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3702,7 +3702,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			/* FIXME what if we get a false positive because these
 			 * are being updated.
 			 */
-			if (logical_sector >= mddev->suspend_lo &&
+			if (bio_data_dir(bi) == WRITE &&
+			    logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
 				release_stripe(sh);
 				schedule();


