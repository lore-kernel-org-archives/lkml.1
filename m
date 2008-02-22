Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYBVQXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYBVQXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbYBVQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:23:09 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:18383 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbYBVQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:23:07 -0500
X-IronPort-AV: E=Sophos;i="4.25,392,1199685600"; 
   d="scan'208";a="550885675"
Date: Fri, 22 Feb 2008 10:22:52 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: akpm@linux-foundation.org, hpa@zytor.com,
       Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] add default mode CONFIG_EDD_OFF=n, override with edd={on,off}
Message-ID: <20080222162252.GB32088@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please add to -mm and forward during the the 2.6.27 merge window.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux

>From 5c8fa0705c7f55ec5ae1b7da874029fe2000c595 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 22 Feb 2008 06:59:39 -0700
Subject: [PATCH] add default mode CONFIG_EDD_OFF=n, override with edd={on,off}

UBUNTU: Implemented default EDD control
OriginalAuthor: Tim Gardner <tim.gardner@canonical.com>

Add a kernel parameter option to 'edd' to enable/disable BIOS Enhanced Disk Drive Services.
CONFIG_EDD_OFF disables EDD while still compiling EDD into the kernel. Default
behavior can be forced using 'edd=on' or 'edd=off' as  a kernel parameter.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
---
 Documentation/kernel-parameters.txt |    3 +--
 arch/x86/boot/edd.c                 |   10 +++++++++-
 drivers/firmware/Kconfig            |    9 +++++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9a5b665..3e6f0f5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -625,8 +625,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	eata=		[HW,SCSI]
 
 	edd=		[EDD]
-			Format: {"of[f]" | "sk[ipmbr]"}
-			See comment in arch/i386/boot/edd.S
+			Format: {"off" | "on" | "sk[ipmbr]"}
 
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index 8721dc4..4191805 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -128,17 +128,25 @@ void query_edd(void)
 {
 	char eddarg[8];
 	int do_mbr = 1;
+#ifdef CONFIG_EDD_OFF
+	int do_edd = 0;
+#else
 	int do_edd = 1;
+#endif
 	int be_quiet;
 	int devno;
 	struct edd_info ei, *edp;
 	u32 *mbrptr;
 
 	if (cmdline_find_option("edd", eddarg, sizeof eddarg) > 0) {
-		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip"))
+		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip")) {
+			do_edd = 1;
 			do_mbr = 0;
+		}
 		else if (!strcmp(eddarg, "off"))
 			do_edd = 0;
+		else if (!strcmp(eddarg, "on"))
+			do_edd = 1;
 	}
 
 	be_quiet = cmdline_find_option_bool("quiet");
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 05f02a3..c28e33f 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -17,6 +17,15 @@ config EDD
           obscure configurations. Most disk controller BIOS vendors do
           not yet implement this feature.
 
+config EDD_OFF
+	bool "Sets default behavior for EDD detection to off"
+	depends on EDD
+	default n
+	help
+	  Say Y if you want EDD disabled by default, even though it is compiled into the
+	  kernel. Say N if you want EDD enabled by default. EDD can be dynamically set
+	  using the kernel parameter 'edd={on|skipmbr|off}'.
+
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI
-- 
1.5.4.1

