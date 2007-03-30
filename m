Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbXC3VLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbXC3VLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXC3VKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:10:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58232 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXC3VJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:48 -0400
Date: Fri, 30 Mar 2007 14:04:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Davide Brini <brini@geomin.unibo.it>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@linux.intel.com>
Subject: [patch 07/37] UML - use correct register file size everywhere
Message-ID: <20070330210415.GI29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-use-correct-register-file-size-everywhere.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Dike <jdike@addtoit.com>

This patch uses MAX_REG_NR consistently to refer to the register file
size.  FRAME_SIZE isn't sufficient because on x86_64, it is smaller
than the ptrace register file size.  MAX_REG_NR was introduced as a
consistent way to get the number of registers, but wasn't used
everywhere it should be.

When this causes a problem, it makes PTRACE_SETREGS fail on x86_64
because of a corrupted segment register value in the known-good
register file. The patch also adds a register dump at that point in
case there are any future problems here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/include/sysdep-x86_64/ptrace.h  |    4 ----
 arch/um/os-Linux/skas/mem.c             |   10 +++++++---
 arch/um/os-Linux/skas/process.c         |    6 +++---
 arch/um/os-Linux/sys-i386/registers.c   |    5 +++--
 arch/um/os-Linux/sys-x86_64/registers.c |    4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

--- a/arch/um/include/sysdep-x86_64/ptrace.h
+++ b/arch/um/include/sysdep-x86_64/ptrace.h
@@ -104,10 +104,6 @@ union uml_pt_regs {
 #endif
 #ifdef UML_CONFIG_MODE_SKAS
 	struct skas_regs {
-		/* x86_64 ptrace uses sizeof(user_regs_struct) as its register
-		 * file size, while i386 uses FRAME_SIZE.  Therefore, we need
-		 * to use UM_FRAME_SIZE here instead of HOST_FRAME_SIZE.
-		 */
 		unsigned long regs[MAX_REG_NR];
 		unsigned long fp[HOST_FP_SIZE];
                 struct faultinfo faultinfo;
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -48,7 +48,7 @@ int multi_op_count = 0;
 static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 {
 	unsigned long regs[MAX_REG_NR];
-	int n;
+	int n, i;
 	long ret, offset;
 	unsigned long * data;
 	unsigned long * syscall;
@@ -66,9 +66,13 @@ static inline long do_syscall_stub(struc
 		 (unsigned long) &__syscall_stub_start);
 
 	n = ptrace_setregs(pid, regs);
-	if(n < 0)
+	if(n < 0){
+		printk("Registers - \n");
+		for(i = 0; i < MAX_REG_NR; i++)
+			printk("\t%d\t0x%lx\n", i, regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
-		      n);
+		      -n);
+	}
 
 	wait_stub_done(pid, 0, "do_syscall_stub");
 
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -67,7 +67,7 @@ void wait_stub_done(int pid, int sig, ch
 
 	if((n < 0) || !WIFSTOPPED(status) ||
 	   (WSTOPSIG(status) != SIGUSR1 && WSTOPSIG(status) != SIGTRAP)){
-		unsigned long regs[HOST_FRAME_SIZE];
+		unsigned long regs[MAX_REG_NR];
 
 		if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
 			printk("Failed to get registers from stub, "
@@ -76,7 +76,7 @@ void wait_stub_done(int pid, int sig, ch
 			int i;
 
 			printk("Stub registers -\n");
-			for(i = 0; i < HOST_FRAME_SIZE; i++)
+			for(i = 0; i < ARRAY_SIZE(regs); i++)
 				printk("\t%d - %lx\n", i, regs[i]);
 		}
 		panic("%s : failed to wait for SIGUSR1/SIGTRAP, "
@@ -328,7 +328,7 @@ void userspace(union uml_pt_regs *regs)
 int copy_context_skas0(unsigned long new_stack, int pid)
 {
 	int err;
-	unsigned long regs[HOST_FRAME_SIZE];
+	unsigned long regs[MAX_REG_NR];
 	unsigned long fp_regs[HOST_FP_SIZE];
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
--- a/arch/um/os-Linux/sys-i386/registers.c
+++ b/arch/um/os-Linux/sys-i386/registers.c
@@ -15,7 +15,7 @@
 
 /* These are set once at boot time and not changed thereafter */
 
-static unsigned long exec_regs[HOST_FRAME_SIZE];
+static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[HOST_FP_SIZE];
 static unsigned long exec_fpx_regs[HOST_XFP_SIZE];
 static int have_fpx_regs = 1;
@@ -101,6 +101,7 @@ void init_registers(int pid)
 {
 	int err;
 
+	memset(exec_regs, 0, sizeof(exec_regs));
 	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
 	if(err)
 		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
@@ -124,7 +125,7 @@ void init_registers(int pid)
 
 void get_safe_registers(unsigned long *regs, unsigned long *fp_regs)
 {
-	memcpy(regs, exec_regs, HOST_FRAME_SIZE * sizeof(unsigned long));
+	memcpy(regs, exec_regs, sizeof(exec_regs));
 	if(fp_regs != NULL)
 		memcpy(fp_regs, exec_fp_regs,
 		       HOST_FP_SIZE * sizeof(unsigned long));
--- a/arch/um/os-Linux/sys-x86_64/registers.c
+++ b/arch/um/os-Linux/sys-x86_64/registers.c
@@ -14,7 +14,7 @@
 
 /* These are set once at boot time and not changed thereafter */
 
-static unsigned long exec_regs[HOST_FRAME_SIZE];
+static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[HOST_FP_SIZE];
 
 void init_thread_registers(union uml_pt_regs *to)
@@ -72,7 +72,7 @@ void init_registers(int pid)
 
 void get_safe_registers(unsigned long *regs, unsigned long *fp_regs)
 {
-	memcpy(regs, exec_regs, HOST_FRAME_SIZE * sizeof(unsigned long));
+	memcpy(regs, exec_regs, sizeof(exec_regs));
 	if(fp_regs != NULL)
 		memcpy(fp_regs, exec_fp_regs,
 		       HOST_FP_SIZE * sizeof(unsigned long));

-- 
