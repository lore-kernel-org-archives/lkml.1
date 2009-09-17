Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZIQVOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZIQVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZIQVOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:14:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:54756 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZIQVOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:14:06 -0400
Date: Thu, 17 Sep 2009 21:13:32 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus@trippelsdorf.de, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus@trippelsdorf.de, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
References: <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86, pat: don't use rb-tree based lookup in reserve_memtype()
Message-ID: <tip-dcb73bf402e0d5b28ce925dbbe4dab3b00b21eee@git.kernel.org>
Git-Commit-ID: dcb73bf402e0d5b28ce925dbbe4dab3b00b21eee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 21:13:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcb73bf402e0d5b28ce925dbbe4dab3b00b21eee
Gitweb:     http://git.kernel.org/tip/dcb73bf402e0d5b28ce925dbbe4dab3b00b21eee
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 16 Sep 2009 14:28:03 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Sep 2009 14:07:58 -0700

x86, pat: don't use rb-tree based lookup in reserve_memtype()

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

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/mm/pat.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index d2a72ab..9b647f6 100644
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
