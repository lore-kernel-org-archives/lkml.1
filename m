Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYLPSOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYLPSOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYLPSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:14:20 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:8754 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYLPSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:14:19 -0500
X-BigFish: VPS3(z34a4jzzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KBZENF-01-CPM-01
Date: Tue, 16 Dec 2008 19:14:05 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 5/10] x86: microcode_amd: don't pass superfluous function
	pointer for get_ucode_data
Message-ID: <20081216181405.GL7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:14:08.0962 (UTC) FILETIME=[16DFE220:01C95FAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 89b386c..c7f225c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -225,9 +225,14 @@ static void apply_microcode_amd(int cpu)
 	uci->cpu_sig.rev = rev;
 }
 
+static int get_ucode_data(void *to, const u8 *from, size_t n)
+{
+	memcpy(to, from, n);
+	return 0;
+}
+
 static void *get_next_ucode(const u8 *buf, unsigned int size,
-			int (*get_ucode_data)(void *, const u8 *, size_t),
-			unsigned int *mc_size)
+			    unsigned int *mc_size)
 {
 	unsigned int total_size;
 #define UCODE_CONTAINER_SECTION_HDR	8
@@ -268,8 +273,7 @@ static void *get_next_ucode(const u8 *buf, unsigned int size,
 }
 
 
-static int install_equiv_cpu_table(const u8 *buf,
-		int (*get_ucode_data)(void *, const u8 *, size_t))
+static int install_equiv_cpu_table(const u8 *buf)
 {
 #define UCODE_CONTAINER_HEADER_SIZE	12
 	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
@@ -311,8 +315,7 @@ static void free_equiv_cpu_table(void)
 	}
 }
 
-static int generic_load_microcode(int cpu, const u8 *data, size_t size,
-		int (*get_ucode_data)(void *, const u8 *, size_t))
+static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	const u8 *ucode_ptr = data;
@@ -322,7 +325,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size,
 	unsigned int leftover;
 	unsigned long offset;
 
-	offset = install_equiv_cpu_table(ucode_ptr, get_ucode_data);
+	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
 		printk(KERN_ERR "microcode: installing equivalent cpu table failed\n");
 		return -EINVAL;
@@ -335,8 +338,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size,
 		unsigned int uninitialized_var(mc_size);
 		struct microcode_header_amd *mc_header;
 
-		mc = get_next_ucode(ucode_ptr, leftover, get_ucode_data,
-				    &mc_size);
+		mc = get_next_ucode(ucode_ptr, leftover, &mc_size);
 		if (!mc)
 			break;
 
@@ -370,12 +372,6 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size,
 	return (int)leftover;
 }
 
-static int get_ucode_fw(void *to, const u8 *from, size_t n)
-{
-	memcpy(to, from, n);
-	return 0;
-}
-
 static int request_microcode_fw(int cpu, struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
@@ -392,8 +388,7 @@ static int request_microcode_fw(int cpu, struct device *device)
 		return ret;
 	}
 
-	ret = generic_load_microcode(cpu, firmware->data, firmware->size,
-			&get_ucode_fw);
+	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
 	release_firmware(firmware);
 
-- 
1.6.0.4



