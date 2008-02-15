Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbYBOOwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbYBOOwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbYBOOwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:52:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbYBOOwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:52:23 -0500
Message-ID: <47B5A699.7010509@redhat.com>
Date: Fri, 15 Feb 2008 09:50:01 -0500
From: Larry Woodman <lwoodman@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040301
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with /proc/sys/vm/lowmem_reserve_ratio ???
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balance_pgdat() calls zone_watermark_ok() three times, the first call
passes a zero(0) in as the 4th argument.  This 4th argument is the
classzone_idx which is used as the index into the 
zone->lowmem_reserve[] array.  Since setup_per_zone_lowmem_reserve()
always sets the zone->lowmem_reserve[0] = 0(because there is nothing
below the DMA zone), zone_watermark_ok() will not consider the
lowmem_reserve pages when zero is passed as the 4th arg.  Shouldnt this
4th argument be either "i" or "nr_zones - 1" ???

-------------------------------------------------------------------------
--- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
11:14:55.000000000 -0500
+++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:15:02.000000000
-0500
@@ -1375,7 +1375,7 @@ loop_again:
                                continue;

                        if (!zone_watermark_ok(zone, order, zone->pages_high,

-                                              0, 0)) {
+                                              i, 0)) {
                                end_zone = i;
                                break;
-------------------------------------------------------------------------
--- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
11:14:55.000000000 -0500
+++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:16:35.000000000
-0500
@@ -1375,7 +1375,7 @@ loop_again:
                                continue;

                        if (!zone_watermark_ok(zone, order, zone->pages_high,

-                                              0, 0)) {
+                                              nr_zones - 1, 0)) {
                                end_zone = i;
                                break;
                        }
-------------------------------------------------------------------------


