Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbXGYPWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbXGYPWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761072AbXGYPWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:22:04 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:65329 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747AbXGYPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:22:02 -0400
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: prasanna@in.ibm.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       anil.s.keshavamurthy@intel.com, jkenisto@us.ibm.com,
       systemtap@sources.redhat.com, ak@suse.de
Subject: Re: [RFC] [PATCH] To vunmap correct address in text_poke()(kprobes)
Date: Wed, 25 Jul 2007 20:51:50 +0530
User-Agent: KMail/1.9.6
Cc: suzuki@in.ibm.com
References: <200707251221.49827.srinivasa@in.ibm.com> <20070725141117.GA7254@in.ibm.com>
In-Reply-To: <20070725141117.GA7254@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707252051.50412.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resending patch according to Prasanna's suggestion, CC'ing Andi Kleen.

Hit this issue when testing kprobes on x86_64 systems. We need to align 
vunmap() address to a page boundary in text_poke(). Patch below
==============================
Trying to vfree() bad address (ffffc20002233199)
WARNING: at mm/vmalloc.c:330 __vunmap()
 
  Call Trace:
  [<ffffffff8023d199>] sys_gettimeofday+0x0/0x62
   [<ffffffff8047636c>] text_poke+0x119/0x124
   [<ffffffff80476b42>] arch_arm_kprobe+0x1c/0x21
   [<ffffffff80477cfd>] __register_kprobe+0x28a/0x2ed
   [<ffffffff8815a039>] :gettimeofday:kprobe_init+0x39/0x65
   [<ffffffff8025b5cf>] sys_init_module+0x1626/0x1788
   [<ffffffff802aaf12>] dput+0x3f/0xfa
   [<ffffffff8026bf91>] audit_syscall_entry+0x141/0x174
   [<ffffffff8020bee5>] tracesys+0xdc/0xe1
========================================

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Suzuki K P   <suzuki@in.ibm.com>
Signed-off-by: Prasanna S Panchamukhi <prasanna@in.ibm.com>

Index: linux-2.6.23-rc1/arch/i386/kernel/alternative.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/i386/kernel/alternative.c	2007-07-23 
02:11:00.000000000 +0530
+++ linux-2.6.23-rc1/arch/i386/kernel/alternative.c	2007-07-25 
20:27:13.000000000 +0530
@@ -447,5 +447,5 @@ void __kprobes text_poke(void *oaddr, un
 	if (cpu_has_clflush)
 		asm("clflush (%0) " :: "r" (oaddr) : "memory");
 	if (addr != oaddr)
-		vunmap(addr);
+		vunmap((u8 *)((unsigned long)addr & PAGE_MASK));
 }


