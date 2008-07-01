Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYGARoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYGARoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYGARoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:44:25 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:42843 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYGARoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CUlektkt9tPArnTfXGzQAeUrFhg3SphZnlC465Dy0diOZ8qreSWXmfEsdxUWkkRsPn
         i5D9UmeldS9lJOelenA5m6OrLSnAI++sthTpMcJDv/x3hqvpt87sAeODj30YI1YCOxqM
         cPeHJoFBfzdFnwqGl1Sg7JnqQ6uQlRxRssDTw=
Date: Tue, 1 Jul 2008 21:43:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: apic_32.c - add lapic resource
Message-ID: <20080701174352.GB7043@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lapic resource into kernel resource map and mark it as busy

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Maciej W. Rozycki <macro@linux-mips.org>
---

I've started to unify apic code but it will require a huge
amount of time and will not be done soon but this patch is usefull
even now I think.

Any comments are _quite__welcome_.

The patch is on top of
	commit ccbb46cbe2993e6b23244b53a5d2791c71d134f5
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Fri Jun 27 19:55:22 2008 +0200

	    stacktrace: export print_stack_trace and save_stack_trace

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-01 20:30:10.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-01 21:27:35.000000000 +0400
@@ -81,6 +81,11 @@ int pic_mode;
 /* Have we found an MP table */
 int smp_found_config;
 
+static struct resource lapic_resource = {
+	.name = "Local APIC",
+	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
+};
+
 static unsigned int calibration_result;
 
 static int lapic_next_event(unsigned long delta,
@@ -1754,3 +1759,21 @@ static int __init apic_set_verbosity(cha
 }
 __setup("apic=", apic_set_verbosity);
 
+static int __init lapic_insert_resource(void)
+{
+	if (!apic_phys)
+		return -1;
+
+	/* Put local APIC into the resource map. */
+	lapic_resource.start = apic_phys;
+	lapic_resource.end = lapic_resource.start + PAGE_SIZE - 1;
+	insert_resource(&iomem_resource, &lapic_resource);
+
+	return 0;
+}
+
+/*
+ * need call insert after e820_reserve_resources()
+ * that is using request_resource
+ */
+late_initcall(lapic_insert_resource);
