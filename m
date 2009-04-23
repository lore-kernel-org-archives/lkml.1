Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZDWHlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZDWHlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZDWHa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:26 -0400
Received: from sous-sol.org ([216.99.217.87]:50403 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756371AbZDWHaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:24 -0400
Message-Id: <20090423072447.892598765@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 036/100] dm raid1: switch read_record from kmalloc to slab to save memory
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-raid1-switch-read_record-from-kmalloc-to-slab-to-save-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mpatocka@redhat.com>

upstream commit: 95f8fac8dc6139fedfb87746e0c8fda9b803cb46

With my previous patch to save bi_io_vec, the size of dm_raid1_read_record
is significantly increased (the vector list takes 3072 bytes on 32-bit machines
and 4096 bytes on 64-bit machines).

The structure dm_raid1_read_record used to be allocated with kmalloc,
but kmalloc aligns the size on the next power-of-two so an object
slightly greater than 4096 will allocate 8192 bytes of memory and half of
that memory will be wasted.

This patch turns kmalloc into a slab cache which doesn't have this
padding so it will reduce the memory consumed.

Cc: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-raid1.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -145,6 +145,8 @@ struct dm_raid1_read_record {
 	struct dm_bio_details details;
 };
 
+static struct kmem_cache *_dm_raid1_read_record_cache;
+
 /*
  * Every mirror should look like this one.
  */
@@ -764,9 +766,9 @@ static struct mirror_set *alloc_context(
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
-	len = sizeof(struct dm_raid1_read_record);
-	ms->read_record_pool = mempool_create_kmalloc_pool(MIN_READ_RECORDS,
-							   len);
+	ms->read_record_pool = mempool_create_slab_pool(MIN_READ_RECORDS,
+						_dm_raid1_read_record_cache);
+
 	if (!ms->read_record_pool) {
 		ti->error = "Error creating mirror read_record_pool";
 		kfree(ms);
@@ -1279,16 +1281,31 @@ static int __init dm_mirror_init(void)
 {
 	int r;
 
+	_dm_raid1_read_record_cache = KMEM_CACHE(dm_raid1_read_record, 0);
+	if (!_dm_raid1_read_record_cache) {
+		DMERR("Can't allocate dm_raid1_read_record cache");
+		r = -ENOMEM;
+		goto bad_cache;
+	}
+
 	r = dm_register_target(&mirror_target);
-	if (r < 0)
+	if (r < 0) {
 		DMERR("Failed to register mirror target");
+		goto bad_target;
+	}
+
+	return 0;
 
+bad_target:
+	kmem_cache_destroy(_dm_raid1_read_record_cache);
+bad_cache:
 	return r;
 }
 
 static void __exit dm_mirror_exit(void)
 {
 	dm_unregister_target(&mirror_target);
+	kmem_cache_destroy(_dm_raid1_read_record_cache);
 }
 
 /* Module hooks */

