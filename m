Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbZCNBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbZCNBbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZCNBU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:27 -0400
Received: from kroah.org ([198.145.64.141]:35029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbZCNBUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:36 2009
Message-Id: <20090314011035.961760837@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 031/114] md/raid10:  Dont skip more than 1 bitmap-chunk at a time during recovery.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=md-raid10-don-t-skip-more-than-1-bitmap-chunk-at-a-time-during-recovery.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 09b4068a7fe442efc40e9dcbcf5ff37c3338ab15 upstream.

When doing recovery on a raid10 with a write-intent bitmap, we only
need to recovery chunks that are flagged in the bitmap.

However if we choose to skip a chunk as it isn't flag, the code
currently skips the whole raid10-chunk, thus it might not recovery
some blocks that need recovering.

This patch fixes it.

In case that is confusing, it might help to understand that there
is a 'raid10 chunk size' which guides how data is distributed across
the devices, and a 'bitmap chunk size' which says how much data
corresponds to a single bit in the bitmap.

This bug only affects cases where the bitmap chunk size is smaller
than the raid10 chunk size.



Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2011,13 +2011,13 @@ static sector_t sync_request(mddev_t *md
 	/* There is nowhere to write, so all non-sync
 	 * drives must be failed, so try the next chunk...
 	 */
-	{
-	sector_t sec = max_sector - sector_nr;
-	sectors_skipped += sec;
+	if (sector_nr + max_sync < max_sector)
+		max_sector = sector_nr + max_sync;
+
+	sectors_skipped += (max_sector - sector_nr);
 	chunks_skipped ++;
 	sector_nr = max_sector;
 	goto skipped;
-	}
 }
 
 static int run(mddev_t *mddev)


