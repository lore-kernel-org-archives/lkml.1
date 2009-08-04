Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbZHDWeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbZHDWeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933342AbZHDWeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:34:22 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59337 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933307AbZHDWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:34:22 -0400
Subject: VMI fix for stack protector
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 04 Aug 2009 15:34:22 -0700
Message-Id: <1249425262.18955.40.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With CONFIG_STACK_PROTECTOR turned on, VMI doesn't boot with more than one
processor. The problem is with the gs value not being initialized correctly
when registering the secondary processor for VMI's case. 

The patch below initializes the gs value for the AP to __KERNEL_STACK_CANARY.
Without this the secondary processor keeps on taking a GP on every gs access.

Needs to go in for 2.6.30.x too, since STACK_PROTECTOR for 32bit was
introduced in 2.6.30.

Patch on top of 2.6.31-rc5.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: stable@kernel.org

Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c	2009-08-03 13:55:41.000000000 -0700
+++ linux-2.6/arch/x86/kernel/vmi_32.c	2009-08-04 14:13:22.000000000 -0700
@@ -442,7 +442,7 @@ vmi_startup_ipi_hook(int phys_apicid, un
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
 	ap.fs = __KERNEL_PERCPU;
-	ap.gs = 0;
+	ap.gs = __KERNEL_STACK_CANARY;
 
 	ap.eflags = 0;
 


