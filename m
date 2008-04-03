Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYDCN1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYDCN1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYDCN1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:27:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbYDCN1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:27:32 -0400
Subject: [PATCH] xen: Fix grant table bug
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel <xen-devel@lists.xensource.com>,
       Michael Abd-El-Malek <mabdelmalek@cmu.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <47F05DB1.5090606@cmu.edu>
References: <47F05DB1.5090606@cmu.edu>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 14:26:50 +0100
Message-Id: <1207229210.29720.11.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-30 at 23:42 -0400, Michael Abd-El-Malek wrote:

> There was a bug in the free list allocation code. The free list was indexed as 
> if it was the same size as the grant table.  But it's only half as large.  So 
> memory got corrupted, and I was seeing crashes in the slab allocator later on.

Looks like an obvious candidate for upstream linux too. Rebased version
below.

Cheers,
Mark.

From: Michael Abd-El-Malek <mabdelmalek@cmu.edu>

A PV OS has two grant table data structures: the grant table itself
and a free list.  The free list is composed of an array of pages,
which grow dynamically as the guest OS requires more grants.  While
the grant table contains 8-byte entries, the free list contains 4-byte
entries.  So we have half as many pages in the free list than in the
grant table.

There was a bug in the free list allocation code. The free list was
indexed as if it was the same size as the grant table.  But it's only
half as large.  So memory got corrupted, and I was seeing crashes in
the slab allocator later on.

Taken from:

  http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/4018c0da3360

Signed-off-by: Michael Abd-El-Malek <mabdelmalek@cmu.edu>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/xen/grant-table.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index ea94dba..d85dc6d 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -381,11 +381,15 @@ EXPORT_SYMBOL_GPL(gnttab_cancel_free_callback);
 static int grow_gnttab_list(unsigned int more_frames)
 {
 	unsigned int new_nr_grant_frames, extra_entries, i;
+	unsigned int nr_glist_frames, new_nr_glist_frames;
 
 	new_nr_grant_frames = nr_grant_frames + more_frames;
 	extra_entries       = more_frames * GREFS_PER_GRANT_FRAME;
 
-	for (i = nr_grant_frames; i < new_nr_grant_frames; i++) {
+	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	new_nr_glist_frames =
+		(new_nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	for (i = nr_glist_frames; i < new_nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_ATOMIC);
 		if (!gnttab_list[i])
 			goto grow_nomem;
@@ -407,7 +411,7 @@ static int grow_gnttab_list(unsigned int more_frames)
 	return 0;
 
 grow_nomem:
-	for ( ; i >= nr_grant_frames; i--)
+	for ( ; i >= nr_glist_frames; i--)
 		free_page((unsigned long) gnttab_list[i]);
 	return -ENOMEM;
 }
@@ -530,7 +534,7 @@ static int gnttab_expand(unsigned int req_entries)
 static int __devinit gnttab_init(void)
 {
 	int i;
-	unsigned int max_nr_glist_frames;
+	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
 	if (!is_running_on_xen())
@@ -543,15 +547,15 @@ static int __devinit gnttab_init(void)
 	 * grant reference free list on the current hypervisor.
 	 */
 	max_nr_glist_frames = (boot_max_nr_grant_frames *
-			       GREFS_PER_GRANT_FRAME /
-			       (PAGE_SIZE / sizeof(grant_ref_t)));
+			       GREFS_PER_GRANT_FRAME / RPP);
 
 	gnttab_list = kmalloc(max_nr_glist_frames * sizeof(grant_ref_t *),
 			      GFP_KERNEL);
 	if (gnttab_list == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < nr_grant_frames; i++) {
+	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	for (i = 0; i < nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
 		if (gnttab_list[i] == NULL)
 			goto ini_nomem;
-- 


