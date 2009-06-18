Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbZFRGuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbZFRGuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761709AbZFRGtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:49:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49678 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761559AbZFRGtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:49:41 -0400
Message-ID: <4A39E383.5060100@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 15:49:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: [PATCH 4/7] ia64, kdump: Don't offline APs
References: <4A39E247.4030908@jp.fujitsu.com>
In-Reply-To: <4A39E247.4030908@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INIT on AP going to be offline have a problem.

Since psr.mc is cleared when bits in psr are set to SAL_PSR_BITS_TO_SET
in ia64_jump_to_sal(), so there is a small window that the cpu can receive
INIT even if the cpu enter there via INIT handler.  In this window we do
restore of registers for SAL, so INIT asserted here will not work properly.

It is hard to remove this window by masking INIT (i.e. setting psr.mc)
because we have to unmask it later in OS, because we have to use branch
instruction (br.ret, not rfi) to return SAL, due to OS_BOOT_RENDEZ to SAL
return convention.

I suppose this window will not be a real problem on cpu offline if we can
educate people not to push INIT button during hotplug operation.  However
only exception is a race in kdump and INIT.  Now kdump returns APs to SAL
before processing dump, but the kernel might receive INIT at that point in
time.  Such INIT might be asserted by kdump itself if an AP doesn't react
IPI soon and kdump decided to use INIT to stop the AP.

Such panic+INIT or INIT+INIT cases should be rare, but it will be happy
if we can retrieve crashdump even in such cases.  So it will be better
to stop returning APs to SAL by kdump.

I confirmed that the kdump sometime hangs by concurrent INITs (another
INIT after an INIT), and it doesn't hang after applying this patch.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org
---
 arch/ia64/kernel/crash.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index 48b69fd..eacedfc 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -142,10 +142,6 @@ kdump_cpu_freeze(struct unw_frame_info *info, void *arg)
 	atomic_inc(&kdump_cpu_frozen);
 	kdump_status[cpuid] = 1;
 	mb();
-#ifdef CONFIG_HOTPLUG_CPU
-	if (cpuid != 0)
-		ia64_jump_to_sal(&sal_boot_rendez_state[cpuid]);
-#endif
 	for (;;)
 		cpu_relax();
 }
-- 
1.6.0


