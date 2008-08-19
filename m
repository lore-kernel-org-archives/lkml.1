Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYHSX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYHSX2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYHSX2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:28:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:4654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYHSX2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,237,1217833200"; 
   d="scan'208";a="372045392"
Date: Tue, 19 Aug 2008 16:28:01 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080819232801.GA24610@linux-os.sc.intel.com>
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <48AB1D62.6030406@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB1D62.6030406@keyaccess.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:22:10PM -0700, Rene Herman wrote:
> On 19-08-08 21:07, Venki Pallipadi wrote:
> 
> > On Tue, Aug 19, 2008 at 07:19:44AM -0700, Rene Herman wrote:
> 
> >> I believe the 14 seconds for first shutdown to 5 later might be
> >> telling. Sounds like something might have fixed up uncached
> >> entries.
> >>
> >> I'd really like a reply from the AGP or PAT side right about now.
> >
> > Hmm. Looks like there are more than 16000 entries in the PAT list!
> >
> > This delay may be due to the overhead of parsing this linked list
> > everytime for a new entry, rather than any problem with cache setting
> > itself.
> >
> > I am working on a patch to optimize this pat list parsing for the
> > simple case. Should be able to send it out later today, for testing.
> 
> Thanks for the reply. It's with 64MB of AGP memory which I guess is at
> the low end these days. Would your reply mean that basically everyone on
> 2.6.27 should now be experiencing this?
> 
> I noticed it was PAT related due to Shaohua Li's:
> 
> http://marc.info/?l=linux-kernel&m=121783222306075&w=2
> 
> which lists very different times (patch there did not help any).
> 
> As another by the way, probably not surprising but I earlier also tried
>   both unmounting and completely compiling out debugfs just in case I
> was seeing a debugging related sysmptom. No help either.
> 
> It's evening here so I'll probably not be able to test until tomorrow.
> 

Below is the patch I am testing. Let me know if this patch helps.

Thanks,
Venki


Test patch. Adds cached_entry to list add routine, in order to speed up the
lookup for sequential reserve_memtype calls.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-08-19 15:21:07.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-08-19 16:00:52.000000000 -0700
@@ -207,6 +207,9 @@ static int chk_conflict(struct memtype *
 	return -EBUSY;
 }
 
+static struct memtype *cached_entry;
+static u64 cached_start;
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -280,11 +283,17 @@ int reserve_memtype(u64 start, u64 end, 
 
 	spin_lock(&memtype_lock);
 
+	if (cached_entry && start >= cached_start)
+		entry = cached_entry;
+	else
+		entry = list_entry(&memtype_list, struct memtype, nd);
+
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
-	list_for_each_entry(entry, &memtype_list, nd) {
+	list_for_each_entry_continue(entry, &memtype_list, nd) {
 		if (end <= entry->start) {
 			where = entry->nd.prev;
+			cached_entry = list_entry(where, struct memtype, nd);
 			break;
 		} else if (start <= entry->start) { /* end > entry->start */
 			err = chk_conflict(new, entry, new_type);
@@ -292,6 +301,8 @@ int reserve_memtype(u64 start, u64 end, 
 				dprintk("Overlap at 0x%Lx-0x%Lx\n",
 					entry->start, entry->end);
 				where = entry->nd.prev;
+				cached_entry = list_entry(where,
+							struct memtype, nd);
 			}
 			break;
 		} else if (start < entry->end) { /* start > entry->start */
@@ -299,7 +310,20 @@ int reserve_memtype(u64 start, u64 end, 
 			if (!err) {
 				dprintk("Overlap at 0x%Lx-0x%Lx\n",
 					entry->start, entry->end);
-				where = &entry->nd;
+				cached_entry = list_entry(entry->nd.prev,
+							struct memtype, nd);
+
+				/*
+				 * Move to right position in the linked
+				 * list to add this new entry
+				 */
+				list_for_each_entry_continue(entry,
+							&memtype_list, nd) {
+					if (start <= entry->start) {
+						where = entry->nd.prev;
+						break;
+					}
+				}
 			}
 			break;
 		}
@@ -314,6 +338,8 @@ int reserve_memtype(u64 start, u64 end, 
 		return err;
 	}
 
+	cached_start = start;
+
 	if (where)
 		list_add(&new->nd, where);
 	else
@@ -343,6 +369,9 @@ int free_memtype(u64 start, u64 end)
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
+			if (cached_entry == entry || cached_start == start)
+				cached_entry = NULL;
+
 			list_del(&entry->nd);
 			kfree(entry);
 			err = 0;
