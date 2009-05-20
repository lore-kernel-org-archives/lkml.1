Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZETSpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZETSpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZETSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:44:24 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:46865 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757204AbZETSoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:44:23 -0400
X-BigFish: VPS2(zzzz1202hzz5a6ciz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KJYHD4-02-V43-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/4] x86: msr.h: fix build error
Date: Wed, 20 May 2009 20:43:54 +0200
Message-ID: <1242845037-1029-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 May 2009 18:43:59.0169 (UTC) FILETIME=[EFF30B10:01C9D97A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

Fix this build error:
.../asm/msr.h: In function 'rdmsr_on_cpus':
.../asm/msr.h:248: error: request for member 'l' in something not a structure or union
.../asm/msr.h:248: error: request for member 'h' in something not a structure or union
.../asm/msr.h:248: error: too few arguments to function 'rdmsr_on_cpu'
.../asm/msr.h: In function 'wrmsr_on_cpus':
.../asm/msr.h:253: error: request for member 'l' in something not a structure or union
.../asm/msr.h:253: error: request for member 'h' in something not a structure or union
.../asm/msr.h:253: error: too few arguments to function 'wrmsr_on_cpu'

This is !SMP code so `cpu` should be 0.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index e49c14e..fa082ba 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -243,14 +243,14 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	return 0;
 }
 static inline int rdmsr_on_cpus(const cpumask_t *m, u32 msr_no,
-				struct msr **msrs)
+				struct msr *msrs)
 {
-	return rdmsr_on_cpu(msr_no, &(msrs[0].l), &(msrs[0].h));
+	return rdmsr_on_cpu(0, msr_no, &(msrs[0].l), &(msrs[0].h));
 }
 static inline int wrmsr_on_cpus(const cpumask_t *m, u32 msr_no,
-				struct msr **msrs)
+				struct msr *msrs)
 {
-	return wrmsr_on_cpu(msr_no, msrs[0].l, msrs[0].h);
+	return wrmsr_on_cpu(0, msr_no, msrs[0].l, msrs[0].h);
 }
 static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no,
 				    u32 *l, u32 *h)
-- 
1.6.2.4


