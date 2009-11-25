Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbZKYW3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbZKYW3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbZKYW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:29:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64264 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589AbZKYW3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LnC6nfVPXpUMqVC9L83pZG/Pcrtup8HZLZVOikTllHsMt+7qOJl99YiKzfbpw+zysv
         Ladw1euH8EDwOrbro8nFNihPbjH9hnhxRnBL2u4T6R9Ktbfl3xTLRuCKfUzLEztadsk/
         EnWUDbT5aufTbroVPbGUdl20DBWazurr0rbY8=
Subject: [PATCH - 1/2] tip, x86-microcode: simplify 'struct ucode_cpu_info'
 and related functional logic
From: dimm <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 23:29:40 +0100
Message-Id: <1259188180.7940.21.camel@dimm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: x86-microcode: drop "cpu_sig" caching


Simplify 'struct ucode_cpu_info' and related functional logic. Always retrieve the current "cpu_sig" when required.
This way we don't need to maintain corner cases which may lead to having non up-to-date versions of "cpu_sig".


 arch/x86/include/asm/microcode.h  |    2 -
 arch/x86/kernel/microcode_amd.c   |   15 +++++----
 arch/x86/kernel/microcode_core.c  |   61 +++++++++++-------------------------
 arch/x86/kernel/microcode_intel.c |   15 +++++----
 4 files changed, 37 insertions(+), 56 deletions(-)


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andreas Mohr <andi@lisas.de>

---

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c24ca9a..0be7c00 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -33,8 +33,6 @@ struct microcode_ops {
 };
 
 struct ucode_cpu_info {
-	struct cpu_signature	cpu_sig;
-	int			valid;
 	void			*mc;
 };
 extern struct ucode_cpu_info ucode_cpu_info[];
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 63123d9..7d006e4 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -147,7 +147,6 @@ static int apply_microcode_amd(int cpu)
 	}
 
 	pr_info("microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
-	uci->cpu_sig.rev = rev;
 
 	return 0;
 }
@@ -236,14 +235,18 @@ static enum ucode_state
 generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct cpu_signature cpu_sig;
 	const u8 *ucode_ptr = data;
-	void *new_mc = NULL;
-	void *mc;
-	int new_rev = uci->cpu_sig.rev;
-	unsigned int leftover;
+	void *new_mc = NULL, *mc;
+	unsigned int leftover, new_rev;
 	unsigned long offset;
 	enum ucode_state state = UCODE_OK;
 
+	if (collect_cpu_info_amd(cpu, &cpu_sig))
+		return UCODE_ERROR;
+
+	new_rev = cpu_sig.rev;
+
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
 		pr_err("microcode: failed to create equivalent cpu table\n");
@@ -279,7 +282,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 			uci->mc = new_mc;
 			pr_debug("microcode: CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",
-				 cpu, new_rev, uci->cpu_sig.rev);
+				 cpu, new_rev, cpu_sig.rev);
 		} else {
 			vfree(new_mc);
 			state = UCODE_ERROR;
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index e68aae3..30558fe 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -137,20 +137,6 @@ static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
 	return ret;
 }
 
-static int collect_cpu_info(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int ret;
-
-	memset(uci, 0, sizeof(*uci));
-
-	ret = collect_cpu_info_on_target(cpu, &uci->cpu_sig);
-	if (!ret)
-		uci->valid = 1;
-
-	return ret;
-}
-
 struct apply_microcode_ctx {
 	int err;
 };
@@ -181,12 +167,8 @@ static int do_microcode_update(const void __user *buf, size_t size)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 		enum ucode_state ustate;
 
-		if (!uci->valid)
-			continue;
-
 		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
 		if (ustate == UCODE_ERROR) {
 			error = -1;
@@ -267,23 +249,15 @@ static struct platform_device	*microcode_pdev;
 
 static int reload_for_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int err = 0;
+	enum ucode_state ustate;
 
 	mutex_lock(&microcode_mutex);
-	if (uci->valid) {
-		enum ucode_state ustate;
-
-		ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
-		if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
-		else
-			if (ustate == UCODE_ERROR)
-				err = -EINVAL;
-	}
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	if (ustate == UCODE_OK)
+		apply_microcode_on_target(cpu);
 	mutex_unlock(&microcode_mutex);
 
-	return err;
+	return (ustate == UCODE_ERROR)? -EINVAL : 0;
 }
 
 static ssize_t reload_store(struct sys_device *dev,
@@ -315,17 +289,23 @@ static ssize_t reload_store(struct sys_device *dev,
 static ssize_t version_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct cpu_signature cpu_sig;
+
+	if (collect_cpu_info_on_target(dev->id, &cpu_sig))
+		return 0;
 
-	return sprintf(buf, "0x%x\n", uci->cpu_sig.rev);
+	return sprintf(buf, "0x%x\n", cpu_sig.rev);
 }
 
 static ssize_t pf_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct cpu_signature cpu_sig;
+
+	if (collect_cpu_info_on_target(dev->id, &cpu_sig))
+		return 0;
 
-	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
+	return sprintf(buf, "0x%x\n", cpu_sig.pf);
 }
 
 static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
@@ -346,10 +326,7 @@ static struct attribute_group mc_attr_group = {
 
 static void microcode_fini_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
 	microcode_ops->microcode_fini_cpu(cpu);
-	uci->valid = 0;
 }
 
 static enum ucode_state microcode_resume_cpu(int cpu)
@@ -367,10 +344,10 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 
 static enum ucode_state microcode_init_cpu(int cpu)
 {
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (collect_cpu_info(cpu))
-		return UCODE_ERROR;
+	memset(uci, 0, sizeof(*uci));
 
 	/* --dimm. Trigger a delayed update? */
 	if (system_state != SYSTEM_RUNNING)
@@ -391,7 +368,7 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (uci->valid && uci->mc)
+	if (uci->mc)
 		ustate = microcode_resume_cpu(cpu);
 	else
 		ustate = microcode_init_cpu(cpu);
@@ -448,7 +425,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 	 */
 	WARN_ON(cpu != 0);
 
-	if (uci->valid && uci->mc)
+	if (uci->mc)
 		microcode_ops->apply_microcode(cpu);
 
 	return 0;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0d334dd..6589765 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -339,8 +339,6 @@ static int apply_microcode(int cpu)
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
 
-	uci->cpu_sig.rev = val[1];
-
 	return 0;
 }
 
@@ -348,11 +346,16 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 				int (*get_ucode_data)(void *, const void *, size_t))
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct cpu_signature cpu_sig;
 	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
-	int new_rev = uci->cpu_sig.rev;
-	unsigned int leftover = size;
+	unsigned int leftover = size, new_rev;
 	enum ucode_state state = UCODE_OK;
 
+	if (collect_cpu_info(cpu, &cpu_sig))
+		return UCODE_ERROR;
+
+	new_rev = cpu_sig.rev;
+
 	while (leftover) {
 		struct microcode_header_intel mc_header;
 		unsigned int mc_size;
@@ -377,7 +380,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 			break;
 		}
 
-		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
+		if (get_matching_microcode(&cpu_sig, mc, new_rev)) {
 			if (new_mc)
 				vfree(new_mc);
 			new_rev = mc_header.rev;
@@ -407,7 +410,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 
 	pr_debug("microcode: CPU%d found a matching microcode update with"
 		 " version 0x%x (current=0x%x)\n",
-			cpu, new_rev, uci->cpu_sig.rev);
+			cpu, new_rev, cpu_sig.rev);
 out:
 	return state;
 }


