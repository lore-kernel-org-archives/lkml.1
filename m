Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbXF2Bam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbXF2Bam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 21:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbXF2Bae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 21:30:34 -0400
Received: from ozlabs.org ([203.10.76.45]:44587 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbXF2Bae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 21:30:34 -0400
Subject: [PATCH] lguest: fix TSC "divide error: 0000 [#1]" boot crash
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 11:30:33 +1000
Message-Id: <1183080633.7803.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Configuring a guest with < CONFIG_M586TSC reveals an lguest bug: the
TSC code expects to see the TSC capability bit, but we weren't setting
up the capabilities until much later in check_bugs ->
identify_boot_cpu -> identify_boot_cpu.

Do the same thing as Xen and the head.S native code: populate the
first capability word before start_kernel().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 7743cd1639b7 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Thu Jun 28 23:21:41 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri Jun 29 06:23:59 2007 +1000
@@ -598,6 +598,9 @@ __init void lguest_init(void *boot)
 	paravirt_disable_iospace();
 
 	cpu_detect(&new_cpu_data);
+	/* head.S usually sets up the first capability word, so do it here. */
+	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+	
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
 


