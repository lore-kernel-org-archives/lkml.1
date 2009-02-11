Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZBKAmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZBKAmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbZBKA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:43 -0500
Received: from kroah.org ([198.145.64.141]:51441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756273AbZBKA2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:41 -0500
Date: Tue, 10 Feb 2009 16:25:36 -0800
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
       alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [patch 39/56] mm: remove UP version of lru_add_drain_all()
Message-ID: <20090211002536.GN14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-remove-up-version-of-lru_add_drain_all.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 6841c8e26357904ef462650273f5d5015f7bb370 upstream.

Currently, lru_add_drain_all() has two version.
  (1) use schedule_on_each_cpu()
  (2) don't use schedule_on_each_cpu()

Gerald Schaefer reported it doesn't work well on SMP (not NUMA) S390
machine.

  offline_pages() calls lru_add_drain_all() followed by drain_all_pages().
  While drain_all_pages() works on each cpu, lru_add_drain_all() only runs
  on the current cpu for architectures w/o CONFIG_NUMA. This let us run
  into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
  memory hotplug stress test on s390. The page in question was still on the
  pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
  on different cpus.

Actually, Almost machine has CONFIG_UNEVICTABLE_LRU=y. Then almost machine use
(1) version lru_add_drain_all although the machine is UP.

Then this ifdef is not valueable.
simple removing is better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/swap.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/swap.c
+++ b/mm/swap.c
@@ -244,7 +244,6 @@ void lru_add_drain(void)
 	put_cpu();
 }
 
-#ifdef CONFIG_NUMA
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
 	lru_add_drain();
@@ -258,18 +257,6 @@ int lru_add_drain_all(void)
 	return schedule_on_each_cpu(lru_add_drain_per_cpu);
 }
 
-#else
-
-/*
- * Returns 0 for success
- */
-int lru_add_drain_all(void)
-{
-	lru_add_drain();
-	return 0;
-}
-#endif
-
 /*
  * Batched page_cache_release().  Decrement the reference count on all the
  * passed pages.  If it fell to zero then remove the page from the LRU and

