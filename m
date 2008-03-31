Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYCaPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYCaPta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYCaPtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:49:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58549 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYCaPtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:49:22 -0400
Subject: [PATCH] hugetlb: vmstat events for huge page allocations
From: Eric B Munson <ebmunson@us.ibm.com>
Reply-To: ebmunson@us.ibm.com
To: akpm@osdl.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, agl@us.ibm.com
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AGjqVFiEIahs7jlaUfU8"
Organization: IBM LTC
Date: Mon, 31 Mar 2008 23:49:08 +0800
Message-Id: <1206978548.8042.7.camel@grover.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AGjqVFiEIahs7jlaUfU8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Andrew, please merge the following

From: Adam Litke <agl@us.ibm.com>

Following feedback here is v3
Changes from v2: Renamed stats to HTLB_BUDDY_PGALLOC[_FAIL] and htlb_buddy_=
alloc_[success|fail]
Calling __count_vm_event from alloc_buddy_huge_page with lock held

Allocating huge pages directly from the buddy allocator is not guaranteed
to succeed.  Success depends on several factors (such as the amount of
physical memory available and the level of fragmentation).  With the
addition of dynamic hugetlb pool resizing, allocations can occur much more
frequently.  For these reasons it is desirable to keep track of huge page
allocation successes and failures.

Add two new vmstat entries to track huge page allocations that succeed and
fail.  The presence of the two entries is contingent upon
CONFIG_HUGETLB_PAGE being enabled.

This patch was created against linux-2.6.25-rc5

Signed-off-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Eric Munson <ebmunson@us.ibm.com>

It applied cleanly to 2.6.25-rc5-mm1 as well so I tested using a small x86
machine and found no problems. There was one curiousity with libhugetlbfs
with dynamic pool resizing was that two failures were accounted for when th=
e
mapping was larger than the number of huge pages could be allocated. Howeve=
r,
it turned out that the first failure was libhugetlbfs calling mlock() but
not existing on failure and the second was the page fault. So, while I didn=
't
expect it in advance, it is still correct accounting.

Tested-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andy Whitcroft <apw@shadowen.org>

 include/linux/vmstat.h |    8 +++++++-
 mm/hugetlb.c           |    7 +++++++
 mm/vmstat.c            |    4 ++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 9f1b4b4..f68f538 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -25,6 +25,12 @@
 #define HIGHMEM_ZONE(xx)
 #endif
=20
+#ifdef CONFIG_HUGETLB_PAGE
+#define HTLB_STATS	HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
+#else
+#define HTLB_STATS
+#endif
+
 #define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_=
ZONE(xx) , xx##_MOVABLE
=20
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
@@ -36,7 +42,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, HTLB_STATS
 		NR_VM_EVENT_ITEMS
 };
=20
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 74c1b6b..dd20cb0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -239,6 +239,11 @@ static int alloc_fresh_huge_page(void)
 		hugetlb_next_nid =3D next_nid;
 	} while (!page && hugetlb_next_nid !=3D start_nid);
=20
+	if (ret)
+		count_vm_event(HTLB_BUDDY_PGALLOC);
+	else
+		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
+
 	return ret;
 }
=20
@@ -299,9 +304,11 @@ static struct page *alloc_buddy_huge_page(struct vm_ar=
ea_struct *vma,
 		 */
 		nr_huge_pages_node[nid]++;
 		surplus_huge_pages_node[nid]++;
+		__count_vm_event(HTLB_BUDDY_PGALLOC);
 	} else {
 		nr_huge_pages--;
 		surplus_huge_pages--;
+		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 	}
 	spin_unlock(&hugetlb_lock);
=20
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 422d960..34d1fd9 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -644,6 +644,10 @@ static const char * const vmstat_text[] =3D {
 	"allocstall",
=20
 	"pgrotated",
+#ifdef CONFIG_HUGETLB_PAGE
+	"htlb_buddy_alloc_success",
+	"htlb_buddy_alloc_fail",
+#endif
 #endif
 };
=20


--=-AGjqVFiEIahs7jlaUfU8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8Qf0snv9E83jkzoRAoMpAJ4jE0YCq0hIBsYNVTN8qCX8X6BbNgCfcgVi
tChQSuJhDDi9jLD/JHNtEZA=
=ZQ/c
-----END PGP SIGNATURE-----

--=-AGjqVFiEIahs7jlaUfU8--

