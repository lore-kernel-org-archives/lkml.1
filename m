Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbZKMX2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbZKMX2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbZKMX2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:28:21 -0500
Received: from mga06.intel.com ([134.134.136.21]:11893 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932414AbZKMX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,739,1249282800"; 
   d="scan'208";a="569382162"
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
       Tim Starling <tstarling@wikimedia.org>,
       Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 3/5] x86, pageattr: make set_memory_(x|nx) aware of NX support
Date: Fri, 13 Nov 2009 15:28:15 -0800
Message-Id: <1258154897-6770-4-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258154897-6770-1-git-send-email-hpa@zytor.com>
References: <1258154897-6770-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make set_memory_x/set_memory_nx directly aware of if NX is supported
in the system or not, rather than requiring that every caller assesses
that support independently.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Starling <tstarling@wikimedia.org>
Cc: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kernel/machine_kexec_32.c |    6 ++----
 arch/x86/mm/pageattr.c             |    6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index c1c429d..03657e7 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -157,8 +157,7 @@ int machine_kexec_prepare(struct kimage *image)
 {
 	int error;
 
-	if (nx_enabled)
-		set_pages_x(image->control_code_page, 1);
+	set_pages_x(image->control_code_page, 1);
 	error = machine_kexec_alloc_page_tables(image);
 	if (error)
 		return error;
@@ -172,8 +171,7 @@ int machine_kexec_prepare(struct kimage *image)
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
-	if (nx_enabled)
-		set_pages_nx(image->control_code_page, 1);
+	set_pages_nx(image->control_code_page, 1);
 	machine_kexec_free_page_tables(image);
 }
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..442b8ac 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1069,12 +1069,18 @@ EXPORT_SYMBOL(set_memory_array_wb);
 
 int set_memory_x(unsigned long addr, int numpages)
 {
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return 0;
+
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_x);
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return 0;
+
 	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_nx);
-- 
1.6.2.5

