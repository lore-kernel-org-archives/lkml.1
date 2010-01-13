Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063Ab0AMKZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0AMKZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497Ab0AMKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:25:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:37966 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab0AMKZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:25:14 -0500
Date: Wed, 13 Jan 2010 10:24:29 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <20100104144735.GA18390@redhat.com>
References: <20100104144735.GA18390@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Macroise x86 cache descriptors
Message-ID: <tip-2ca49b2fcf5813571663c3c4c894b78148c43690@git.kernel.org>
Git-Commit-ID: 2ca49b2fcf5813571663c3c4c894b78148c43690
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:24:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ca49b2fcf5813571663c3c4c894b78148c43690
Gitweb:     http://git.kernel.org/tip/2ca49b2fcf5813571663c3c4c894b78148c43690
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Mon, 4 Jan 2010 09:47:35 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 08:57:38 +0100

x86: Macroise x86 cache descriptors

Use a macro to define the cache sizes when cachesize > 1 MB.

This is less typing, and less prone to introducing bugs like we
saw in e02e0e1a130b9ca37c5186d38ad4b3aaf58bb149, and means we
don't have to do maths when adding new non-power-of-2 updates
like those seen recently.

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <20100104144735.GA18390@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   84 +++++++++++++++++----------------
 1 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc6c8ef..c2b722d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -31,6 +31,8 @@ struct _cache_table {
 	short size;
 };
 
+#define MB(x)	((x) * 1024)
+
 /* All the cache descriptor types we care about (no TLB or
    trace cache entries) */
 
@@ -44,9 +46,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
-	{ 0x23, LVL_3,      1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x25, LVL_3,      2048 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x29, LVL_3,      4096 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x23, LVL_3,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x25, LVL_3,      MB(2) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x29, LVL_3,      MB(4) },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x2c, LVL_1_DATA, 32 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x30, LVL_1_INST, 32 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x39, LVL_2,      128 },	/* 4-way set assoc, sectored cache, 64 byte line size */
@@ -59,16 +61,16 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x41, LVL_2,      128 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x42, LVL_2,      256 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x43, LVL_2,      512 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x44, LVL_2,      1024 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x45, LVL_2,      2048 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x46, LVL_3,      4096 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x47, LVL_3,      8192 },	/* 8-way set assoc, 64 byte line size */
-	{ 0x49, LVL_3,      4096 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4a, LVL_3,      6144 },	/* 12-way set assoc, 64 byte line size */
-	{ 0x4b, LVL_3,      8192 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4c, LVL_3,     12288 },	/* 12-way set assoc, 64 byte line size */
-	{ 0x4d, LVL_3,     16384 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4e, LVL_2,      6144 },	/* 24-way set assoc, 64 byte line size */
+	{ 0x44, LVL_2,      MB(1) },	/* 4-way set assoc, 32 byte line size */
+	{ 0x45, LVL_2,      MB(2) },	/* 4-way set assoc, 32 byte line size */
+	{ 0x46, LVL_3,      MB(4) },	/* 4-way set assoc, 64 byte line size */
+	{ 0x47, LVL_3,      MB(8) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x49, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4a, LVL_3,      MB(6) },	/* 12-way set assoc, 64 byte line size */
+	{ 0x4b, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4c, LVL_3,      MB(12) },	/* 12-way set assoc, 64 byte line size */
+	{ 0x4d, LVL_3,      MB(16) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4e, LVL_2,      MB(6) },	/* 24-way set assoc, 64 byte line size */
 	{ 0x60, LVL_1_DATA, 16 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x66, LVL_1_DATA, 8 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x67, LVL_1_DATA, 16 },	/* 4-way set assoc, sectored cache, 64 byte line size */
@@ -77,34 +79,34 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x71, LVL_TRACE,  16 },	/* 8-way set assoc */
 	{ 0x72, LVL_TRACE,  32 },	/* 8-way set assoc */
 	{ 0x73, LVL_TRACE,  64 },	/* 8-way set assoc */
-	{ 0x78, LVL_2,    1024 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x79, LVL_2,     128 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7a, LVL_2,     256 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7b, LVL_2,     512 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7c, LVL_2,    1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7d, LVL_2,    2048 },	/* 8-way set assoc, 64 byte line size */
-	{ 0x7f, LVL_2,     512 },	/* 2-way set assoc, 64 byte line size */
-	{ 0x82, LVL_2,     256 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x83, LVL_2,     512 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x84, LVL_2,    1024 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x85, LVL_2,    2048 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x86, LVL_2,     512 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x87, LVL_2,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd0, LVL_3,     512 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xde, LVL_3,    8192 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
-	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
-	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
+	{ 0x78, LVL_2,      MB(1) },	/* 4-way set assoc, 64 byte line size */
+	{ 0x79, LVL_2,      128 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7a, LVL_2,      256 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7b, LVL_2,      512 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7c, LVL_2,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7d, LVL_2,      MB(2) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x7f, LVL_2,      512 },	/* 2-way set assoc, 64 byte line size */
+	{ 0x82, LVL_2,      256 },	/* 8-way set assoc, 32 byte line size */
+	{ 0x83, LVL_2,      512 },	/* 8-way set assoc, 32 byte line size */
+	{ 0x84, LVL_2,      MB(1) },	/* 8-way set assoc, 32 byte line size */
+	{ 0x85, LVL_2,      MB(2) },	/* 8-way set assoc, 32 byte line size */
+	{ 0x86, LVL_2,      512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x87, LVL_2,      MB(1) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd0, LVL_3,      512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd1, LVL_3,      MB(1) },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd2, LVL_3,      MB(2) },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd6, LVL_3,      MB(1) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,      MB(2) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd8, LVL_3,      MB(4) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdc, LVL_3,      MB(2) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdd, LVL_3,      MB(4) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xde, LVL_3,      MB(8) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xe2, LVL_3,      MB(2) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe3, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe4, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,      MB(12) },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,      MB(18) },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,      MB(24) },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 
