Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYAAPqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYAAPqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYAAPgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:33798 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYAAPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:29 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 36/54] KVM: x86 emulator: fix eflags preparation for emulation
Date: Tue,  1 Jan 2008 17:36:02 +0200
Message-Id: <1199201780-14001-37-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We prepare eflags for the emulated instruction, then clobber it with an 'andl'.
Fix by popping eflags as the last thing in the sequence.

Patch taken from Xen (16143:959b4b92b6bf)

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 2e259a8..f423b0e 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -256,21 +256,21 @@ static u16 twobyte_table[256] = {
 #define EFLAGS_MASK (EFLG_OF|EFLG_SF|EFLG_ZF|EFLG_AF|EFLG_PF|EFLG_CF)
 
 /* Before executing instruction: restore necessary bits in EFLAGS. */
-#define _PRE_EFLAGS(_sav, _msk, _tmp) \
-	/* EFLAGS = (_sav & _msk) | (EFLAGS & ~_msk); */	\
-	"push %"_sav"; "					\
-	"movl %"_msk",%"_LO32 _tmp"; "				\
-	"andl %"_LO32 _tmp",("_STK"); "				\
-	"pushf; "						\
-	"notl %"_LO32 _tmp"; "					\
-	"andl %"_LO32 _tmp",("_STK"); "				\
-	"pop  %"_tmp"; "					\
-	"orl  %"_LO32 _tmp",("_STK"); "				\
-	"popf; "						\
-	/* _sav &= ~msk; */					\
-	"movl %"_msk",%"_LO32 _tmp"; "				\
-	"notl %"_LO32 _tmp"; "					\
-	"andl %"_LO32 _tmp",%"_sav"; "
+#define _PRE_EFLAGS(_sav, _msk, _tmp)					\
+	/* EFLAGS = (_sav & _msk) | (EFLAGS & ~_msk); _sav &= ~_msk; */ \
+	"movl %"_sav",%"_LO32 _tmp"; "                                  \
+	"push %"_tmp"; "                                                \
+	"push %"_tmp"; "                                                \
+	"movl %"_msk",%"_LO32 _tmp"; "                                  \
+	"andl %"_LO32 _tmp",("_STK"); "                                 \
+	"pushf; "                                                       \
+	"notl %"_LO32 _tmp"; "                                          \
+	"andl %"_LO32 _tmp",("_STK"); "                                 \
+	"andl %"_LO32 _tmp","__stringify(BITS_PER_LONG/4)"("_STK"); "	\
+	"pop  %"_tmp"; "                                                \
+	"orl  %"_LO32 _tmp",("_STK"); "                                 \
+	"popf; "                                                        \
+	"pop  %"_sav"; "
 
 /* After executing instruction: write-back necessary bits in EFLAGS. */
 #define _POST_EFLAGS(_sav, _msk, _tmp) \
-- 
1.5.3.7

