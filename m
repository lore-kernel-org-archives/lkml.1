Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXDCVBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXDCVBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXDCVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:01:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXDCVBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:01:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swsusp: Fix memory shrinker
Date: Tue, 3 Apr 2007 23:04:53 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704032304.53747.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think this is 2.6.21 material.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a bug in the swsusp's memory shrinker that causes some systems using
highmem to refuse to suspend to disk if image_size is set above 1/2 of
available RAM.

Special thanks to Jiri Slaby for reporting the problem and assistance in
debugging it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/swsusp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
+++ linux-2.6.21-rc5/kernel/power/swsusp.c
@@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
 		size += highmem_size;
 		for_each_zone (zone)
 			if (populated_zone(zone)) {
+				tmp += snapshot_additional_pages(zone);
 				if (is_highmem(zone)) {
 					highmem_size -=
 					zone_page_state(zone, NR_FREE_PAGES);
 				} else {
 					tmp -= zone_page_state(zone, NR_FREE_PAGES);
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
-					tmp += snapshot_additional_pages(zone);
 				}
 			}
 
