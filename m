Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZKQMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZKQMHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZKQMHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:07:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35940 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZKQMHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:07:37 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/4] powerpc: Panic on platform ppc-xicp when CONFIG_XICS not set instead of build failure
Date: Tue, 17 Nov 2009 12:07:37 +0000
Message-Id: <1258459659-11770-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_XICS is not set but CONFIG_PPC_PSERIES is, then the kernel
fails to build with

arch/powerpc/platforms/pseries/smp.c: In function ‘smp_init_pseries_xics’:
arch/powerpc/platforms/pseries/smp.c:202: error: ‘pSeries_xics_smp_ops’ undeclared (first use in this function)
arch/powerpc/platforms/pseries/smp.c:202: error: (Each undeclared identifier is reported only once
arch/powerpc/platforms/pseries/smp.c:202: error: for each function it appears in.)
make[2]: *** [arch/powerpc/platforms/pseries/smp.o] Error 1

As CONFIG_XICS is not always necessary, this patch allows the kernel to
build but the system will panic at runtime if it is found that XICS is
required.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/powerpc/platforms/pseries/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 440000c..da78ea5 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -199,7 +199,11 @@ void __init smp_init_pseries_mpic(void)
 
 void __init smp_init_pseries_xics(void)
 {
+#ifdef CONFIG_XICS
 	smp_ops = &pSeries_xics_smp_ops;
+#else
+	panic("Support for platform ppc-xicp not configured");
+#endif
 
 	smp_init_pseries();
 }
-- 
1.6.5

