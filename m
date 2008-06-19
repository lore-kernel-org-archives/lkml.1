Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbYFSQQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbYFSQQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYFSQQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:16:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59243 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751942AbYFSQQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:16:32 -0400
To: mingo@elte.hu
Subject: [PATCHv6] SGI UV: TLB shootdown using broadcast assist unit - v6 delta
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1K9MoC-00049Z-KE@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 19 Jun 2008 11:16:24 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

TLB shootdown for SGI UV.

This patch brings the code in Ingo's x86/x86/uv (June 19,2008) to v6

v1: 6/2 original
v2: 6/3 corrections/improvements per Ingo's review
v3: 6/4 split atomic operations off to a separate patch (Jeremy's review)
v4: 6/12 include <mach_apic.h> rather than <asm/mach-bigsmp/mach_apic.h>
         (fixes a !SMP build problem)
         fix the index on uv_table_bases[blade]
v5: 6/18 corrections/improvements per Ingo's second and third reviews
         Ingo made coding improvements himself.
v6: 6/19 close the security hole in uv_ptc_proc_write())
         and adds tlb_uv.o to the Makefile

Diffed against 2.6.26-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

 Ingo,

  (18Jun)
  > Found a potential security hole while doing that:
  > static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
  >                              size_t count, loff_t *data)
  >     if (copy_from_user(optstr, user, count))
  >             return -EFAULT;
  >
  > is count guaranteed to never be larger than 64?
 is fixed below.

 It adds tlb_uv.o to the Makefile.

 And it's build-tested.

 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/tlb_uv.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -492,6 +492,8 @@ static ssize_t uv_ptc_proc_write(struct 
 	long newmode;
 	char optstr[64];
 
+	if (count > 64)
+		return -EINVAL;
 	if (copy_from_user(optstr, user, count))
 		return -EFAULT;
 	optstr[count - 1] = '\0';
Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile
+++ linux/arch/x86/kernel/Makefile
@@ -93,7 +93,7 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
-        obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_phys.o genx2apic_uv_x.o
+        obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_phys.o genx2apic_uv_x.o tlb_uv.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
 
