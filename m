Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbYCST5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbYCST5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbYCSTht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbYCSTho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:44 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 16/79] [PATCH] use APIC_INTEGRATED tests in x86_64
Date: Wed, 19 Mar 2008 14:25:11 -0300
Message-Id: <12059476482875-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476441057-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This patch does not change the behaviour of x86_64, since APIC_INTEGRATED
is always defined as (1). But the code now matches exactly i386 version
(well, this part of the code, at least)

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index cfcfd2c..d7b59d6 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -295,6 +295,15 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	unsigned long send_status, accept_status = 0;
 	int maxlvt, num_starts, j;
 
+	/*
+	 * Be paranoid about clearing APIC errors.
+	 */
+	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+		apic_read_around(APIC_SPIV);
+		apic_write(APIC_ESR, 0);
+		apic_read(APIC_ESR);
+	}
+
 	Dprintk("Asserting INIT.\n");
 
 	/*
@@ -327,7 +336,10 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	mb();
 	atomic_set(&init_deasserted, 1);
 
-	num_starts = 2;
+	if (APIC_INTEGRATED(apic_version[phys_apicid]))
+		num_starts = 2;
+	else
+		num_starts = 0;
 
 	/*
 	 * Paravirt / VMI wants a startup IPI hook here to set up the
-- 
1.5.0.6

