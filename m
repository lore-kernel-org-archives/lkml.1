Return-Path: <linux-kernel-owner+w=401wt.eu-S937914AbZDJMgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937914AbZDJMgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937483AbZDJMfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:35:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:45685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937353AbZDJMfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:35:11 -0400
Date: Fri, 10 Apr 2009 12:34:32 GMT
From: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409212708.797481000@intel.com>
References: <20090409212708.797481000@intel.com>
Subject: [tip:x86/pat] x86, PAT: Changing memtype to WC ensuring no WB alias
Message-ID: <tip-3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0@git.kernel.org>
Git-Commit-ID: 3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:34:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
Gitweb:     http://git.kernel.org/tip/3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 9 Apr 2009 14:26:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:55:47 +0200

x86, PAT: Changing memtype to WC ensuring no WB alias

As per SDM, there should not be any aliasing of a WC with any cacheable
type across CPUs. That is if one CPU is changing the identity map
memtype to _WC, no other CPU at the time of this change should not have a
TLB for this page that carries a WB attribute. SDM suggests to make the
page not present. But for that we will have to handle any page faults
that can potentially happen due to these pages being not present.

Other way to deal with this without having any WB mapping is to change
the page first to UC and then to WC. This ensures that we meet the SDM
requirement of no cacheable alais to WC page. This also has same or
lower overhead than marking the page not present and making it present
later.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20090409212708.797481000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pageattr.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 985eef8..797f9f1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1000,8 +1000,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 
 int _set_memory_wc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(&addr, numpages,
+	int ret;
+	ret = change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
+
+	if (!ret) {
+		ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_WC), 0);
+	}
+	return ret;
 }
 
 int set_memory_wc(unsigned long addr, int numpages)
