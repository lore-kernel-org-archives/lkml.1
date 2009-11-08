Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZKHMYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZKHMYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZKHMYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:24:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49567 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZKHMWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:42 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Leo Chen <leochen@broadcom.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Date: Sun,  8 Nov 2009 04:22:09 -0800
Message-Id: <1257682930-31401-22-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Remove a smattering of ctl_names used in sysctl paths,
and kill the ctl_names in the recently added mach-bcmring.

mach-bcmring never should have had sysctl entries with
.ctl_name set.  The binary sysctl interface has been frozen
for a long time before that code was merged, to prevent
probmes with conflicts and lack of testing.   The sysctl_check
code would have caught this if anyone had ever tested it that way.
So I have simply dropped the binary sysctl support instead of
adding another compat entry into sysctl_binary.c.  Going through
/proc/sys/reboot/warm will still work.

Cc: Leo Chen <leochen@broadcom.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/arm/kernel/isa.c        |   11 +++--------
 arch/arm/mach-bcmring/arch.c |    6 ------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
index 8ac9b84..738dfcc 100644
--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -22,47 +22,42 @@ static unsigned int isa_membase, isa_portbase, isa_portshift;
 
 static ctl_table ctl_isa_vars[4] = {
 	{
-		.ctl_name	= BUS_ISA_MEM_BASE,
 		.procname	= "membase",
 		.data		= &isa_membase, 
 		.maxlen		= sizeof(isa_membase),
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	}, {
-		.ctl_name	= BUS_ISA_PORT_BASE,
 		.procname	= "portbase",
 		.data		= &isa_portbase, 
 		.maxlen		= sizeof(isa_portbase),
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	}, {
-		.ctl_name	= BUS_ISA_PORT_SHIFT,
 		.procname	= "portshift",
 		.data		= &isa_portshift, 
 		.maxlen		= sizeof(isa_portshift),
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
-	}, {0}
+	}, {}
 };
 
 static struct ctl_table_header *isa_sysctl_header;
 
 static ctl_table ctl_isa[2] = {
 	{
-		.ctl_name	= CTL_BUS_ISA,
 		.procname	= "isa",
 		.mode		= 0555,
 		.child		= ctl_isa_vars,
-	}, {0}
+	}, {}
 };
 
 static ctl_table ctl_bus[2] = {
 	{
-		.ctl_name	= CTL_BUS,
 		.procname	= "bus",
 		.mode		= 0555,
 		.child		= ctl_isa,
-	}, {0}
+	}, {}
 };
 
 void __init
diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
index 0da693b..f3c1119 100644
--- a/arch/arm/mach-bcmring/arch.c
+++ b/arch/arm/mach-bcmring/arch.c
@@ -47,10 +47,6 @@ HW_DECLARE_SPINLOCK(gpio)
     EXPORT_SYMBOL(bcmring_gpio_reg_lock);
 #endif
 
-/* FIXME: temporary solution */
-#define BCM_SYSCTL_REBOOT_WARM               1
-#define CTL_BCM_REBOOT                 112
-
 /* sysctl */
 int bcmring_arch_warm_reboot;	/* do a warm reboot on hard reset */
 
@@ -58,7 +54,6 @@ static struct ctl_table_header *bcmring_sysctl_header;
 
 static struct ctl_table bcmring_sysctl_warm_reboot[] = {
 	{
-	 .ctl_name = BCM_SYSCTL_REBOOT_WARM,
 	 .procname = "warm",
 	 .data = &bcmring_arch_warm_reboot,
 	 .maxlen = sizeof(int),
@@ -69,7 +64,6 @@ static struct ctl_table bcmring_sysctl_warm_reboot[] = {
 
 static struct ctl_table bcmring_sysctl_reboot[] = {
 	{
-	 .ctl_name = CTL_BCM_REBOOT,
 	 .procname = "reboot",
 	 .mode = 0555,
 	 .child = bcmring_sysctl_warm_reboot},
-- 
1.6.5.2.143.g8cc62

