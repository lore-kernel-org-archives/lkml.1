Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZKDJFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZKDJFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZKDJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:05:21 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33321 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZKDJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:05:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OHSqVRYFdLyc6X87mlEIpcx+jur6oHZxOaGJ5gZ1lFI8qnFiDt8vDd3D+5arhy7VNr
         RqpFOb4x7Y/2kI2KOHVPHW8AM4tINocSC7zWGAlEQXG2oA410+nnrVlGvrDnppL/9DZ4
         gYS9e3AqYxDPCGlneGr7s/5T6ca9/A2qDzafg=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: [PATCH -queue v0 2/6] [loongson] oprofile: avoid do_IRQ for perfcounter when the interrupt is from bonito
Date: Wed,  4 Nov 2009 17:05:08 +0800
Message-Id: <061879e220036f930cd1cf5a6d22fca4d2be255c.1257325319.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1257325319.git.wuzhangjin@gmail.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In loongson2f, the IP6 is shared by bonito and perfcounter, we need to
avoid do_IRQ for perfcounter when the interrupt is from bonito. This
patch does it.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/oprofile/op_model_loongson2.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mips/oprofile/op_model_loongson2.c b/arch/mips/oprofile/op_model_loongson2.c
index 575cd14..08d4b09 100644
--- a/arch/mips/oprofile/op_model_loongson2.c
+++ b/arch/mips/oprofile/op_model_loongson2.c
@@ -125,6 +125,9 @@ static irqreturn_t loongson2_perfcount_handler(int irq, void *dev_id)
 	 */
 
 	/* Check whether the irq belongs to me */
+	enabled = read_c0_perfcnt() & LOONGSON2_PERFCNT_INT_EN;
+	if (!enabled)
+		return IRQ_NONE;
 	enabled = reg.cnt1_enabled | reg.cnt2_enabled;
 	if (!enabled)
 		return IRQ_NONE;
-- 
1.6.2.1

