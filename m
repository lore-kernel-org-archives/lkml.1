Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbXGRGR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbXGRGR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXGRGRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:17:51 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:33407 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXGRGRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:17:51 -0400
Date: Wed, 18 Jul 2007 16:17:48 +1000
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: 2.6.22-git ppc build failure
Message-ID: <20070718061748.GZ10345@bakeyournoodle.com>
References: <dda83e780707171104g10372341l7d2225f172153a6b@mail.gmail.com> <20070718010355.GV10345@bakeyournoodle.com> <alpine.LFD.0.999.0707171843370.27353@woody.linux-foundation.org> <20070718022433.GY10345@bakeyournoodle.com> <alpine.LFD.0.999.0707171927110.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707171927110.27353@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 07:27:51PM -0700, Linus Torvalds wrote:
 
> Ok, thanks. Maybe it's the merge, and maybe it's one of the sides. You 
> might want to double-check that both parents are ok before you look too 
> closely at the merge itself.

Turns out the boot failure wasn't related to the merge after all.  With
my orginal compile (and the revert below) PCI works and the kernel
boots.

Please apply both.

From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH] Revert "[POWERPC] Do firmware feature fixups after features are initialised"

This reverts commit 5a26f6bbb767d7ad23311a1e81cfdd2bebefb855.

The original patch causes boot failures when built with ppc64_defconfig.  The
quickest fix is to revert it while alterates are investigated.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 arch/powerpc/kernel/setup_64.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index bc43bba..6018178 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -350,11 +350,13 @@ void __init setup_system(void)
 {
 	DBG(" -> setup_system()\n");
 
-	/* Apply CPUs-specific fixups to kernel text (nop out sections
-	 * not relevant to this CPU)
+	/* Apply the CPUs-specific and firmware specific fixups to kernel
+	 * text (nop out sections not relevant to this CPU or this firmware)
 	 */
 	do_feature_fixups(cur_cpu_spec->cpu_features,
 			  &__start___ftr_fixup, &__stop___ftr_fixup);
+	do_feature_fixups(powerpc_firmware_features,
+			  &__start___fw_ftr_fixup, &__stop___fw_ftr_fixup);
 
 	/*
 	 * Unflatten the device-tree passed by prom_init or kexec
@@ -392,12 +394,6 @@ void __init setup_system(void)
 	if (ppc_md.init_early)
 		ppc_md.init_early();
 
-	/* Apply firmware specific fixups to kernel text (nop out
-	 * sections not relevant to this firmware)
-	 */
-	do_feature_fixups(powerpc_firmware_features,
-			  &__start___fw_ftr_fixup, &__stop___fw_ftr_fixup);
-
  	/*
 	 * We can discover serial ports now since the above did setup the
 	 * hash table management for us, thus ioremap works. We do that early
-- 
1.5.2.3


Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

