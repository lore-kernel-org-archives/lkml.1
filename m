Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbZKZMPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbZKZMPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZKZMPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:15:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZKZMPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:15:54 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC PATCH -tip] x86/pat: fix pat_x_mtrr_type to its essentials
Date: Thu, 26 Nov 2009 20:15:24 +0800
Message-Id: <1259237724-21260-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the IA-32 SDM vol 3a "Effective Memory Type" tables, the PAT
and mtrr relations should be:
	|	UC	UC-	WC	WB	[PAT]
--------+--------------------------------------
UC	|	UC	UC(UC-)	WC	UC(UC-)
WC	|	UC	WC(UC-)	WC	WC(UC-)
WB	|	UC	UC(UC-)	WC	WB
[MTRR]
* In () is the current return value.

So, commit b6ff32, Fix pat_x_mtrr_type() to use UC_MINUS when the
mtrr type return UC. But it also made mtrr type WC use UC_MINUS.
This is not reasonable.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/pat.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index c37fd51..92e9627 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -228,10 +228,11 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type != MTRR_TYPE_WRBACK)
-			return _PAGE_CACHE_UC_MINUS;
-
-		return _PAGE_CACHE_WB;
+		if (mtrr_type == MTRR_TYPE_WRBACK)
+			return _PAGE_CACHE_WB;
+		else if (mtrr_type == MTRR_TYPE_WRCOMB)
+			return _PAGE_CACHE_WC;
+		return _PAGE_CACHE_UC_MINUS;
 	}
 
 	return req_type;
-- 
1.6.5.2

