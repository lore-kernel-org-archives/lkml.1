Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYFRNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYFRNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYFRNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:39:13 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:53514 "EHLO
	mail108-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYFRNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:39:12 -0400
X-BigFish: VPS-40(zz1432R98dR4015M7efV1805Mzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2NV8E-02-AYV-01
Date: Wed, 18 Jun 2008 15:38:57 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 5/5 v2] x86: PAT: make pat_x_mtrr_type() more readable
Message-ID: <20080618133857.GB5213@alberich.amd.com>
References: <20080610140755.GI5024@alberich.amd.com> <20080616125821.GA5213@alberich.amd.com> <Pine.LNX.4.64.0806161753060.13075@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806161753060.13075@blonde.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Jun 2008 13:38:59.0047 (UTC) FILETIME=[A96E0770:01C8D148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 06:42:43PM +0100, Hugh Dickins wrote:
> On Mon, 16 Jun 2008, Andreas Herrmann wrote:
> > I've found it inconvenient to review pat_x_mtrr_type().
> > Thus I slightly changed it and added some comment to make
> > it more readable.
> 
> I found it hard to read too; but it's amusing how utterly different
> are our ideas to make it more readable.  Most of what it is doing
> seems to me confusingly left over from earlier implementations.

;-)

> I've appended my version at the bottom: my involvement in pat.c is
> not very strong, so would you like to take over my patch and combine
> best of both into one?  I don't particularly want to stroll along
> after, undoing what you did.

Why combining both patches?
I've checked your patch and found it more straightforward than mine.
And the attached patch makes it even shorter.
(patch against tip/x86/pat -- where your patch is already residing)

> > 
> > I've also added BUG statements for (some) unused/unhandled PAT/MTRR
> > types.
> 
> I suspect your pat_type BUG is uninteresting (given _PAGE_CACHE_MASK

It's just interesting if someone would change that mask and forget to
handle potential new pat_types. I admit that is rather unlikely.

> only has two bits to play with), and your mtrr_type BUG dangerous -

Well, the former code had this snippet in pat_x_mtrr_type():

-       mtrr_type = mtrr_type_lookup(start, end);
-       if (mtrr_type == 0xFF) {                /* MTRR not enabled */
-               *ret_prot = prot;
-               return 0;
-       }
-       if (mtrr_type == 0xFE) {                /* MTRR match error */
-               *ret_prot = _PAGE_CACHE_UC;
-               return -1;
-       }
-       if (mtrr_type != MTRR_TYPE_UNCACHABLE &&
-           mtrr_type != MTRR_TYPE_WRBACK &&
-           mtrr_type != MTRR_TYPE_WRCOMB) {    /* MTRR type unhandled */
-               *ret_prot = _PAGE_CACHE_UC;
-               return -1;
-       }
-

But now it seems that the function intentional handles
MTRR_TYPE_WRTHROUGH and the 0xFE/0xFF cases and thus the BUG statement
is wrong.

Thanks,

Andreas

---
[PATCH] x86: shrink pat_x_mtrr_type to its essentials

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ac3a2b1..227df3c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -161,29 +161,21 @@ static DEFINE_SPINLOCK(memtype_lock); 	/* protects memtype list */
  */
 static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 {
-	u8 mtrr_type;
-
-	/*
-	 * We return the PAT request directly for types where PAT takes
-	 * precedence with respect to MTRR and for UC_MINUS.
-	 * Consistency checks with other PAT requests is done later
-	 * while going through memtype list.
-	 */
-	if (req_type == _PAGE_CACHE_WC ||
-	    req_type == _PAGE_CACHE_UC_MINUS ||
-	    req_type == _PAGE_CACHE_UC)
-		return req_type;
-
 	/*
 	 * Look for MTRR hint to get the effective type in case where PAT
 	 * request is for WB.
 	 */
-	mtrr_type = mtrr_type_lookup(start, end);
-	if (mtrr_type == MTRR_TYPE_UNCACHABLE)
-		return _PAGE_CACHE_UC;
-	if (mtrr_type == MTRR_TYPE_WRCOMB)
-		return _PAGE_CACHE_WC;
-	return _PAGE_CACHE_WB;
+	if (req_type == _PAGE_CACHE_WB) {
+		u8 mtrr_type;
+
+		mtrr_type = mtrr_type_lookup(start, end);
+		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
+			return _PAGE_CACHE_UC;
+		if (mtrr_type == MTRR_TYPE_WRCOMB)
+			return _PAGE_CACHE_WC;
+	}
+
+	return req_type;
 }
 
 /*
-- 
1.5.5.4



