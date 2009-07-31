Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZGaCKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZGaCKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 22:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZGaCKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 22:10:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:45345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZGaCKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 22:10:49 -0400
Date: Fri, 31 Jul 2009 02:07:01 GMT
From: "tip-bot for Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       airlied@redhat.com, tglx@linutronix.de, glisse@freedesktop.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, airlied@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, glisse@freedesktop.org
In-Reply-To: <20090730214319.GA1889@linux-os.sc.intel.com>
References: <20090730214319.GA1889@linux-os.sc.intel.com>
Subject: [tip:x86/urgent] x86, pat: Fix set_memory_wc related corruption
Message-ID: <tip-bdc6340f4eb68295b1e7c0ade2356b56dca93d93@git.kernel.org>
Git-Commit-ID: bdc6340f4eb68295b1e7c0ade2356b56dca93d93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 31 Jul 2009 02:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdc6340f4eb68295b1e7c0ade2356b56dca93d93
Gitweb:     http://git.kernel.org/tip/bdc6340f4eb68295b1e7c0ade2356b56dca93d93
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 30 Jul 2009 14:43:19 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 30 Jul 2009 17:48:34 -0700

x86, pat: Fix set_memory_wc related corruption

Changeset 3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
that went in after 2.6.30-rc1 was a seemingly small change to _set_memory_wc()
to make it complaint with SDM requirements. But, introduced a nasty bug, which
can result in crash and/or strange corruptions when set_memory_wc is used.
One such crash reported here
http://lkml.org/lkml/2009/7/30/94

Actually, that changeset introduced two bugs.
* change_page_attr_set() takes &addr as first argument and can the addr value
  might have changed on return, even for single page change_page_attr_set()
  call. That will make the second change_page_attr_set() in this routine
  operate on unrelated addr, that can eventually cause strange corruptions
  and bad page state crash.
* The second change_page_attr_set() call, before setting _PAGE_CACHE_WC, should
  clear the earlier _PAGE_CACHE_UC_MINUS, as otherwise cache attribute will not
  be WC (will be UC instead).

The patch below fixes both these problems. Sending a single patch to fix both
the problems, as the change is to the same line of code. The change to have a
addr_copy is not very clean. But, it is simpler than making more changes
through various routines in pageattr.c.

A huge thanks to Jerome for reporting this problem and providing a simple test
case that helped us root cause the problem.

Reported-by: Jerome Glisse <glisse@freedesktop.org>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20090730214319.GA1889@linux-os.sc.intel.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/mm/pageattr.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1b734d7..895d90e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -997,12 +997,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
+	unsigned long addr_copy = addr;
+
 	ret = change_page_attr_set(&addr, numpages,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
-
 	if (!ret) {
-		ret = change_page_attr_set(&addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC), 0);
+		ret = change_page_attr_set_clr(&addr_copy, numpages,
+					       __pgprot(_PAGE_CACHE_WC),
+					       __pgprot(_PAGE_CACHE_MASK),
+					       0, 0, NULL);
 	}
 	return ret;
 }
