Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZCaAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZCaAVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZCaAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:21:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:15658 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZCaAVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:21:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,449,1233561600"; 
   d="scan'208";a="125883382"
Date: Mon, 30 Mar 2009 17:21:00 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 git master and PAT problems
Message-ID: <20090331002100.GA10490@linux-os.sc.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com> <1238449555.4529.1095.camel@localhost.localdomain> <200903310031.10335.a.miskiewicz@gmail.com> <200903310125.12120.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903310125.12120.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 04:25:11PM -0700, Arkadiusz Miskiewicz wrote:
> On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
> > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> >
> > More info follows. Now I've switched to
> > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm fixes
> > and now I get much lower numbers of PAT errors but still.
> 
> Also when I switch t400 into discrete mode (radeon hd 3400 instead
> of integrated intel GM45) I get such errors (probably unrelated
> to these seen when using intel):
> 
> [  419.187657] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
> [  419.187670] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
> [  419.553914] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
> [  419.553923] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
> [  419.813592] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
> [  419.813601] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
> [  420.100102] X:10550 conflicting memory types cfff0000-d0000000 uncached<->uncached-minus
> [  420.100111] reserve_memtype failed 0xcfff0000-0xd0000000, track uncached, req write-back
> 
> 

Yes. This is a different problem than the freeing invalid type one. Are these
errors also with latest git kernel? Can you try the patch below (which is
a part of a bigger cleanup patch I have lined up). 

Thanks,
Venki

From: Suresh Siddha <suresh.b.siddha@intel.com>

Fix pat_x_mtrr_type() to use UC_MINUS when the mtrr type return UC. This
is to be  consistent with ioremap() and ioremap_nocache() which uses
UC_MINUS.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/ioremap.c |    3 ++-
 arch/x86/mm/pat.c     |   35 +++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 1fca82b..e07da24 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
-			return _PAGE_CACHE_UC;
-		if (mtrr_type == MTRR_TYPE_WRCOMB)
-			return _PAGE_CACHE_WC;
+		if (mtrr_type != MTRR_TYPE_WRBACK)
+			return _PAGE_CACHE_UC_MINUS;
+
+		return _PAGE_CACHE_WB;
 	}
 
 	return req_type;

