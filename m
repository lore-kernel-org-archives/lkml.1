Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZGXHw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZGXHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGXHw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:52:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:48962 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbZGXHw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:52:58 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, venkatesh.pallipadi@intel.com,
       Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH] x86: Use clflush() instead of wbinvd() whenever possible when changing mapping
Date: Fri, 24 Jul 2009 09:53:01 +0200
Message-Id: <1248421981-31865-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code uses wbinvd() when the area to flush is > 4MB. Although this
may be faster than using clflush() the effect of wbinvd() on irq latencies
may be catastrophical on systems with large caches. Therefore use clflush()
whenever possible and accept the slight performance hit.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 arch/x86/mm/pageattr.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1b734d7..d4327db 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -209,13 +209,12 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
-	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
 
 	BUG_ON(irqs_disabled());
 
-	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
+	on_each_cpu(__cpa_flush_all, (void *) 0UL, 1);
 
-	if (!cache || do_wbinvd)
+	if (!cache)
 		return;
 
 	/*
-- 
1.6.1.3

