Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0CDQtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:35 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:11664 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0CDQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:31 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO25-01-NBK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/9] oprofile/x86: rework error handler in nmi_setup()
Date: Thu, 4 Mar 2010 16:22:08 +0100
Message-ID: <1267716131-17908-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0254 (UTC) FILETIME=[9F3062E0:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This codes improves the error handler in nmi_setup(). Most parts of
the code are moved to allocate_msrs(). In case of an error
allocate_msrs() also frees already allocated memory. nmi_setup()
becomes easier and better extendable.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2c505ee..c0c21f2 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -295,6 +295,7 @@ static void free_msrs(void)
 		kfree(per_cpu(cpu_msrs, i).controls);
 		per_cpu(cpu_msrs, i).controls = NULL;
 	}
+	nmi_shutdown_mux();
 }
 
 static int allocate_msrs(void)
@@ -307,14 +308,21 @@ static int allocate_msrs(void)
 		per_cpu(cpu_msrs, i).counters = kzalloc(counters_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).counters)
-			return 0;
+			goto fail;
 		per_cpu(cpu_msrs, i).controls = kzalloc(controls_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).controls)
-			return 0;
+			goto fail;
 	}
 
+	if (!nmi_setup_mux())
+		goto fail;
+
 	return 1;
+
+fail:
+	free_msrs();
+	return 0;
 }
 
 static void nmi_cpu_setup(void *dummy)
@@ -342,17 +350,7 @@ static int nmi_setup(void)
 	int cpu;
 
 	if (!allocate_msrs())
-		err = -ENOMEM;
-	else if (!nmi_setup_mux())
-		err = -ENOMEM;
-	else
-		err = register_die_notifier(&profile_exceptions_nb);
-
-	if (err) {
-		free_msrs();
-		nmi_shutdown_mux();
-		return err;
-	}
+		return -ENOMEM;
 
 	/* We need to serialize save and setup for HT because the subset
 	 * of msrs are distinct for save and setup operations
@@ -374,9 +372,17 @@ static int nmi_setup(void)
 
 		mux_clone(cpu);
 	}
+
+	err = register_die_notifier(&profile_exceptions_nb);
+	if (err)
+		goto fail;
+
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
+fail:
+	free_msrs();
+	return err;
 }
 
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
@@ -421,7 +427,6 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
-	nmi_shutdown_mux();
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
-- 
1.7.0


