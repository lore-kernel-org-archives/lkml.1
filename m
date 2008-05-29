Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYE2TCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYE2TCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYE2TBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:01:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:64237 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYE2TBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:01:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,562,1204531200"; 
   d="scan'208";a="254191073"
Date: Thu, 29 May 2008 12:01:44 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080529190143.GA26185@linux-os.sc.intel.com>
References: <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com> <482392C4.7080901@zytor.com> <20080509003424.GA19710@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509003424.GA19710@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 05:34:24PM -0700, Pallipadi, Venkatesh wrote:
>    On Thu, May 08, 2008 at 04:54:44PM -0700, H. Peter Anvin wrote:
>    > Venki Pallipadi wrote:
>    > >
>    > >Also, note that we only look for start while looking at fixed range
>    MTRRs.
>    > >This is not as scary as it seems. We are finding the effective memory
>    type
>    > >by just looking at the start of the address range. We still go through
>    > >the PAT reserve free mechanism, once we find the effective memory type
>    > >and that list will catch any other users with conflicting type anywhere
>    > >in the start to end range. And we will still keep effective type
>    consistent
>    > >across all mappings.
>    > >
>    >
>    > So what you're saying here is "it's bogus, but it doesn't really matter
>    > anyway?"  Why bother having it at all, then?
>    >
>    > Seriously, if it's not unconditionally correct, then:
>    >
>    > a. it should be *clearly* labelled a heuristic.
>    > b. it should be *clearly* explained why having the heuristic is much
>    > better than not having anything.
>    >
>    > In this case, neither of those conditions appear to be addressed.
> 
>    Agree that is has to be called a heuristic. Yes. Not having that will work
>    may be not as optimially. Having it gives us better starting point when we
>    start to find a proper memory type for requests, especially when there are
>    no other overlapping mappings in PAT list.
> 
>    One of the reason for heristic was to get proper type for /dev/mem maps
>    for WB
>    region (ACPI and BIOS area). /dev/mem checks to see the mtrr type of the
>    start
>    address and starts with that type for the request. As long as there are no
>    other conflict in PAT list, we can give WB to this /dev/mem request. Not
>    having this heuristic we will have to most probably default to UC.
> 
>    When there are overlapping PAT list entries, the mtrr_lookup does not
>    matter
>    as we have to inherit things from those PAT entries or conflicting with
>    them.
> 
>    This discussion points to - code is not sufficiently commented and/or
>    needs
>    some refactoring. Will look at this afresh tomorrow morning and see
>    whether
>    I can some up with some better alternative.
> 


This is an alternate solution to the problem in this thread. The change
clarifies what is expected out of mtrr_lookup in PAT code and how we handle
failure.

Thanks,
Venki



Alternate patch to clarify the usage of mtrr_lookup() in PAT code, and to make
PAT code resilient to mtrr lookup problems.

Specifically, pat_x_mtrr_type() is restructured to highlight, under
what conditions we look for mtrr hint. pat_x_mtrr_type() uses a default
type when there are any errors in mtrr lookup (still maintaining the pat
consistency). And, reserve_memtype() highlights its usage ot mtrr_lookup for
request type of '-1' and also defaults in a sane way on any mtrr lookup failure.

pat.c looks at mtrr type of a range to get a hint on what mapping type
to request when user/API:
(1) hasn't specified any type (/dev/mem mapping) and we do not want to take
performance hit by always mapping UC_MINUS. This will be the case
for /dev/mem mappings used to map BIOS area or ACPI region which are WB'able.
In this case, as long as MTRR is not WB, PAT will request UC_MINUS for such
mappings.

(2) user/API requests WB mapping while in reality MTRR may have UC or WC.
In this case, PAT can map as WB (without checking MTRR) and still effective
type will be UC or WC. But, a subsequent request to map same region as
UC or WC may fail, as the region will get trackked as WB in PAT list. Looking
at MTRR hint helps us to track based on effective type rather than what user
requested. Again, here mtrr_lookup is only used as hint and we fallback to
WB mapping (as requested by user) as default.

In both cases, after using the mtrr hint, we still go through the memtype
list to make sure there are no inconsistencies among multiple users.


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/pat.c |   49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-05-28 13:19:28.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-05-28 15:18:22.000000000 -0700
@@ -151,32 +151,33 @@ static int pat_x_mtrr_type(u64 start, u6
 	unsigned long pat_type;
 	u8 mtrr_type;
 
-	mtrr_type = mtrr_type_lookup(start, end);
-	if (mtrr_type == 0xFF) {		/* MTRR not enabled */
-		*ret_prot = prot;
-		return 0;
-	}
-	if (mtrr_type == 0xFE) {		/* MTRR match error */
-		*ret_prot = _PAGE_CACHE_UC;
-		return -1;
-	}
-	if (mtrr_type != MTRR_TYPE_UNCACHABLE &&
-	    mtrr_type != MTRR_TYPE_WRBACK &&
-	    mtrr_type != MTRR_TYPE_WRCOMB) {	/* MTRR type unhandled */
-		*ret_prot = _PAGE_CACHE_UC;
-		return -1;
-	}
-
 	pat_type = prot & _PAGE_CACHE_MASK;
 	prot &= (~_PAGE_CACHE_MASK);
 
-	/* Currently doing intersection by hand. Optimize it later. */
+	/*
+	 * We return the PAT request directly for types where PAT takes
+	 * precedence with respect to MTRR and for UC_MINUS.
+	 * Consistency checks with other PAT requests is done later
+	 * while going through memtype list.
+	 */
 	if (pat_type == _PAGE_CACHE_WC) {
 		*ret_prot = prot | _PAGE_CACHE_WC;
+		return 0;
 	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
 		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
-	} else if (pat_type == _PAGE_CACHE_UC ||
-	           mtrr_type == MTRR_TYPE_UNCACHABLE) {
+		return 0;
+	} else if (pat_type == _PAGE_CACHE_UC) {
+		*ret_prot = prot | _PAGE_CACHE_UC;
+		return 0;
+	}
+
+	/*
+	 * Look for MTRR hint to get the effective type in case where PAT
+	 * request is for WB.
+	 */
+	mtrr_type = mtrr_type_lookup(start, end);
+
+	if (mtrr_type == MTRR_TYPE_UNCACHABLE) {
 		*ret_prot = prot | _PAGE_CACHE_UC;
 	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
 		*ret_prot = prot | _PAGE_CACHE_WC;
@@ -233,14 +234,12 @@ int reserve_memtype(u64 start, u64 end, 
 
 	if (req_type == -1) {
 		/*
-		 * Special case where caller wants to inherit from mtrr or
-		 * existing pat mapping, defaulting to UC_MINUS in case of
-		 * no match.
+		 * Call mtrr_lookup to get the type hint. This is an
+		 * optimization for /dev/mem mmap'ers into WB memory (BIOS
+		 * tools and ACPI tools). Use WB request for WB memory and use
+		 * UC_MINUS otherwise.
 		 */
 		u8 mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == 0xFE) { /* MTRR match error */
-			err = -1;
-		}
 
 		if (mtrr_type == MTRR_TYPE_WRBACK) {
 			req_type = _PAGE_CACHE_WB;

