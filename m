Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYLPSNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYLPSNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYLPSNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:13:14 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:59732 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYLPSNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:13:13 -0500
X-BigFish: VPS3(zzzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBZELL-01-CN2-01
Date: Tue, 16 Dec 2008 19:13:00 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 4/10] x86: microcode_amd: fix compile warning
Message-ID: <20081216181300.GK7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:13:03.0772 (UTC) FILETIME=[F004ADC0:01C95FA9]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  CC      arch/x86/kernel/microcode_amd.o
arch/x86/kernel/microcode_amd.c: In function ‘request_microcode_fw’:
arch/x86/kernel/microcode_amd.c:393: warning: passing argument 2 of ‘generic_load_microcode’ discards qualifiers from pointer target type

(Respect "const" qualifier of firmware->data.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index a8a0ec6..89b386c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -225,8 +225,8 @@ static void apply_microcode_amd(int cpu)
 	uci->cpu_sig.rev = rev;
 }
 
-static void *get_next_ucode(u8 *buf, unsigned int size,
-			int (*get_ucode_data)(void *, const void *, size_t),
+static void *get_next_ucode(const u8 *buf, unsigned int size,
+			int (*get_ucode_data)(void *, const u8 *, size_t),
 			unsigned int *mc_size)
 {
 	unsigned int total_size;
@@ -268,8 +268,8 @@ static void *get_next_ucode(u8 *buf, unsigned int size,
 }
 
 
-static int install_equiv_cpu_table(u8 *buf,
-		int (*get_ucode_data)(void *, const void *, size_t))
+static int install_equiv_cpu_table(const u8 *buf,
+		int (*get_ucode_data)(void *, const u8 *, size_t))
 {
 #define UCODE_CONTAINER_HEADER_SIZE	12
 	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
@@ -311,11 +311,13 @@ static void free_equiv_cpu_table(void)
 	}
 }
 
-static int generic_load_microcode(int cpu, void *data, size_t size,
-		int (*get_ucode_data)(void *, const void *, size_t))
+static int generic_load_microcode(int cpu, const u8 *data, size_t size,
+		int (*get_ucode_data)(void *, const u8 *, size_t))
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	const u8 *ucode_ptr = data;
+	void *new_mc = NULL;
+	void *mc;
 	int new_rev = uci->cpu_sig.rev;
 	unsigned int leftover;
 	unsigned long offset;
@@ -368,7 +370,7 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 	return (int)leftover;
 }
 
-static int get_ucode_fw(void *to, const void *from, size_t n)
+static int get_ucode_fw(void *to, const u8 *from, size_t n)
 {
 	memcpy(to, from, n);
 	return 0;
@@ -390,7 +392,7 @@ static int request_microcode_fw(int cpu, struct device *device)
 		return ret;
 	}
 
-	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
+	ret = generic_load_microcode(cpu, firmware->data, firmware->size,
 			&get_ucode_fw);
 
 	release_firmware(firmware);
-- 
1.6.0.4



