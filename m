Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbYCKXgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbYCKXgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYCKXgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:36:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYCKXgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:36:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] Hibernation: Fix mark_nosave_pages()
Date: Wed, 12 Mar 2008 00:34:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120034.58615.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9966 .

Although the problem has been there for quite some time (since before 2.6.22,
apparently), it would be good to have in 2.6.25, because it may fix booting
problems on the affected systems.

Please note that it doesn't modify the code behavior on the systems which are
not affected by bug #9966 .

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

There is a problem in the hibernation code that triggers on some NUMA
systems on which pfn_valid() returns 'true' for some PFNs that don't
belong to any zone.  Namely, there is a BUG_ON() in
memory_bm_find_bit() that triggers for PFNs not belonging to any
zone and passing the pfn_valid() test.  On the affected systems it
triggers when we mark PFNs reported by the platform as not saveable,
because the PFNs in question belong to a region mapped directly using
iorepam() (i.e. the ACPI data area) and they pass the pfn_valid()
test.

Modify memory_bm_find_bit() so that it returns an error if given PFN
doesn't belong to any zone instead of crashing the kernel and ignore
the result returned by it in mark_nosave_pages(), while marking the
"nosave" memory regions.

This doesn't affect the hibernation functionality, as we won't touch
the PFNs in question anyway.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -447,7 +447,7 @@ static void memory_bm_free(struct memory
  *	of @bm->cur_zone_bm are updated.
  */
 
-static void memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
+static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 				void **addr, unsigned int *bit_nr)
 {
 	struct zone_bitmap *zone_bm;
@@ -461,7 +461,8 @@ static void memory_bm_find_bit(struct me
 		while (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
 			zone_bm = zone_bm->next;
 
-			BUG_ON(!zone_bm);
+			if (!zone_bm)
+				return -EFAULT;
 		}
 		bm->cur.zone_bm = zone_bm;
 	}
@@ -479,23 +480,40 @@ static void memory_bm_find_bit(struct me
 	pfn -= bb->start_pfn;
 	*bit_nr = pfn % BM_BITS_PER_CHUNK;
 	*addr = bb->data + pfn / BM_BITS_PER_CHUNK;
+	return 0;
 }
 
 static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
+	int error;
 
-	memory_bm_find_bit(bm, pfn, &addr, &bit);
+	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
+	BUG_ON(error);
 	set_bit(bit, addr);
 }
 
+static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
+{
+	void *addr;
+	unsigned int bit;
+	int error;
+
+	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
+	if (!error)
+		set_bit(bit, addr);
+	return error;
+}
+
 static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
+	int error;
 
-	memory_bm_find_bit(bm, pfn, &addr, &bit);
+	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
+	BUG_ON(error);
 	clear_bit(bit, addr);
 }
 
@@ -503,8 +521,10 @@ static int memory_bm_test_bit(struct mem
 {
 	void *addr;
 	unsigned int bit;
+	int error;
 
-	memory_bm_find_bit(bm, pfn, &addr, &bit);
+	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
+	BUG_ON(error);
 	return test_bit(bit, addr);
 }
 
@@ -709,8 +729,15 @@ static void mark_nosave_pages(struct mem
 				region->end_pfn << PAGE_SHIFT);
 
 		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
-			if (pfn_valid(pfn))
-				memory_bm_set_bit(bm, pfn);
+			if (pfn_valid(pfn)) {
+				/*
+				 * It is safe to ignore the result of
+				 * mem_bm_set_bit_check() here, since we won't
+				 * touch the PFNs for which the error is
+				 * returned anyway.
+				 */
+				mem_bm_set_bit_check(bm, pfn);
+			}
 	}
 }
 
