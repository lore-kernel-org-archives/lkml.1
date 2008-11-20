Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYKTJzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYKTJzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYKTJy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:54:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:52089 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753214AbYKTJy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:54:56 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+q39crJaeqC2Y07tdgfjXcc8T8Z5EyO52Wo2DKeE
	ibzL9LIomVEaRc
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Kyle Mc Martin <kyle@hera.kernel.org>,
       linux-parisc@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] parisc: fix bug in compat_arch_ptrace
Date: Thu, 20 Nov 2008 10:54:09 +0100
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201054.09930.deller@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit in 2.6.28-rc:
	81e192d6ce303b6792aa38ff35f41a1a7357f23a
	parisc: convert to generic compat_sys_ptrace

introduced a bug which segfaults the parisc 64bit kernel 
when stracing 32bit applications:

Kernel Fault: Code=15 regs=00000000bafa42b0 (Addr=00000001baf5ab57)
     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001101111111100001011 Tainted: G        W
r00-03  000000ff0806ff0b 000000004068edc0 00000000401203f8 00000000fb3e2508
r04-07  0000000040686dc0 00000000baf5a800 fffffffffffffffc fffffffffb3e2508
r08-11  00000000baf5a800 000000000004b068 00000000000402b0 0000000000040d68
r12-15  0000000000042a9c 0000000000040a9c 0000000000040d60 0000000000042e9c
r16-19  000000000004b060 000000000004b058 0000000000042d9c ffffffffffffffff
r20-23  000000000800000b 0000000000000000 000000000800000b fffffffffb3e2508
r24-27  00000000fffffffc 0000000000000003 00000000fffffffc 0000000040686dc0
r28-31  00000001baf5a7ff 00000000bafa4280 00000000bafa42b0 00000000000001d7
sr00-03  0000000000fca000 0000000000000000 0000000000000000 0000000000fca000
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040120400 0000000040120404
 IIR: 4b9a06b0    ISR: 0000000000000000  IOR: 00000001baf5ab57
 CPU:        0   CR30: 00000000bafa4000 CR31: 00000000d22344e0
 ORIG_R28: 00000000fb3e2248
 IAOQ[0]: compat_arch_ptrace+0xb8/0x160
 IAOQ[1]: compat_arch_ptrace+0xbc/0x160
 RP(r2): compat_arch_ptrace+0xb0/0x160
Backtrace:
 [<00000000401612ac>] compat_sys_ptrace+0x15c/0x180
 [<0000000040104ef8>] syscall_exit+0x0/0x14

Problem is, that compat_arch_ptrace() enters with an addr value of type 
compat_ulong_t and calls translate_usr_offset() to translate the 
address offset into a struct pt_regs offset like this:
	addr = translate_usr_offset(addr)
This means, any return value of translate_usr_offset() is
stored back as compat_ulong_t type into the addr variable.

But since translate_usr_offset() returns -1 for invalid offsets,
addr can now get the value 0xffffffff which then fails the next
return-value sanity check and thus the kernel tries to access 
invalid memory:
	if (addr < 0)
		break;

Fix this bug by modifying translate_usr_offset() to take and return
values of type compat_ulong_t, and by returning the value 
"sizeof(struct pt_regs)" as an error indicator.
Additionally change the sanity check to check for return values
for >= sizeof(struct pt_regs).

This patch survived my compile and run-tests.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 90904f9..927db36 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -183,10 +183,10 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
  * being 64 bit in both cases.
  */
 
-static long translate_usr_offset(long offset)
+static compat_ulong_t translate_usr_offset(compat_ulong_t offset)
 {
 	if (offset < 0)
-		return -1;
+		return sizeof(struct pt_regs);
 	else if (offset <= 32*4)	/* gr[0..31] */
 		return offset * 2 + 4;
 	else if (offset <= 32*4+32*8)	/* gr[0..31] + fr[0..31] */
@@ -194,7 +194,7 @@ static long translate_usr_offset(long offset)
 	else if (offset < sizeof(struct pt_regs)/2 + 32*4)
 		return offset * 2 + 4 - 32*8;
 	else
-		return -1;
+		return sizeof(struct pt_regs);
 }
 
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
@@ -209,7 +209,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		if (addr & (sizeof(compat_uint_t)-1))
 			break;
 		addr = translate_usr_offset(addr);
-		if (addr < 0)
+		if (addr >= sizeof(struct pt_regs))
 			break;
 
 		tmp = *(compat_uint_t *) ((char *) task_regs(child) + addr);
@@ -236,7 +236,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			if (addr & (sizeof(compat_uint_t)-1))
 				break;
 			addr = translate_usr_offset(addr);
-			if (addr < 0)
+			if (addr >= sizeof(struct pt_regs))
 				break;
 			if (addr >= PT_FR0 && addr <= PT_FR31 + 4) {
 				/* Special case, fp regs are 64 bits anyway */
