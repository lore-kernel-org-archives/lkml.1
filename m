Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbXBWMIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbXBWMIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXBWMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:08:17 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:39026 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbXBWMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:08:13 -0500
Message-ID: <45DED833.1080804@hitachi.com>
Date: Fri, 23 Feb 2007 21:04:03 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, miklos@szeredi.hu, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com
Subject: [RFC][PATCH 3/3] VM throttling: Break on no more Dirty pages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies balance_dirty_pages() not to block the caller when
the amount of Dirty+Writeback is less than `vm.dirty_limit_ratio'
percent of the total memory.

throttle_vm_writeout() is also changed to calculate the threshold from
the new limit provided by modified get_dirty_limits().

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Yuji Kakutani <yuji.kakutani.uw@hitachi.com>
---
 mm/page-writeback.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

Index: linux-2.6.20-mm2-bdp/mm/page-writeback.c
===================================================================
--- linux-2.6.20-mm2-bdp.orig/mm/page-writeback.c
+++ linux-2.6.20-mm2-bdp/mm/page-writeback.c
@@ -219,12 +219,15 @@ get_dirty_limits(long *pbackground, long
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
+ * If the caller couldn't writeback `write_chunk' pages and we're over
+ * `dirty_limit_ratio', the caller will be blocked.
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
@@ -362,10 +366,10 @@ void throttle_vm_writeout(void)
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

