Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbYIWU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbYIWU4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYIWU4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:56:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:30256 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYIWU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JFWbBbtGLpVwQEpePzliATN5/aWOnlaTrQcfKq0hKls8pYXX71Hjorb1FGw0LiUJv/
         NSX427+o5B5GRVEQ9zS/tkRzcIspG2DCEo+OxHHi2ZsMO8TQKpkXHSybws6dvFUeH0c7
         K+s/q1jdkTIrIVwsVx5oUTZ54b30gbtTPa5hg=
Subject: x86, microcode_amd: cleanup, mark request_microcode_user() as
	unsupported
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Oruba <peter.oruba@amd.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 22:56:35 +0200
Message-Id: <1222203395.23615.1.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86, microcode_amd: cleanup, mark request_microcode_user() as unsupported

(1) mark mc_size in generic_load_microcode() as unitialized_var to avoid
gcc's (false) warning;

(2) mark request_microcode_user() as unsupported. The required changes can be
added later. Note, we don't break any user-space interfaces here, as there were
no kernels with support for AMD-specific ucode update yet. The ucode has
to be updated via 'firmware'.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Peter Oruba <peter.oruba@amd.com>

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8294152..7a1f8ee 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -120,29 +120,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	unsigned int equiv_cpu_id = 0x00;
 	unsigned int i = 0;
 
-	/*
-	 * FIXME! dimm: do we need this? Why an update via /dev/... is different
-	 * from the one via firmware?
-	 *
-	 * This is a tricky part. We might be called from a write operation
-	 * to the device file instead of the usual process of firmware
-	 * loading. This routine needs to be able to distinguish both
-	 * cases. This is done by checking if there alread is a equivalent
-	 * CPU table installed. If not, we're written through
-	 * /dev/cpu/microcode.
-	 * Since we ignore all checks. The error case in which going through
-	 * firmware loading and that table is not loaded has already been
-	 * checked earlier.
-	 */
 	BUG_ON(equiv_cpu_table == NULL);
-#if 0
-	if (equiv_cpu_table == NULL) {
-		printk(KERN_INFO "microcode: CPU%d microcode update with "
-		       "version 0x%x (current=0x%x)\n",
-		       cpu, mc_header->patch_id, uci->cpu_sig.rev);
-		goto out;
-	}
-#endif
 	current_cpu_id = cpuid_eax(0x00000001);
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
@@ -362,7 +340,7 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 	leftover = size - offset;
 
 	while (leftover) {
-		unsigned int mc_size;
+		unsigned int uninitialized_var(mc_size);
 		struct microcode_header_amd *mc_header;
 
 		mc = get_next_ucode(ucode_ptr, leftover, get_ucode_data, &mc_size);
@@ -428,17 +406,11 @@ static int request_microcode_fw(int cpu, struct device *device)
 	return ret;
 }
 
-static int get_ucode_user(void *to, const void *from, size_t n)
-{
-	return copy_from_user(to, from, n);
-}
-
 static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
-	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
+	printk(KERN_WARNING "microcode: AMD microcode update via /dev/cpu/microcode"
+			"is not supported\n");
+	return -1;
 }
 
 static void microcode_fini_cpu_amd(int cpu)


