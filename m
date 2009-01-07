Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbZAGW1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbZAGW1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762268AbZAGWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:21 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38915 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762211AbZAGWXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:19 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4GU9-02-XTD-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/18] oprofile: add inline function __oprofile_add_ext_sample()
Date: Wed, 7 Jan 2009 23:17:23 +0100
Message-ID: <1231366655-17837-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0350 (UTC) FILETIME=[7F2ACB60:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the inline function __oprofile_add_ext_sample() to
cpu_buffer.c and thus reduces overhead when calling
oprofile_add_sample().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index b353b19..9e66c38 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -277,8 +277,9 @@ static void oprofile_end_trace(struct oprofile_cpu_buffer *cpu_buf)
 	cpu_buf->tracing = 0;
 }
 
-void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
-				unsigned long event, int is_kernel)
+static inline void
+__oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
+			  unsigned long event, int is_kernel)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
@@ -299,12 +300,18 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	oprofile_end_trace(cpu_buf);
 }
 
+void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
+			     unsigned long event, int is_kernel)
+{
+	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
+}
+
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 {
 	int is_kernel = !user_mode(regs);
 	unsigned long pc = profile_pc(regs);
 
-	oprofile_add_ext_sample(pc, regs, event, is_kernel);
+	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
 #ifdef CONFIG_OPROFILE_IBS
-- 
1.6.0.1


