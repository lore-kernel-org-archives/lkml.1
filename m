Return-Path: <linux-kernel-owner+w=401wt.eu-S1161256AbXCNMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161256AbXCNMsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161255AbXCNMsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:48:00 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36581 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161251AbXCNMrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:47:52 -0400
Message-ID: <45F7EE00.4080004@hitachi.com>
Date: Wed, 14 Mar 2007 21:43:44 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl
Subject: [PATCH 3/3] VM throttling: Break on no more Dirty pages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies balance_dirty_pages() not to block the caller when
the amount of Dirty+Writeback is less than `vm.dirty_limit_ratio'
percent of the total memory.
In that case, the generator of the dirty pages are throttled in the
write-requests-queue of the backing device.

throttle_vm_writeout() is also changed to calculate the threshold from
the new limit provided by modified get_dirty_limits().

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Yuji Kakutani <yuji.kakutani.uw@hitachi.com>
---
 mm/page-writeback.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

Index: linux-2.6.21-rc3-mm2/mm/page-writeback.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/mm/page-writeback.c
+++ linux-2.6.21-rc3-mm2/mm/page-writeback.c
@@ -219,12 +219,15 @@ get_dirty_limits(long *pbackground, long
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
+ * If the caller couldn't writeback `write_chunk' pages and we're over
+ * `dirty_limit', the caller will be blocked in congestion_wait().
  * If we're over `background_thresh' then pdflush is woken to perform some
  * writeout.
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
 	long nr_reclaimable;
+	long nr_dirty;
 	long background_thresh;
 	long dirty_thresh;
 	long dirty_limit;
@@ -246,9 +249,9 @@ static void balance_dirty_pages(struct a
 							&dirty_limit, mapping);
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
-			dirty_thresh)
-				break;
+		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
+		if (nr_dirty <= dirty_thresh)
+			break;

 		if (!dirty_exceeded)
 			dirty_exceeded = 1;
@@ -265,20 +268,21 @@ static void balance_dirty_pages(struct a
 					 		&dirty_limit, mapping);
 			nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-			if (nr_reclaimable +
-				global_page_state(NR_WRITEBACK)
-					<= dirty_thresh)
-						break;
+			nr_dirty = nr_reclaimable +
+					global_page_state(NR_WRITEBACK);
+			if (nr_dirty <= dirty_thresh)
+				break;
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+			if (nr_dirty <= dirty_limit)
+				break;		/* no more dirty pages on bdi */
 		}
 		congestion_wait(WRITE, HZ/10);
 	}

-	if (nr_reclaimable + global_page_state(NR_WRITEBACK)
-		<= dirty_thresh && dirty_exceeded)
-			dirty_exceeded = 0;
+	if (nr_dirty <= dirty_thresh && dirty_exceeded)
+		dirty_exceeded = 0;

 	if (writeback_in_progress(bdi))
 		return;		/* pdflush is already working this queue */
@@ -372,10 +376,10 @@ void throttle_vm_writeout(gfp_t gfp_mask
                  * Boost the allowable dirty threshold a bit for page
                  * allocators so they don't get DoS'ed by heavy writers
                  */
-                dirty_thresh += dirty_thresh / 10;      /* wheeee... */
+                dirty_limit += dirty_limit / 10;      /* wheeee... */

                 if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
+			global_page_state(NR_WRITEBACK) <= dirty_limit)
                         	break;
                 congestion_wait(WRITE, HZ/10);
         }

