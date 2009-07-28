Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZG1RSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZG1RSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZG1RSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:21 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:28292
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753272AbZG1RSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:04 -0400
X-SpamScore: 11
X-BigFish: VPS11(zz78fbpzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DR-04-A2P-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 20/26] x86/oprofile: Add function has_mux() to check multiplexing support
Date: Tue, 28 Jul 2009 19:07:20 +0200
Message-ID: <1248800846-25422-21-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:50.0744 (UTC) FILETIME=[55D4B980:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check is used to prevent running multiplexing code for models not
supporting multiplexing. Before, the code was running but without
effect.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 82ee295..dca7240 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -124,6 +124,11 @@ static void nmi_stop(void)
 
 static DEFINE_PER_CPU(int, switch_index);
 
+static inline int has_mux(void)
+{
+	return !!model->switch_ctrl;
+}
+
 inline int op_x86_phys_to_virt(int phys)
 {
 	return __get_cpu_var(switch_index) + phys;
@@ -132,6 +137,10 @@ inline int op_x86_phys_to_virt(int phys)
 static void nmi_shutdown_mux(void)
 {
 	int i;
+
+	if (!has_mux())
+		return;
+
 	for_each_possible_cpu(i) {
 		kfree(per_cpu(cpu_msrs, i).multiplex);
 		per_cpu(cpu_msrs, i).multiplex = NULL;
@@ -144,12 +153,17 @@ static int nmi_setup_mux(void)
 	size_t multiplex_size =
 		sizeof(struct op_msr) * model->num_virt_counters;
 	int i;
+
+	if (!has_mux())
+		return 1;
+
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).multiplex =
 			kmalloc(multiplex_size, GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).multiplex)
 			return 0;
 	}
+
 	return 1;
 }
 
@@ -158,6 +172,9 @@ static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 	int i;
 	struct op_msr *multiplex = msrs->multiplex;
 
+	if (!has_mux())
+		return;
+
 	for (i = 0; i < model->num_virt_counters; ++i) {
 		if (counter_config[i].enabled) {
 			multiplex[i].saved = -(u64)counter_config[i].count;
@@ -229,7 +246,7 @@ static int nmi_multiplex_on(void)
 
 static int nmi_switch_event(void)
 {
-	if (!model->switch_ctrl)
+	if (!has_mux())
 		return -ENOSYS;		/* not implemented */
 	if (nmi_multiplex_on() < 0)
 		return -EINVAL;		/* not necessary */
-- 
1.6.3.3


