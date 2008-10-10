Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYJJK14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYJJK14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYJJK1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:27:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3135 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYJJK1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:27:46 -0400
X-IronPort-AV: E=Sophos;i="4.33,389,1220241600"; 
   d="scan'208";a="23311677"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Signed-off-by: Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH] xen: do not reserve 2 pages of padding between hypervisor and fixmap.
Date: Fri, 10 Oct 2008 11:27:38 +0100
Message-Id: <1223634458-25820-1-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 10 Oct 2008 10:27:44.0029 (UTC) FILETIME=[D4E0BCD0:01C92AC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reserving space for the hypervisor the Xen paravirt backend adds
an extra two pages (this was carried forward from the 2.6.18-xen tree
which had them "for safety"). Depending on various CONFIG options this
can cause the boot time fixmaps to span multiple PMDs which is not
supported and triggers a WARN in early_ioremap_init().

This was exposed by 2216d199b1430d1c0affb1498a9ebdbd9c0de439 which
moved the dmi table parsing earlier.
    x86: fix CONFIG_X86_RESERVE_LOW_64K=y

    The bad_bios_dmi_table() quirk never triggered because we do DMI setup
    too late. Move it a bit earlier.

There is no real reason to reserve these two extra pages and the
fixmap already incorporates FIX_HOLE which serves the same
purpose. None of the other callers of reserve_top_address do this.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bd6b50a..e8df41a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1401,7 +1401,7 @@ static void __init xen_reserve_top(void)
 	if (HYPERVISOR_xen_version(XENVER_platform_parameters, &pp) == 0)
 		top = pp.virt_start;
 
-	reserve_top_address(-top + 2 * PAGE_SIZE);
+	reserve_top_address(-top);
 #endif	/* CONFIG_X86_32 */
 }
 
-- 
1.5.6.3

