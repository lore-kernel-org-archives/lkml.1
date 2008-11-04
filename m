Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYKDP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYKDP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYKDP1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:27:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60538 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYKDP1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:27:23 -0500
Date: Tue, 4 Nov 2008 10:27:20 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mark.langsdorf@amd.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20081104152720.9964.71959.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH] Warn of incorrect cpu_khz on AMD systems
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If none of the perfctrs are free when calculating cpu_khz we default to using
ctr 3 (ie, we just choose 3).  This may lead to an incorrect tsc freq value
which can cause the system to be unstable.

To aid in future debugging, WARN the user of a potential problem.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index cb19d65..86d71b3 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -80,6 +80,8 @@ unsigned long __init calibrate_cpu(void)
 			break;
 	no_ctr_free = (i == 4);
 	if (no_ctr_free) {
+		printk(KERN_WARN "Warning: AMD perfctrs busy ... "
+		       "cpu_khz value may be incorrect.\n");
 		i = 3;
 		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
 		wrmsrl(MSR_K7_EVNTSEL3, 0);
