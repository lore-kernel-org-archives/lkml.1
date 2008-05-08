Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbYEHT0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbYEHT0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYEHTZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:25:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:30210 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYEHTZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,456,1204531200"; 
   d="scan'208";a="279366761"
Date: Thu, 8 May 2008 12:25:55 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080508192555.GA8643@linux-os.sc.intel.com>
References: <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 06:18:48AM -0700, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
> >Sent: Thursday, May 08, 2008 12:09 AM
> >To: Pallipadi, Venkatesh
> >Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
> >Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
> >xf86MapVidMem error
> >
> >Pallipadi, Venkatesh a écrit :
> >>  
> >> One more piece of data I need. Can you please send the 
> >output of `cat /proc/mtrr` from this system (after the X 
> >failure has happened)
> >>
> >> Thanks,
> >> Venki
> >>
> >>   
> >Hi Venki,
> >
> >
> >See my /proc/mtrr file attached.
> >
> 
> OK. Thanks for all the info.
> 
> I think I figured out what is going wrong here:
> 1) uvesafb is mapping 0xf0000000-0xf1000000
> [4294014.924303] reserve_memtype added 0xf0000000-0xf1000000, track
> uncached-minus, req uncached-minus, ret uncached-minus
> 
> 2) Set up the framebuffer within that mapped region. Uvesafb is setting
> "write-combine" mtrr for framebuffer for this 16M. 0xf0000000-0xf1000000
> [4294015.649340] uvesafb: framebuffer at 0xf0000000, mapped to
> 0xffffc20010a80000, using 16384k, total 16384k
> [4294015.649340] fb0: VESA VGA frame buffer device
> 
> 3) Later when X starts up, it tries to map bigger PCI range
> 0xf0000000-0xf8000000 from /dev/mem.
> 
> 4) PAT check tries to make sure the entire region being mmap'ed is of the
> same effective memory type. But in this case start of the address
> (0xf0000000) is write-combine and end of the address is uncached. So,
> with the new PAT code mmap fails with EINVAL, resulting in X failure.
> xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Invalid
> argument)
> 
> 
> Now we need to figure out a clean solution for this problem. I think we
> don't have to check the full range of address is of same type as long as we
> are requesting for PAT type UC_MINUS and MTRR has WC sub ranges. But, we
> need to think about other such conflict conditiond when having multiple
> users of same range (uvesafb and X) also. Will be back with a patch for
> you to try and test.
> 

Hi,

Can you please check whether the patch below solves this problem. Also, please
send in 'dmesg' and /proc/mtrr output after you boot with this patch.

Thanks,
Venki


Use UC_MINUS in reserve_memtype call with -1, when MTRR lookup fails for any
reason.

Change the logic in mtrr_type_lookup to just get the type from the start
address. Using start and end adddress is not right/complete as start and
end can be covered by different mtrr (where old code will fail) or
start and end can be in same mtrr, but still have some different
memory type region in between. Using only start is less restrictive and
deterministic.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    7 ++-----
 arch/x86/mm/pat.c                  |    8 +-------
 2 files changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c	2008-05-02 09:45:23.000000000 -0700
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c	2008-05-08 12:22:16.000000000 -0700
@@ -48,7 +48,6 @@ module_param_named(show, mtrr_show, bool
 /*
  * Returns the effective MTRR type for the region
  * Error returns:
- * - 0xFE - when the range is "not entirely covered" by _any_ var range MTRR
  * - 0xFF - when MTRR is not enabled
  */
 u8 mtrr_type_lookup(u64 start, u64 end)
@@ -96,7 +95,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 
 	prev_match = 0xFF;
 	for (i = 0; i < num_var_ranges; ++i) {
-		unsigned short start_state, end_state;
+		unsigned short start_state;
 
 		if (!(mtrr_state.var_ranges[i].mask_lo & (1 << 11)))
 			continue;
@@ -107,9 +106,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 		       (mtrr_state.var_ranges[i].mask_lo & PAGE_MASK);
 
 		start_state = ((start & mask) == (base & mask));
-		end_state = ((end & mask) == (base & mask));
-		if (start_state != end_state)
-			return 0xFE;
+		/* Just check the type of start address */
 
 		if ((start & mask) != (base & mask)) {
 			continue;
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-05-07 13:35:56.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-05-08 12:22:35.000000000 -0700
@@ -162,10 +162,6 @@ static int pat_x_mtrr_type(u64 start, u6
 		*ret_prot = prot;
 		return 0;
 	}
-	if (mtrr_type == 0xFE) {		/* MTRR match error */
-		*ret_prot = _PAGE_CACHE_UC;
-		return -1;
-	}
 	if (mtrr_type != MTRR_TYPE_UNCACHABLE &&
 	    mtrr_type != MTRR_TYPE_WRBACK &&
 	    mtrr_type != MTRR_TYPE_WRCOMB) {	/* MTRR type unhandled */
@@ -244,9 +240,7 @@ int reserve_memtype(u64 start, u64 end, 
 		 * no match.
 		 */
 		u8 mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == 0xFE) { /* MTRR match error */
-			err = -1;
-		}
+		/* MTRR lookup failed - Use UC_MINUS*/
 
 		if (mtrr_type == MTRR_TYPE_WRBACK) {
 			req_type = _PAGE_CACHE_WB;
