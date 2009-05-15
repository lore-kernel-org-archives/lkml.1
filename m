Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZEOEhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZEOEhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZEOEgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:36:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41114 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbZEOEgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:36:50 -0400
Date: Fri, 15 May 2009 13:25:53 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][BUG] fix the calculation of the oldest_jif in wb_kupdate()
Message-Id: <20090515132553.18d0b010.toshi.okajima@jp.fujitsu.com>
Organization: Fujitsu co.,ltd.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

wb_kupdate() function has a bug on linux-2.6.30-rc5.
This bug causes generic_sync_sb_inodes() to start to write inodes back 
much earlier than our expectations because it miscalculates oldest_jif
in wb_kupdate(). 

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -Nurp linux-2.6.30-rc5.orig/mm/page-writeback.c linux-2.6.30-rc5/mm/page-writeback.c
--- linux-2.6.30-rc5.orig/mm/page-writeback.c	2009-05-09 09:14:14.000000000 +0900
+++ linux-2.6.30-rc5/mm/page-writeback.c	2009-05-15 20:19:03.000000000 +0900
@@ -94,12 +94,12 @@ unsigned long vm_dirty_bytes;
 /*
  * The interval between `kupdate'-style writebacks
  */
-unsigned int dirty_writeback_interval = 5 * 100; /* sentiseconds */
+unsigned int dirty_writeback_interval = 5 * 100; /* centiseconds */
 
 /*
  * The longest time for which data is allowed to remain dirty
  */
-unsigned int dirty_expire_interval = 30 * 100; /* sentiseconds */
+unsigned int dirty_expire_interval = 30 * 100; /* centiseconds */
 
 /*
  * Flag that makes the machine dump writes/reads and block dirtyings.
@@ -770,7 +770,7 @@ static void wb_kupdate(unsigned long arg
 
 	sync_supers();
 
-	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval);
+	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
 	start_jif = jiffies;
 	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
