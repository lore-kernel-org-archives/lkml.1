Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZGIHOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZGIHOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZGIHOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:14:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZGIHOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:14:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A5598D4.3060001@jp.fujitsu.com>
Date: Thu, 09 Jul 2009 16:14:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org, "Luck, Tony" <tony.luck@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: [PATCH v2 4/7] ia64, kdump: Don't return APs to SAL from kdump
References: <4A39E247.4030908@jp.fujitsu.com> <4A5595F3.2050609@jp.fujitsu.com>
In-Reply-To: <4A5595F3.2050609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary:

  Asserting INIT on cpu going to be offline will result in unexpected
  behavior.  It will be a real problem in kdump cases where INIT might
  be asserted to unstable APs going to be offline by returning to SAL.

Description:

  Since psr.mc is cleared when bits in psr are set to SAL_PSR_BITS_TO_SET
  in ia64_jump_to_sal(), there is a small window (~few msecs) that the
  cpu can receive INIT even if the cpu enter there via INIT handler.
  In this window we do restore of registers for SAL, so INIT asserted
  here will not work properly.

  It is hard to remove this window by masking INIT (i.e. setting psr.mc)
  because we have to unmask it later in OS, because we have to use branch
  instruction (br.ret, not rfi) to return SAL, due to OS_BOOT_RENDEZ to
  SAL return convention.

  I suppose this window will not be a real problem on cpu offline if we
  can educate people not to push INIT button during hotplug operation.
  However, only exception is a race in kdump and INIT.  Now kdump returns
  APs to SAL before processing dump, but the kernel might receive INIT at
  that point in time.  Such INIT might be asserted by kdump itself if an
  AP doesn't react IPI soon and kdump decided to use INIT to stop the AP.
  Or it might be asserted by operator or an external agent to start dump
  on the unstable system.

  Such panic+INIT or INIT+INIT cases should be rare, but it will be happy
  if we can retrieve crashdump even in such cases.

How to reproduce:

  panic+INIT or INIT+INIT, with kdump configured

Expected results:

  crashdump is retrieved anyway

Actual results:

  panic, hang etc. (unexpected)

Proposed fix

  To avoid the window on the way to SAL, this patch stops returning APs
  to SAL in case of kdump.  In other words, this patch makes APs spin
  in OS instead of spinning in SAL.

  (* Note: What impact would be there?  If a cpu is spinning in SAL,
   the cpu is in BOOT_RENDEZ loop, as same as offlined cpu.
   In theory if an INIT is asserted there, cpus in the BOOT_RENDEZ loop
   should not invoke OS_INIT on it.  So in either way, no matter where
   the cpu is spinning actually in, once cpu starts spin and act as
   "frozen," INIT on the cpu have no effects.
   From another point of view, all debug information on the cpu should
   have stored to memory before the cpu start to be frozen.  So no more
   action on the cpu is required.)

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
index 3f3a579..b2a8b3d 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -140,10 +140,6 @@ kdump_cpu_freeze(struct unw_frame_info *info, void *arg)
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


