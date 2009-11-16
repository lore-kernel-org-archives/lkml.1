Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZKPWHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZKPWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZKPWHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:07:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:49516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZKPWHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:07:41 -0500
Date: Mon, 16 Nov 2009 22:07:12 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, tstarling@wikimedia.org,
       ying.huang@intel.com, kees.cook@canonical.com,
       suresh.b.siddha@intel.com, tj@kernel.org, hannes@hanneseder.net,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tstarling@wikimedia.org,
       ying.huang@intel.com, kees.cook@canonical.com, hannes@hanneseder.net,
       suresh.b.siddha@intel.com, tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1258154897-6770-4-git-send-email-hpa@zytor.com>
References: <1258154897-6770-4-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, pageattr: Make set_memory_(x|nx) aware of NX support
Message-ID: <tip-583140afb989f24d115e80be5c91e503b58ccfc0@git.kernel.org>
Git-Commit-ID: 583140afb989f24d115e80be5c91e503b58ccfc0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  583140afb989f24d115e80be5c91e503b58ccfc0
Gitweb:     http://git.kernel.org/tip/583140afb989f24d115e80be5c91e503b58ccfc0
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 13 Nov 2009 15:28:15 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 16 Nov 2009 13:44:58 -0800

x86, pageattr: Make set_memory_(x|nx) aware of NX support

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
LKML-Reference: <1258154897-6770-4-git-send-email-hpa@zytor.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
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
index 09a140c..1d4eb93 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1085,12 +1085,18 @@ EXPORT_SYMBOL(set_memory_array_wb);
 
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
