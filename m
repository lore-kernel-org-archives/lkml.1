Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0CKOjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:39:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:35341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0CKOji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:39:38 -0500
Date: Thu, 11 Mar 2010 14:39:07 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sivanich@sgi.com, davidsen@tmr.com, dmitry.adamushko@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sivanich@sgi.com, davidsen@tmr.com, dmitry.adamushko@gmail.com,
       tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <20100305174203.GA19638@sgi.com>
References: <20100305174203.GA19638@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86: Improve Intel microcode loader performance
Message-ID: <tip-938179b4f8cf8a4f11234ebf2dff2eb48400acfe@git.kernel.org>
Git-Commit-ID: 938179b4f8cf8a4f11234ebf2dff2eb48400acfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:39:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  938179b4f8cf8a4f11234ebf2dff2eb48400acfe
Gitweb:     http://git.kernel.org/tip/938179b4f8cf8a4f11234ebf2dff2eb48400acfe
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Fri, 5 Mar 2010 11:42:03 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 13:49:06 +0100

x86: Improve Intel microcode loader performance

We've noticed that on large SGI UV system configurations,
running microcode.ctl can take very long periods of time.  This
is due to the large number of vmalloc/vfree calls made by the
Intel generic_load_microcode() logic.

By reusing allocated space, the following patch reduces the time
to run microcode.ctl on a 1024 cpu system from approximately 80
seconds down to 1 or 2 seconds.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>
LKML-Reference: <20100305174203.GA19638@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_intel.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 85a343e..3561702 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -343,10 +343,11 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
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
@@ -361,9 +362,15 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
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
@@ -376,13 +383,16 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
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
