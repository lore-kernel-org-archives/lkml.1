Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXERCso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXERCso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbXERCsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:48:37 -0400
Received: from ozlabs.org ([203.10.76.45]:41695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbXERCsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:48:37 -0400
Subject: [PATCH 2/2] lguest update for mm: disable tsc, don't set PGE bit
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1179456224.17608.23.camel@localhost.localdomain>
References: <1179456224.17608.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 18 May 2007 12:48:23 +1000
Message-Id: <1179456503.17608.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lguest guests don't use the TSC, and so we must disable it otherwise
sched-clock.c barfs.

Also, we no longer need to explicitly set the PGE feature bit:
cpu_detect->cpuid->lguest_cpuid does that for us now that cpu_detect
uses paravirt_ops (IIRC it used to do a direct cpuid from assembler).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r fd2ae7085ca2 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Fri May 18 11:04:27 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri May 18 12:11:16 2007 +1000
@@ -504,10 +504,10 @@ __init void lguest_init(void *boot)
 	reserve_top_address(lguest_data.reserve_mem);
 
 	cpu_detect(&new_cpu_data);
-	/* Need this before paging_init. */
-	set_bit(X86_FEATURE_PGE, new_cpu_data.x86_capability);
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
+
+	tsc_disable = 1;
 
 #ifdef CONFIG_X86_MCE
 	mce_disabled = 1;


