Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYKOFbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYKOFbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYKOFZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:28 -0500
Received: from kroah.org ([198.145.64.141]:48121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754038AbYKOFZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:13 -0500
Date: Fri, 14 Nov 2008 21:23:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>
Subject: [patch 20/22] memory hotplug: fix page_zone() calculation in
	test_pages_isolated()
Message-ID: <20081115052352.GU3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit a70dcb969f64e2fa98c24f47854f20bf02ff0092 upstream.

My last bugfix here (adding zone->lock) introduced a new problem: Using
page_zone(pfn_to_page(pfn)) to get the zone after the for() loop is wrong.
 pfn will then be >= end_pfn, which may be in a different zone or not
present at all.  This may lead to an addressing exception in page_zone()
or spin_lock_irqsave().

Now I use __first_valid_page() again after the loop to find a valid page
for page_zone().

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_isolation.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -130,10 +130,11 @@ int test_pages_isolated(unsigned long st
 		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			break;
 	}
-	if (pfn < end_pfn)
+	page = __first_valid_page(start_pfn, end_pfn - start_pfn);
+	if ((pfn < end_pfn) || !page)
 		return -EBUSY;
 	/* Check all pages are free or Marked as ISOLATED */
-	zone = page_zone(pfn_to_page(pfn));
+	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
 	spin_unlock_irqrestore(&zone->lock, flags);

-- 
