Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYFHNrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYFHNrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYFHNp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:45:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:43000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYFHNp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:45:56 -0400
Message-Id: <20080608134629.963591078@halley.suse.de>
User-Agent: quilt/0.46_cvs20080326-16
Date: Sun, 08 Jun 2008 15:46:31 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, vgoyal@redhat.com, anderson@redhat.com
Subject: [patch 3/3] Use reserve_bootmem_generic() to reserve crashkernel memory on x86_64
References: <20080608134628.757299158@halley.suse.de>
Content-Disposition: inline; filename=use-bootmem-generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses reserve_bootmem_generic() instead of reserve_bootmem()
to reserve the crashkernel memory on x86_64. That's necessary for NUMA
machines, see 00212fef814612245ed0261cbac8426d0c9a31a5:

  [PATCH] Fix kdump Crash Kernel boot memory reservation for NUMA machines

  This patch will fix a boot memory reservation bug that trashes memory on
  the ES7000 when loading the kdump crash kernel.

  The code in arch/x86_64/kernel/setup.c to reserve boot memory for the crash
  kernel uses the non-numa aware "reserve_bootmem" function instead of the
  NUMA aware "reserve_bootmem_generic".  I checked to make sure that no other
  function was using "reserve_bootmem" and found none, except the ones that
  had NUMA ifdef'ed out.

  I have tested this patch only on an ES7000 with NUMA on and off (numa=off)
  in a single (non-NUMA) and multi-cell (NUMA) configurations.

  Signed-off-by: Amul Shah <amul.shah@unisys.com>
  Looks-good-to: Vivek Goyal <vgoyal@in.ibm.com>
  Cc: Andi Kleen <ak@muc.de>
  Signed-off-by: Andrew Morton <akpm@osdl.org>
  Signed-off-by: Linus Torvalds <torvalds@osdl.org>

The switch-back to reserve_bootmem() was accidentally introduced in
5c3391f9f749023a49c64d607da4fb49263690eb when adding the BOOTMEM_EXCLUSIVE
parameter.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -243,7 +243,7 @@ static void __init reserve_crashkernel(v
 			return;
 		}
 
-		if (reserve_bootmem(crash_base, crash_size,
+		if (reserve_bootmem_generic(crash_base, crash_size,
 					BOOTMEM_EXCLUSIVE) < 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"memory is in use\n");

