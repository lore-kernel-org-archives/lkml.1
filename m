Return-Path: <linux-kernel-owner+w=401wt.eu-S936485AbZLQE0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936485AbZLQE0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936475AbZLQE0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:26:10 -0500
Received: from kroah.org ([198.145.64.141]:55778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935726AbZLQEE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.580519111@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gianluca Guida <gianluca.guida@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [097/151] Xen balloon: fix totalram_pages counting.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gianluca Guida <gianluca.guida@citrix.com>

commit 3d65c9488cadd2f11bd4d60c7266e639ece5d0d6 upstream.

Change totalram_pages when a single page is added/removed to the
ballooned list. This avoid totalram_pages to be set erroneously to
max_pfn at boot.

Signed-off-by: Gianluca Guida <gianluca.guida@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/balloon.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -136,6 +136,8 @@ static void balloon_append(struct page *
 		list_add(&page->lru, &ballooned_pages);
 		balloon_stats.balloon_low++;
 	}
+
+	totalram_pages--;
 }
 
 /* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
@@ -156,6 +158,8 @@ static struct page *balloon_retrieve(voi
 	else
 		balloon_stats.balloon_low--;
 
+	totalram_pages++;
+
 	return page;
 }
 
@@ -260,7 +264,6 @@ static int increase_reservation(unsigned
 	}
 
 	balloon_stats.current_pages += nr_pages;
-	totalram_pages = balloon_stats.current_pages;
 
  out:
 	spin_unlock_irqrestore(&balloon_lock, flags);
@@ -323,7 +326,6 @@ static int decrease_reservation(unsigned
 	BUG_ON(ret != nr_pages);
 
 	balloon_stats.current_pages -= nr_pages;
-	totalram_pages = balloon_stats.current_pages;
 
 	spin_unlock_irqrestore(&balloon_lock, flags);
 
@@ -422,7 +424,6 @@ static int __init balloon_init(void)
 	pr_info("xen_balloon: Initialising balloon driver.\n");
 
 	balloon_stats.current_pages = min(xen_start_info->nr_pages, max_pfn);
-	totalram_pages   = balloon_stats.current_pages;
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;


