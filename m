Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYKTTMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYKTTMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbYKTTLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:11:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYKTTLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:11:51 -0500
Message-Id: <20081120191149.285359258@goodmis.org>
References: <20081120190948.057007623@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 14:09:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] powerpc: ftrace, convert to new dynamic ftrace arch API
Content-Disposition: inline; filename=0002-powerpc-ftrace-convert-to-new-dynamic-ftrace-arch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: update to PowerPC ftrace arch API

This patch converts PowerPC to use the new dynamic ftrace arch API.

Thanks to Paul Mackennas for pointing out the mistakes of my original
test_24bit_addr function.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/include/asm/ftrace.h |   14 +++++++-
 arch/powerpc/kernel/ftrace.c      |   67 ++++++++++++++++++++++++++++++++++---
 2 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index b298f7a..17efecc 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -7,7 +7,19 @@
 
 #ifndef __ASSEMBLY__
 extern void _mcount(void);
-#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+       /* reloction of mcount call site is the same as the address */
+       return addr;
+}
+
+struct dyn_arch_ftrace {
+	/* nothing yet */
+};
+#endif /*  CONFIG_DYNAMIC_FTRACE */
+#endif /* __ASSEMBLY__ */
 
 #endif
 
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index f4b006e..24c023a 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -33,12 +33,12 @@ static unsigned int ftrace_calc_offset(long ip, long addr)
 	return (int)(addr - ip);
 }
 
-unsigned char *ftrace_nop_replace(void)
+static unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
 }
 
-unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static unsigned int op;
 
@@ -68,7 +68,7 @@ unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 # define _ASM_PTR	" .long "
 #endif
 
-int
+static int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -113,6 +113,62 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	return faulted;
 }
 
+static int test_24bit_addr(unsigned long ip, unsigned long addr)
+{
+	long diff;
+
+	/*
+	 * Can we get to addr from ip in 24 bits?
+	 *  (26 really, since we mulitply by 4 for 4 byte alignment)
+	 */
+	diff = addr - ip;
+
+	/*
+	 * Return true if diff is less than 1 << 25
+	 *  and greater than -1 << 26.
+	 */
+	return (diff < (1 << 25)) && (diff > (-1 << 26));
+}
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *old, *new;
+
+	/*
+	 * If the calling address is more that 24 bits away,
+	 * then we had to use a trampoline to make the call.
+	 * Otherwise just update the call site.
+	 */
+	if (test_24bit_addr(rec->ip, addr)) {
+		/* within range */
+		old = ftrace_call_replace(rec->ip, addr);
+		new = ftrace_nop_replace();
+		return ftrace_modify_code(rec->ip, old, new);
+	}
+
+	return 0;
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *old, *new;
+
+	/*
+	 * If the calling address is more that 24 bits away,
+	 * then we had to use a trampoline to make the call.
+	 * Otherwise just update the call site.
+	 */
+	if (test_24bit_addr(rec->ip, addr)) {
+		/* within range */
+		old = ftrace_nop_replace();
+		new = ftrace_call_replace(rec->ip, addr);
+		return ftrace_modify_code(rec->ip, old, new);
+	}
+
+	return 0;
+}
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
@@ -128,9 +184,10 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* This is running in kstop_machine */
+	/* caller expects data to be zero */
+	unsigned long *p = data;
 
-	ftrace_mcount_set(data);
+	*p = 0;
 
 	return 0;
 }
-- 
1.5.6.5

-- 
