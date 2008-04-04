Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYDDXt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYDDXt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYDDXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:49:16 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49138 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbYDDXtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:49:15 -0400
Subject: [PATCH] Fix paranoia about using BIOS quickboot mechanism.
From: Alok Kataria <akataria@vmware.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Daniel Arai <arai@vmware.com>,
       Zachary Amsden <zach@vmware.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: VMware, Inc.
Date: Fri, 04 Apr 2008 16:49:14 -0700
Message-Id: <1207352954.6294.30.camel@promb-2n-dhcp158.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make sure that we clear the "shutdown status flag" in the CMOS register
after each CPU is brought up.  This fixes a problem where the "shutdown
status flag" may remain set when a CPU is brought up after booting.

Tested on the X86 tree.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Arai <arai@vmware.com>

---
arch/x86/kernel/smpboot.c |   10 +++++-----
1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5321e35..0b8bba8 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1010,6 +1010,11 @@ do_rest:
/* mark "stuck" area as not stuck */
*((volatile unsigned long *)trampoline_base) = 0;

+ /*
+ * Cleanup possible dangling ends...
+ */
+ smpboot_restore_warm_reset_vector();
+
return boot_error;
}

@@ -1263,11 +1268,6 @@ void __init native_smp_prepare_boot_cpu(void)

void __init native_smp_cpus_done(unsigned int max_cpus)
{
- /*
- * Cleanup possible dangling ends...
- */
- smpboot_restore_warm_reset_vector();
-
Dprintk("Boot done.\n");

impress_friends();
-- 
1.5.4




