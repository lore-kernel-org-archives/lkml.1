Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0CERmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:42:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41473 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754648Ab0CERmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:42:06 -0500
Date: Fri, 5 Mar 2010 11:42:03 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH] x86: Intel microcode loader performance improvement
Message-ID: <20100305174203.GA19638@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've noticed that on large SGI UV system configurations, running
microcode.ctl can take very long periods of time.  This is due to
the large number of vmalloc/vfree calls made by the Intel
generic_load_microcode() logic.

By reusing allocated space, the following patch reduces the time
to run microcode.ctl on a 1024 cpu system from approximately 80
seconds down to 1 or 2 seconds.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/microcode_intel.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/microcode_intel.c
===================================================================
--- linux.orig/arch/x86/kernel/microcode_intel.c
+++ linux/arch/x86/kernel/microcode_intel.c
@@ -343,10 +343,11 @@ static enum ucode_state generic_load_mic
 				int (*get_ucode_data)(void *, const void *, size_t))
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	u8 *ucode_ptr = data, *new_mc = NULL, *mc = NULL;
 	int new_rev = uci->cpu_sig.rev;
 	unsigned int leftover = size;
 	enum ucode_state state = UCODE_OK;
+	unsigned int curr_mc_size = 0;
 
 	while (leftover) {
 		struct microcode_header_intel mc_header;
@@ -361,9 +362,15 @@ static enum ucode_state generic_load_mic
 			break;
 		}
 
-		mc = vmalloc(mc_size);
-		if (!mc)
-			break;
+		/* For performance reasons, reuse mc area when possible */
+		if (!mc || mc_size > curr_mc_size) {
+			if (mc)
+				vfree(mc);
+			mc = vmalloc(mc_size);
+			if (!mc)
+				break;
+			curr_mc_size = mc_size;
+		}
 
 		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
 		    microcode_sanity_check(mc) < 0) {
@@ -376,13 +383,16 @@ static enum ucode_state generic_load_mic
 				vfree(new_mc);
 			new_rev = mc_header.rev;
 			new_mc  = mc;
-		} else
-			vfree(mc);
+			mc = NULL;	/* trigger new vmalloc */
+		}
 
 		ucode_ptr += mc_size;
 		leftover  -= mc_size;
 	}
 
+	if (mc)
+		vfree(mc);
+
 	if (leftover) {
 		if (new_mc)
 			vfree(new_mc);
