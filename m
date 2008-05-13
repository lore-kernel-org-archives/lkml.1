Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYEMBOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYEMBOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYEMBOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:14:04 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:35987 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbYEMBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:14:03 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <4828EB53.7030407@am.sony.com>
Date: Mon, 12 May 2008 18:13:55 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Yasunori Goto <y-goto@jp.fujitsu.com>, linuxppc-dev@ozlabs.org,
       mikpe@it.uu.se, Badari Pulavarty <pbadari@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [rfc patch] memory_hotplug: Check for walk_memory_resource() failure
 in online_pages()
References: <20080512.174151.193690130.davem@davemloft.net>
In-Reply-To: <20080512.174151.193690130.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2008 01:13:56.0445 (UTC) FILETIME=[9DBB48D0:01C8B496]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check to online_pages() to test for failure of
walk_memory_resource().  This fixes a condition where a failure
of walk_memory_resource() can lead to online_pages() returning
success without the requested pages being onlined.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---

I'm not entirely sure this is the proper way to handle this
condition.  Comments welcome.

 mm/memory_hotplug.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -408,8 +408,15 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
-	walk_memory_resource(pfn, nr_pages, &onlined_pages,
+	ret = walk_memory_resource(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
+	if (ret) {
+		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
+			nr_pages, pfn);
+		memory_notify(MEM_CANCEL_ONLINE, &arg);
+		return ret;
+	}
+
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 

