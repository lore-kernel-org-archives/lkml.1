Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbYDXS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbYDXS5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYDXS5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:57:11 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6644 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbYDXS5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:57:09 -0400
Date: Thu, 24 Apr 2008 12:57:08 -0600
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>, lenb@kernel.org,
       linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ia64: Remove printk noise on unimplemented
	SAL_PHYSICAL_ID_INFO
Message-ID: <20080424185708.GD32553@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Luck, Tony" <tony.luck@intel.com>, lenb@kernel.org,
	linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080310222735.GA22619@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECCBFA9D@orsmsx424.amr.corp.intel.com> <20080319233140.GD16237@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECE13C6E@orsmsx424.amr.corp.intel.com> <20080326185912.GA30749@ldl.fc.hp.com> <20080421052450.GA24055@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843EC012664E0@orsmsx424.amr.corp.intel.com> <20080424184417.GA32553@ldl.fc.hp.com> <20080424185140.GB32553@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424185140.GB32553@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, next time, run checkpatch *before* sending out the patches.
Sorry for the noise.

/ac

From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 1/2] ia64: Remove printk noise on unimplemented SAL_PHYSICAL_ID_INFO

Commit 113134fcbca83619be4c68d0ca66db6093777b5d changed the flow of
control when calling PAL_LOGICAL_TO_PHYSICAL and SAL_PHYSICAL_ID_INFO.
With the change, if a platform did not implement the latter, a useless
printk would appear in the boot log:

	ia64_sal_pltid failed with -1

So let's check the return code and only printk on a true error, and do
not print anything in the unimplemented case. While we're in there,
clean up some stylistic issues too.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 arch/ia64/kernel/smpboot.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 16483be..8d86e1f 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -873,7 +873,8 @@ identify_siblings(struct cpuinfo_ia64 *c)
 	u16 pltid;
 	pal_logical_to_physical_t info;
 
-	if ((status = ia64_pal_logical_to_phys(-1, &info)) != PAL_STATUS_SUCCESS) {
+	status = ia64_pal_logical_to_phys(-1, &info);
+	if (status != PAL_STATUS_SUCCESS) {
 		if (status != PAL_STATUS_UNIMPLEMENTED) {
 			printk(KERN_ERR
 				"ia64_pal_logical_to_phys failed with %ld\n",
@@ -885,8 +886,13 @@ identify_siblings(struct cpuinfo_ia64 *c)
 		info.overview_cpp  = 1;
 		info.overview_tpc  = 1;
 	}
-	if ((status = ia64_sal_physical_id_info(&pltid)) != PAL_STATUS_SUCCESS) {
-		printk(KERN_ERR "ia64_sal_pltid failed with %ld\n", status);
+
+	status = ia64_sal_physical_id_info(&pltid);
+	if (status != PAL_STATUS_SUCCESS) {
+		if (status != PAL_STATUS_UNIMPLEMENTED)
+			printk(KERN_ERR
+				"ia64_sal_pltid failed with %ld\n",
+				status);
 		return;
 	}
 
-- 
1.5.3.1.g1e61

