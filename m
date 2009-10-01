Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZJADYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZJADYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 23:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZJADYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 23:24:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:18693 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbZJADYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 23:24:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,484,1249282800"; 
   d="scan'208";a="555594875"
From: "Shi, Alex" <alex.shi@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Date: Thu, 1 Oct 2009 11:23:20 +0800
Subject: [PATCH] Fix kernel panic on i386 machine when booting with profile=2
Thread-Topic: [PATCH] Fix kernel panic on i386 machine when booting with
 profile=2
Thread-Index: AcpCQs/OijAGJ3qBRE28xebfDGU+fwAAfMpA
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA6515538BDFC7@PDSMSX501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Latest kernel has a kernel panic in booting on i386 machine when profile=2
setting in cmdline. Find it is due to 'sp' incorrect in profile_pc function.

BUG: unable to handle kernel NULL pointer dereference at 00000246
IP: [<c01288b6>] profile_pc+0x2a/0x48
*pde = 00000000
Oops: 0000 [#1] SMP

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kernel/time.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index dcb00d2..c4fedca 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -38,7 +38,12 @@ unsigned long profile_pc(struct pt_regs *regs)
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
+#ifdef CONFIG_X86_32
+		unsigned long *sp = (unsigned long *)&regs->sp;
+#else
 		unsigned long *sp = (unsigned long *)regs->sp;
+
+#endif
 		/*
 		 * Return address is either directly at stack pointer
 		 * or above a saved flags. Eflags has bits 22-31 zero,
-- 
1.5.6.2

