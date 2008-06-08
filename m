Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYFHOPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYFHOPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 10:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYFHOPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 10:15:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYFHOPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 10:15:31 -0400
Date: Sun, 8 Jun 2008 16:16:07 +0200
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, anderson@redhat.com,
       hpa@zytor.com, tglx@linutronix.de, vgoyal@redhat.com
Subject: [patch] [PATCH] Use BOOTMEM_EXCLUSIVE for i386
Message-ID: <20080608141607.GA25743@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, mingo@redhat.com, anderson@redhat.com,
	hpa@zytor.com, tglx@linutronix.de, vgoyal@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
From: bwalle@suse.de (Bernhard Walle)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the BOOTMEM_EXCLUSIVE for crashkernel reservation also for i386
and prints a error message on failure.

The patch is still for 2.6.26 since it is only bug fixing. The unification of
reserve_crashkernel() between i386 and x86_64 should be done for 2.6.27.



Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/setup_32.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -532,10 +532,16 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(crash_size >> 20),
 					(unsigned long)(crash_base >> 20),
 					(unsigned long)(total_mem >> 20));
+
+			if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+				printk(KERN_INFO "crashkernel reservation "
+					"failed - memory is in use\n");
+				return;
+			}
+
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
