Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYBSVic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYBSVic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760094AbYBSViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:38:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbYBSViO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:38:14 -0500
Message-ID: <47BB4BB5.20709@redhat.com>
Date: Tue, 19 Feb 2008 16:35:49 -0500
From: Larry Woodman <lwoodman@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040301
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Problem with /proc/sys/vm/lowmem_reserve_ratio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balance_pgdat() calls zone_watermark_ok() three times, the first call
passes a zero(0) in as the 4th argument.  This 4th argument is the
classzone_idx which is used as the index into the zone->lowmem_reserve[] 
array. 
Since setup_per_zone_lowmem_reserve()
always sets the zone->lowmem_reserve[0] = 0(because there is nothing
below the DMA zone), zone_watermark_ok() will not consider the
lowmem_reserve pages when zero is passed as the 4th arg.   The
4th argument must be "i" or balance_pgdat wont even get into the main loop
when lowmem_reserve_ratio is lowered.

-------------------------------------------------------------------------
--- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
11:14:55.000000000 -0500
+++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:15:02.000000000
-0500
@@ -1375,7 +1375,7 @@ loop_again:
                               continue;

                       if (!zone_watermark_ok(zone, order, 
zone->pages_high,

-                                              0, 0)) {
+                                              i, 0)) {
                               end_zone = i;
                               break;

