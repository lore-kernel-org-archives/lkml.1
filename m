Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357Ab0AMKQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0AMKQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346Ab0AMKQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:16:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49265 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab0AMKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:16:15 -0500
X-IronPort-AV: E=Sophos;i="4.49,267,1262581200"; 
   d="scan'208";a="79804931"
From: Ian Campbell <ian.campbell@citrix.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Christian Kujau <lists@nerdbynature.de>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] xen: 64 bit kernel RPL should be 0.
Date: Wed, 13 Jan 2010 10:16:08 +0000
Message-Id: <1263377768-19600-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1263377706.16526.12062.camel@zakaz.uk.xensource.com>
References: <1263377706.16526.12062.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 13 Jan 2010 10:16:14.0491 (UTC) FILETIME=[6FE696B0:01CA9439]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under Xen 64 bit guests actually run their kernel in ring 3, however the
hypervisor takes care of squashing descriptor the RPLs transparently (in
order to allow them to continue to differentiate between user and kernel
space CS using the RPL). Therefore the Xen paravirt backend should use
RPL==0 instead of 1 (or 3). Using RPL==1 causes generic arch code to
take incorrect code paths because it uses "testl $3, <CS>, je foo" type
tests for a userspace CS and this considers 1==userspace.

This issue was previously masked because get_kernel_rpl() was omitted
when setting CS in kernel_thread(). This was fixed when kernel_thread()
was unified with 32 bit in f443ff4201dd25cd4dec183f9919ecba90c8edc2.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/xen/enlighten.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2b26dd5..36daccb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1151,9 +1151,13 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* keep using Xen gdt for now; no urgent need to change it */
 
+#ifdef CONFIG_X86_32
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
+#else
+	pv_info.kernel_rpl = 0;
+#endif
 
 	/* set the limit of our address space */
 	xen_reserve_top();
-- 
1.5.6.5

