Return-Path: <linux-kernel-owner+w=401wt.eu-S936494AbZLQEZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936494AbZLQEZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936486AbZLQEZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:25:08 -0500
Received: from kroah.org ([198.145.64.141]:55782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935744AbZLQEE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.709164511@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [098/151] xen: try harder to balloon up under memory pressure.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit bc2c0303226ec716854d3c208c7f84fe7aa35cd7 upstream.

Currently if the balloon driver is unable to increase the guest's
reservation it assumes the failure was due to reaching its full
allocation, gives up on the ballooning operation and records the limit
it reached as the "hard limit". The driver will not try again until
the target is set again (even to the same value).

However it is possible that ballooning has in fact failed due to
memory pressure in the host and therefore it is desirable to keep
attempting to reach the target in case memory becomes available. The
most likely scenario is that some guests are ballooning down while
others are ballooning up and therefore there is temporary memory
pressure while things stabilise. You would not expect a well behaved
toolstack to ask a domain to balloon to more than its allocation nor
would you expect it to deliberately over-commit memory by setting
balloon targets which exceed the total host memory.

This patch drops the concept of a hard limit and causes the balloon
driver to retry increasing the reservation on a timer in the same
manner as when decreasing the reservation.

Also if we partially succeed in increasing the reservation
(i.e. receive less pages than we asked for) then we may as well keep
those pages rather than returning them to Xen.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/balloon.c |   31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -66,8 +66,6 @@ struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
 	unsigned long current_pages;
 	unsigned long target_pages;
-	/* We may hit the hard limit in Xen. If we do then we remember it. */
-	unsigned long hard_limit;
 	/*
 	 * Drivers may alter the memory reservation independently, but they
 	 * must inform the balloon driver so we avoid hitting the hard limit.
@@ -185,7 +183,7 @@ static void balloon_alarm(unsigned long 
 
 static unsigned long current_target(void)
 {
-	unsigned long target = min(balloon_stats.target_pages, balloon_stats.hard_limit);
+	unsigned long target = balloon_stats.target_pages;
 
 	target = min(target,
 		     balloon_stats.current_pages +
@@ -221,23 +219,10 @@ static int increase_reservation(unsigned
 	set_xen_guest_handle(reservation.extent_start, frame_list);
 	reservation.nr_extents = nr_pages;
 	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
-	if (rc < nr_pages) {
-		if (rc > 0) {
-			int ret;
-
-			/* We hit the Xen hard limit: reprobe. */
-			reservation.nr_extents = rc;
-			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-						   &reservation);
-			BUG_ON(ret != rc);
-		}
-		if (rc >= 0)
-			balloon_stats.hard_limit = (balloon_stats.current_pages + rc -
-						    balloon_stats.driver_pages);
+	if (rc < 0)
 		goto out;
-	}
 
-	for (i = 0; i < nr_pages; i++) {
+	for (i = 0; i < rc; i++) {
 		page = balloon_retrieve();
 		BUG_ON(page == NULL);
 
@@ -263,12 +248,12 @@ static int increase_reservation(unsigned
 		__free_page(page);
 	}
 
-	balloon_stats.current_pages += nr_pages;
+	balloon_stats.current_pages += rc;
 
  out:
 	spin_unlock_irqrestore(&balloon_lock, flags);
 
-	return 0;
+	return rc < 0 ? rc : rc != nr_pages;
 }
 
 static int decrease_reservation(unsigned long nr_pages)
@@ -369,7 +354,6 @@ static void balloon_process(struct work_
 static void balloon_set_new_target(unsigned long target)
 {
 	/* No need for lock. Not read-modify-write updates. */
-	balloon_stats.hard_limit   = ~0UL;
 	balloon_stats.target_pages = target;
 	schedule_work(&balloon_worker);
 }
@@ -428,7 +412,6 @@ static int __init balloon_init(void)
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
 	balloon_stats.driver_pages  = 0UL;
-	balloon_stats.hard_limit    = ~0UL;
 
 	init_timer(&balloon_timer);
 	balloon_timer.data = 0;
@@ -473,9 +456,6 @@ module_exit(balloon_exit);
 BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
 BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
 BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
-BALLOON_SHOW(hard_limit_kb,
-	     (balloon_stats.hard_limit!=~0UL) ? "%lu\n" : "???\n",
-	     (balloon_stats.hard_limit!=~0UL) ? PAGES2KB(balloon_stats.hard_limit) : 0);
 BALLOON_SHOW(driver_kb, "%lu\n", PAGES2KB(balloon_stats.driver_pages));
 
 static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
@@ -545,7 +525,6 @@ static struct attribute *balloon_info_at
 	&attr_current_kb.attr,
 	&attr_low_kb.attr,
 	&attr_high_kb.attr,
-	&attr_hard_limit_kb.attr,
 	&attr_driver_kb.attr,
 	NULL
 };


