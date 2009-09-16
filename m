Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbZIPV2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbZIPV2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbZIPV2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:28:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:4718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZIPV2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:28:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,399,1249282800"; 
   d="scan'208";a="727601624"
Subject: Re: x86-PAT tree merge causes keyboard problems
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB07F39.4080205@zytor.com>
References: <20090915205259.GA1910@phenom2.trippelsdorf.de>
	 <4AB018C0.30203@zytor.com> <20090916052657.GA1897@phenom2.trippelsdorf.de>
	 <4AB07F39.4080205@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 16 Sep 2009 14:28:03 -0700
Message-Id: <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 23:01 -0700, H. Peter Anvin wrote:
> Okay, that explains the keyboard failure.  What you're really seeing is
> a systemic failure of the X server.  Suresh thought it might be mapping
> the frame buffer incorrectly.

Markus, Can you please check if the appended patch fixes the issue? It
seems to fix the issue for me.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, pat: don't use rb-tree based lookup in reserve_memtype()

Recent enhancement of rb-tree based lookup exposed a  bug with the lookup
mechanism in the reserve_memtype() which ensures that there are no conflicting
memtype requests for the memory range.

memtype_rb_search() returns an entry which has a start address <= new start
address. And from here we traverse the linear linked list to check if there
any conflicts with the existing mappings. As the rbtree is based on the
start address of the memory range, it is quite possible that we have several
overlapped mappings whose start address is much less than new requested start
but the end is >= new requested end. This results in conflicting memtype
mappings.

Same bug exists with the old code which uses cached_entry from where
we traverse the linear linked list. But the new rb-tree code exposes this
bug fairly easily.

For now, don't use the memtype_rb_search() and always start the search from
the head of linear linked list in reserve_memtype(). Linear linked list
for most of the systems grow's to few 10's of entries(as we track memory type
of RAM pages using struct page). So we should be ok for now.

We still retain the rbtree and use it to speed up free_memtype() which
doesn't have the same bug(as we know what exactly we are searching for
in free_memtype).

Also use list_for_each_entry_from() in free_memtype() so that we start
the search from rb-tree lookup result.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index d7ebc3a..7257cf3 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -424,17 +424,9 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
-	entry = memtype_rb_search(&memtype_rbroot, new->start);
-	if (likely(entry != NULL)) {
-		/* To work correctly with list_for_each_entry_continue */
-		entry = list_entry(entry->nd.prev, struct memtype, nd);
-	} else {
-		entry = list_entry(&memtype_list, struct memtype, nd);
-	}
-
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
-	list_for_each_entry_continue(entry, &memtype_list, nd) {
+	list_for_each_entry(entry, &memtype_list, nd) {
 		if (end <= entry->start) {
 			where = entry->nd.prev;
 			break;
@@ -532,7 +524,7 @@ int free_memtype(u64 start, u64 end)
 	 * in sorted start address
 	 */
 	saved_entry = entry;
-	list_for_each_entry(entry, &memtype_list, nd) {
+	list_for_each_entry_from(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
 			rb_erase(&entry->rb, &memtype_rbroot);
 			list_del(&entry->nd);


