Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZD1PJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZD1PJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbZD1PGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:06:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:35773 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761280AbZD1PGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:06:44 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KITGMR-01-UAQ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 14/21] amd64_edac: add msr accessors operating on all cpus
Date: Tue, 28 Apr 2009 17:06:06 +0200
Message-ID: <1240931173-17477-15-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Apr 2009 15:06:22.0912 (UTC) FILETIME=[E4B9D400:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ac4e265..49c0ce0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3121,4 +3121,46 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
 	return dev;
 }
 
+/* stolen from msr.c - the calls in msr.c could be exported */
+struct msr_command {
+	int cpu;
+	int err;
+	u32 reg;
+	u32 data[2];
+};
+
+static void smp_wrmsr(void *cmd_block)
+{
+	struct msr_command *cmd = cmd_block;
+	wrmsr(cmd->reg, cmd->data[0], cmd->data[1]);
+}
+
+static void smp_rdmsr(void *cmd_block)
+{
+	struct msr_command *cmd = cmd_block;
+	rdmsr(cmd->reg, cmd->data[0], cmd->data[1]);
+}
+
+static void do_wrmsr(int cpu, u32 reg, u32 eax, u32 edx)
+{
+	struct msr_command cmd;
+
+	cmd.cpu = raw_smp_processor_id();
+	cmd.reg = reg;
+	cmd.data[0] = eax;
+	cmd.data[1] = edx;
+	on_each_cpu(smp_wrmsr, &cmd, 1);
+}
+
+static void do_rdmsr(int cpu, u32 reg, u32 *eax, u32 *edx)
+{
+	struct msr_command cmd;
+
+	cmd.cpu = raw_smp_processor_id();
+	cmd.reg = reg;
+	on_each_cpu(smp_rdmsr, &cmd, 1);
+	*eax = cmd.data[0];
+	*edx = cmd.data[1];
+}
+
 
-- 
1.6.2.4


