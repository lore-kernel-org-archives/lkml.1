Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbYJGBGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbYJGBGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYJGAqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:54 -0400
Received: from mail.suse.de ([195.135.220.2]:47366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106AbYJGAqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:52 -0400
Date: Mon, 6 Oct 2008 17:40:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jarod Wilson <jarod@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Moritz Muehlenhoff <jmm@debian.org>
Subject: [patch 71/71] S390: CVE-2008-1514: prevent ptrace padding area
	read/write in 31-bit mode
Message-ID: <20081007004032.GT3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s390-cve-2008-1514-prevent-ptrace-padding-area-read-write-in-31-bit-mode.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jarod Wilson <jwilson@redhat.com>

commit 3d6e48f43340343d97839eadb1ab7b6a3ea98797 upstream

When running a 31-bit ptrace, on either an s390 or s390x kernel,
reads and writes into a padding area in struct user_regs_struct32
will result in a kernel panic.

This is also known as CVE-2008-1514.

Test case available here:
http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/user-area-padding.c?cvsroot=systemtap

Steps to reproduce:
1) wget the above
2) gcc -o user-area-padding-31bit user-area-padding.c -Wall -ggdb2 -D_GNU_SOURCE -m31
3) ./user-area-padding-31bit
<panic>

Test status
-----------
Without patch, both s390 and s390x kernels panic. With patch, the test case,
as well as the gdb testsuite, pass without incident, padding area reads
returning zero, writes ignored.

Nb: original version returned -EINVAL on write attempts, which broke the
gdb test and made the test case slightly unhappy, Jan Kratochvil suggested
the change to return 0 on write attempts.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/compat_ptrace.h |    1 +
 arch/s390/kernel/ptrace.c        |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- a/arch/s390/kernel/compat_ptrace.h
+++ b/arch/s390/kernel/compat_ptrace.h
@@ -42,6 +42,7 @@ struct user_regs_struct32
 	u32 gprs[NUM_GPRS];
 	u32 acrs[NUM_ACRS];
 	u32 orig_gpr2;
+	/* nb: there's a 4-byte hole here */
 	s390_fp_regs fp_regs;
 	/*
 	 * These per registers are in here so that gdb can modify them
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -177,6 +177,13 @@ peek_user(struct task_struct *child, add
 		 */
 		tmp = (addr_t) task_pt_regs(child)->orig_gpr2;
 
+	} else if (addr < (addr_t) &dummy->regs.fp_regs) {
+		/*
+		 * prevent reads of padding hole between
+		 * orig_gpr2 and fp_regs on s390.
+		 */
+		tmp = 0;
+
 	} else if (addr < (addr_t) (&dummy->regs.fp_regs + 1)) {
 		/* 
 		 * floating point regs. are stored in the thread structure
@@ -268,6 +275,13 @@ poke_user(struct task_struct *child, add
 		 */
 		task_pt_regs(child)->orig_gpr2 = data;
 
+	} else if (addr < (addr_t) &dummy->regs.fp_regs) {
+		/*
+		 * prevent writes of padding hole between
+		 * orig_gpr2 and fp_regs on s390.
+		 */
+		return 0;
+
 	} else if (addr < (addr_t) (&dummy->regs.fp_regs + 1)) {
 		/*
 		 * floating point regs. are stored in the thread structure
@@ -409,6 +423,13 @@ peek_user_emu31(struct task_struct *chil
 		 */
 		tmp = *(__u32*)((addr_t) &task_pt_regs(child)->orig_gpr2 + 4);
 
+	} else if (addr < (addr_t) &dummy32->regs.fp_regs) {
+		/*
+		 * prevent reads of padding hole between
+		 * orig_gpr2 and fp_regs on s390.
+		 */
+		tmp = 0;
+
 	} else if (addr < (addr_t) (&dummy32->regs.fp_regs + 1)) {
 		/*
 		 * floating point regs. are stored in the thread structure 
@@ -488,6 +509,13 @@ poke_user_emu31(struct task_struct *chil
 		 */
 		*(__u32*)((addr_t) &task_pt_regs(child)->orig_gpr2 + 4) = tmp;
 
+	} else if (addr < (addr_t) &dummy32->regs.fp_regs) {
+		/*
+		 * prevent writess of padding hole between
+		 * orig_gpr2 and fp_regs on s390.
+		 */
+		return 0;
+
 	} else if (addr < (addr_t) (&dummy32->regs.fp_regs + 1)) {
 		/*
 		 * floating point regs. are stored in the thread structure 

-- 
