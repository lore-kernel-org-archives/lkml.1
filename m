Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZIKWf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZIKWf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZIKWf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:35:26 -0400
Received: from toro.web-alm.net ([62.245.132.31]:36721 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZIKWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:35:25 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 18:35:25 EDT
Message-ID: <4AAAC9B1.9060505@osadl.org>
Date: Sat, 12 Sep 2009 00:05:37 +0200
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Prevent NULL pointer dereference in ftrace_raw_event_block_bio_bounce
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.31 and executing
   echo 1 >/sys/kernel/debug/tracing/events/enable
leads to
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c032a583>] ftrace_raw_event_block_bio_bounce+0x4b/0xb9

Apparently,
   bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
is called in block/blk-map.c:58 where bio->bi_bdev in set to NULL and 
still is NULL when an attempt is made to evaluate bio->bi_bdev->bd_dev 
in include/trace/events/block.h:189.

The tracepoint should ensure bio->bi_bdev is not dereferenced, if NULL.

Signed-Off-By: Carsten Emde <C.Emde@osadl.org>

--- a/include/trace/events/block.h 2009-09-11 21:20:56.000000000 +0200
+++ b/include/trace/events/block.h 2009-09-11 22:01:52.000000000 +0200
@@ -186,7 +186,8 @@
  	),

  	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->dev		= bio->bi_bdev ?
+					  bio->bi_bdev->bd_dev : 0;
  		__entry->sector		= bio->bi_sector;
  		__entry->nr_sector	= bio->bi_size >> 9;
  		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);

