Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759985AbYLQAMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYLQAMX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbYLQAGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:45 -0500
Received: from kroah.org ([198.145.64.141]:41437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759782AbYLQAGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:19 -0500
Date: Tue, 16 Dec 2008 16:04:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [patch 22/22] setup_per_zone_pages_min(): take zone->lock instead
	of zone->lru_lock
Message-ID: <20081217000443.GW4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 1125b4e3949949b44a7c80b619507c6f61d62911 upstream.

This replaces zone->lru_lock in setup_per_zone_pages_min() with zone->lock.
There seems to be no need for the lru_lock anymore, but there is a need for
zone->lock instead, because that function may call move_freepages() via
setup_zone_migrate_reserve().

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4224,7 +4224,7 @@ void setup_per_zone_pages_min(void)
 	for_each_zone(zone) {
 		u64 tmp;
 
-		spin_lock_irqsave(&zone->lru_lock, flags);
+		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone->present_pages;
 		do_div(tmp, lowmem_pages);
 		if (is_highmem(zone)) {
@@ -4256,7 +4256,7 @@ void setup_per_zone_pages_min(void)
 		zone->pages_low   = zone->pages_min + (tmp >> 2);
 		zone->pages_high  = zone->pages_min + (tmp >> 1);
 		setup_zone_migrate_reserve(zone);
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	/* update totalreserve_pages */

