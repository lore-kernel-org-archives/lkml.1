Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZKQMIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZKQMIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZKQMHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:07:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35947 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZKQMHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:07:38 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/4] powerpc: Only define smp_pSeries_cpu_bootable when CONFIG_XICS is set
Date: Tue, 17 Nov 2009 12:07:38 +0000
Message-Id: <1258459659-11770-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_XICS is set, then smp_pSeries_cpu_bootable() is unnecessary.
As warnings are treated as errors, this fails to build.

This patch only defines smp_pSeries_cpu_bootable() when CONFIG_XICS is
set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/powerpc/platforms/pseries/smp.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index da78ea5..62b1141 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -130,6 +130,15 @@ static void __devinit smp_pSeries_kick_cpu(int nr)
 	paca[nr].cpu_start = 1;
 }
 
+#ifdef CONFIG_MPIC
+static struct smp_ops_t pSeries_mpic_smp_ops = {
+	.message_pass	= smp_mpic_message_pass,
+	.probe		= smp_mpic_probe,
+	.kick_cpu	= smp_pSeries_kick_cpu,
+	.setup_cpu	= smp_mpic_setup_cpu,
+};
+#endif
+#ifdef CONFIG_XICS
 static int smp_pSeries_cpu_bootable(unsigned int nr)
 {
 	/* Special case - we inhibit secondary thread startup
@@ -142,15 +151,7 @@ static int smp_pSeries_cpu_bootable(unsigned int nr)
 
 	return 1;
 }
-#ifdef CONFIG_MPIC
-static struct smp_ops_t pSeries_mpic_smp_ops = {
-	.message_pass	= smp_mpic_message_pass,
-	.probe		= smp_mpic_probe,
-	.kick_cpu	= smp_pSeries_kick_cpu,
-	.setup_cpu	= smp_mpic_setup_cpu,
-};
-#endif
-#ifdef CONFIG_XICS
+
 static struct smp_ops_t pSeries_xics_smp_ops = {
 	.message_pass	= smp_xics_message_pass,
 	.probe		= smp_xics_probe,
-- 
1.6.5

