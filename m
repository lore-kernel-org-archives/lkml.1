Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXHBRKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXHBRKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXHBRJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:09:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbXHBRJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:09:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][Fix] Hibernation: Do not try to mark invalid PFNs as nosave
Date: Thu, 2 Aug 2007 19:18:51 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021918.52283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Please consider as 2.6.23 material.]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

On some systems some PFNs reported by the early initialization code as 'nosave'
may be invalid.  If we try to set the corresponding bits in the hibernation
bitmap, BUG_ON() in memory_bm_find_bit() will be triggered and the system
won't be able to boot  (cf. https://bugzilla.novell.com/show_bug.cgi?id=296242).

Prevent this from happening by verifying if the 'nosave' PFNs are valid in
mark_nosave_pages().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -709,7 +709,8 @@ static void mark_nosave_pages(struct mem
 				region->end_pfn << PAGE_SHIFT);
 
 		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
-			memory_bm_set_bit(bm, pfn);
+			if (pfn_valid(pfn))
+				memory_bm_set_bit(bm, pfn);
 	}
 }
 
