Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXGFBws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXGFBws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbXGFBwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:52:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60990 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbXGFBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:52:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=lXycjKDf0B9ZMiylUo3cgo7clVQyz/elbDFcw8AUcp6rbOkphvDpfF14qd4DBCd+L
	VCX1dRg6I6TbnZAIt5Oww==
Date: Thu, 5 Jul 2007 18:52:27 -0700 (PDT)
From: Joshua Wise <jwise@google.com>
X-X-Sender: jwise@internets.corp.google.com
To: linux-kernel@vger.kernel.org
cc: Tim Hockin <thockin@google.com>, Mike Waychison <mikew@google.com>,
       Masoud Asgharifard Sharbiani <masouds@google.com>,
       Andrew Morton <akpm@google.com>
Subject: [PATCH] Print utsname on Oops on all architectures
Message-ID: <Pine.LNX.4.64.0707051847030.617@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="313268086-999895010-1183686747=:617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--313268086-999895010-1183686747=:617
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hopefully this patch has not been munged by pine; I have, minimally,
unchecked the mung-patches-sent-to-lkml option in pine's config. In the case
that it has been munged, I have also attached it.

--

From: Joshua Wise <jwise@google.com>

Background:
 This patch is a follow-on to "Info dump on Oops or panic()" [1].
 
 On some architectures, the kernel printed some information on the running
 kernel, but not on all architectures. The information printed was generally
 the version and build number, but it was not located in a consistant place,
 and some architectures did not print it at all.

Description:
 This patch uses the already-existing die_chain to print utsname information
 on Oops. This patch also removes the architecture-specific utsname
 printers. To avoid crashing the system further (and hence not printing the
 Oops) in the case where the system is so hopelessly smashed that utsname
 might be destroyed, we vsprintf the utsname data into a static buffer
 first, and then just print that on crash.

Testing:
 I wrote a module that does a *(int*)0 = 0; and observed that I got my
 utsname data printed.

Potential impact:
 This adds another line to the Oops output, causing the first few lines to
 potentially scroll off the screen. This also adds a few more pointer
 dereferences in the Oops path, because it adds to the die_chain notifier
 chain, reducing the likelihood that the Oops will be printed if there is
 very bad memory corruption.

Patch:
 This patch is against git 0471448f4d017470995d8a2272dc8c06dbed3b77.

Signed-Off-By: Joshua Wise <jwise@google.com>

[1] http://lkml.org/lkml/2007/6/28/316

--

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 92b6162..13f342e 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -20,7 +20,6 @@ #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
-#include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/major.h>
 #include <linux/stat.h>
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 8423617..e4448f0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -28,7 +28,6 @@ #include <linux/cpu.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
 #include <linux/tick.h>
-#include <linux/utsname.h>
 
 #include <asm/leds.h>
 #include <asm/processor.h>
@@ -203,10 +202,8 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk("CPU: %d    %s  (%s %.*s)\n",
-		smp_processor_id(), print_tainted(), init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	printk("CPU: %d    %s\n",
+		smp_processor_id(), print_tainted());
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->ARM_lr);
 	printk("pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 06dfa65..1703243 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -27,7 +27,6 @@ #include <linux/vmalloc.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
@@ -308,10 +307,8 @@ void show_regs(struct pt_regs * regs)
 
 	if (user_mode_vm(regs))
 		printk(" ESP: %04x:%08lx",0xffff & regs->xss,regs->esp);
-	printk(" EFLAGS: %08lx    %s  (%s %.*s)\n",
-	       regs->eflags, print_tainted(), init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
+	printk(" EFLAGS: %08lx    %s\n",
+	       regs->eflags, print_tainted());
 	printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
 		regs->eax,regs->ebx,regs->ecx,regs->edx);
 	printk("ESI: %08lx EDI: %08lx EBP: %08lx",
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 6e2f035..04c4abd 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -32,7 +32,6 @@ #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
-#include <linux/utsname.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -414,8 +413,8 @@ void show_regs(struct pt_regs * regs)
 
 	printk("NIP: "REG" LR: "REG" CTR: "REG"\n",
 	       regs->nip, regs->link, regs->ctr);
-	printk("REGS: %p TRAP: %04lx   %s  (%s)\n",
-	       regs, regs->trap, print_tainted(), init_utsname()->release);
+	printk("REGS: %p TRAP: %04lx   %s\n",
+	       regs, regs->trap, print_tainted());
 	printk("MSR: "REG" ", regs->msr);
 	printbits(regs->msr, msr_bits);
 	printk("  CR: %08lx  XER: %08lx\n", regs->ccr, regs->xer);
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 5909039..94fb7e3 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -32,7 +32,6 @@ #include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/ptrace.h>
-#include <linux/utsname.h>
 #include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
@@ -310,11 +309,8 @@ void __show_regs(struct pt_regs * regs)
 
 	printk("\n");
 	print_modules();
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	printk("Pid: %d, comm: %.20s %s\n",
+		current->pid, current->comm, print_tainted());
 	printk("RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->rip);
 	printk_address(regs->rip); 
 	printk("RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss, regs->rsp,
diff --git a/kernel/sys.c b/kernel/sys.c
index 872271c..6e01085 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -31,6 +31,7 @@ #include <linux/signal.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/kdebug.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -98,6 +99,36 @@ struct pid *cad_pid;
 EXPORT_SYMBOL(cad_pid);
 
 /*
+ * Dump out UTS info on oops / panic.  We pregenerate utsname_info so that
+ * we don't access utsname() if the machine is in a potentially bad state.
+ */
+
+static char *utsname_info;
+
+static int dump_utsname(struct notifier_block *self, unsigned long diecode,
+		void *p)
+{
+	printk(KERN_EMERG "%s\n", utsname_info);
+	return 0;
+}
+
+static struct notifier_block utsname_notifier = {
+	.notifier_call = dump_utsname
+};
+
+static int __init register_utsname_dump(void)
+{
+	utsname_info = kasprintf(GFP_KERNEL, "%s %s %s %s",
+		utsname()->sysname,
+		utsname()->release,
+		utsname()->version,
+		utsname()->machine);
+	register_die_notifier(&utsname_notifier);
+	return 0;
+}
+module_init(register_utsname_dump);
+
+/*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
  *	and the like. 
--313268086-999895010-1183686747=:617
Content-Type: TEXT/plain; charset=US-ASCII; name=utsname-on-all-arches.diff
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0707051852270.617@internets.corp.google.com>
Content-Description: 
Content-Disposition: attachment; filename=utsname-on-all-arches.diff

RnJvbTogSm9zaHVhIFdpc2UgPGp3aXNlQGdvb2dsZS5jb20+DQoNCkJhY2tn
cm91bmQ6DQogVGhpcyBwYXRjaCBpcyBhIGZvbGxvdy1vbiB0byAiSW5mbyBk
dW1wIG9uIE9vcHMgb3IgcGFuaWMoKSIgWzFdLg0KIA0KIE9uIHNvbWUgYXJj
aGl0ZWN0dXJlcywgdGhlIGtlcm5lbCBwcmludGVkIHNvbWUgaW5mb3JtYXRp
b24gb24gdGhlIHJ1bm5pbmcNCiBrZXJuZWwsIGJ1dCBub3Qgb24gYWxsIGFy
Y2hpdGVjdHVyZXMuIFRoZSBpbmZvcm1hdGlvbiBwcmludGVkIHdhcyBnZW5l
cmFsbHkNCiB0aGUgdmVyc2lvbiBhbmQgYnVpbGQgbnVtYmVyLCBidXQgaXQg
d2FzIG5vdCBsb2NhdGVkIGluIGEgY29uc2lzdGFudCBwbGFjZSwNCiBhbmQg
c29tZSBhcmNoaXRlY3R1cmVzIGRpZCBub3QgcHJpbnQgaXQgYXQgYWxsLg0K
DQpEZXNjcmlwdGlvbjoNCiBUaGlzIHBhdGNoIHVzZXMgdGhlIGFscmVhZHkt
ZXhpc3RpbmcgZGllX2NoYWluIHRvIHByaW50IHV0c25hbWUgaW5mb3JtYXRp
b24NCiBvbiBPb3BzLiBUaGlzIHBhdGNoIGFsc28gcmVtb3ZlcyB0aGUgYXJj
aGl0ZWN0dXJlLXNwZWNpZmljIHV0c25hbWUNCiBwcmludGVycy4gVG8gYXZv
aWQgY3Jhc2hpbmcgdGhlIHN5c3RlbSBmdXJ0aGVyIChhbmQgaGVuY2Ugbm90
IHByaW50aW5nIHRoZQ0KIE9vcHMpIGluIHRoZSBjYXNlIHdoZXJlIHRoZSBz
eXN0ZW0gaXMgc28gaG9wZWxlc3NseSBzbWFzaGVkIHRoYXQgdXRzbmFtZQ0K
IG1pZ2h0IGJlIGRlc3Ryb3llZCwgd2UgdnNwcmludGYgdGhlIHV0c25hbWUg
ZGF0YSBpbnRvIGEgc3RhdGljIGJ1ZmZlcg0KIGZpcnN0LCBhbmQgdGhlbiBq
dXN0IHByaW50IHRoYXQgb24gY3Jhc2guDQoNClRlc3Rpbmc6DQogSSB3cm90
ZSBhIG1vZHVsZSB0aGF0IGRvZXMgYSAqKGludCopMCA9IDA7IGFuZCBvYnNl
cnZlZCB0aGF0IEkgZ290IG15DQogdXRzbmFtZSBkYXRhIHByaW50ZWQuDQoN
ClBvdGVudGlhbCBpbXBhY3Q6DQogVGhpcyBhZGRzIGFub3RoZXIgbGluZSB0
byB0aGUgT29wcyBvdXRwdXQsIGNhdXNpbmcgdGhlIGZpcnN0IGZldyBsaW5l
cyB0bw0KIHBvdGVudGlhbGx5IHNjcm9sbCBvZmYgdGhlIHNjcmVlbi4gVGhp
cyBhbHNvIGFkZHMgYSBmZXcgbW9yZSBwb2ludGVyDQogZGVyZWZlcmVuY2Vz
IGluIHRoZSBPb3BzIHBhdGgsIGJlY2F1c2UgaXQgYWRkcyB0byB0aGUgZGll
X2NoYWluIG5vdGlmaWVyDQogY2hhaW4sIHJlZHVjaW5nIHRoZSBsaWtlbGlo
b29kIHRoYXQgdGhlIE9vcHMgd2lsbCBiZSBwcmludGVkIGlmIHRoZXJlIGlz
DQogdmVyeSBiYWQgbWVtb3J5IGNvcnJ1cHRpb24uDQoNClBhdGNoOg0KIFRo
aXMgcGF0Y2ggaXMgYWdhaW5zdCBnaXQgMDQ3MTQ0OGY0ZDAxNzQ3MDk5NWQ4
YTIyNzJkYzhjMDZkYmVkM2I3Ny4NCg0KU2lnbmVkLU9mZi1CeTogSm9zaHVh
IFdpc2UgPGp3aXNlQGdvb2dsZS5jb20+DQoNClsxXSBodHRwOi8vbGttbC5v
cmcvbGttbC8yMDA3LzYvMjgvMzE2DQoNCi0tDQoNCmRpZmYgLS1naXQgYS9h
cmNoL2FscGhhL2tlcm5lbC9wcm9jZXNzLmMgYi9hcmNoL2FscGhhL2tlcm5l
bC9wcm9jZXNzLmMNCmluZGV4IDkyYjYxNjIuLjEzZjM0MmUgMTAwNjQ0DQot
LS0gYS9hcmNoL2FscGhhL2tlcm5lbC9wcm9jZXNzLmMNCisrKyBiL2FyY2gv
YWxwaGEva2VybmVsL3Byb2Nlc3MuYw0KQEAgLTIwLDcgKzIwLDYgQEAgI2lu
Y2x1ZGUgPGxpbnV4L3B0cmFjZS5oPg0KICNpbmNsdWRlIDxsaW51eC9zbGFi
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3VzZXIuaD4NCiAjaW5jbHVkZSA8bGlu
dXgvYS5vdXQuaD4NCi0jaW5jbHVkZSA8bGludXgvdXRzbmFtZS5oPg0KICNp
bmNsdWRlIDxsaW51eC90aW1lLmg+DQogI2luY2x1ZGUgPGxpbnV4L21ham9y
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3N0YXQuaD4NCmRpZmYgLS1naXQgYS9h
cmNoL2FybS9rZXJuZWwvcHJvY2Vzcy5jIGIvYXJjaC9hcm0va2VybmVsL3By
b2Nlc3MuYw0KaW5kZXggODQyMzYxNy4uZTQ0NDhmMCAxMDA2NDQNCi0tLSBh
L2FyY2gvYXJtL2tlcm5lbC9wcm9jZXNzLmMNCisrKyBiL2FyY2gvYXJtL2tl
cm5lbC9wcm9jZXNzLmMNCkBAIC0yOCw3ICsyOCw2IEBAICNpbmNsdWRlIDxs
aW51eC9jcHUuaD4NCiAjaW5jbHVkZSA8bGludXgvZWxmY29yZS5oPg0KICNp
bmNsdWRlIDxsaW51eC9wbS5oPg0KICNpbmNsdWRlIDxsaW51eC90aWNrLmg+
DQotI2luY2x1ZGUgPGxpbnV4L3V0c25hbWUuaD4NCiANCiAjaW5jbHVkZSA8
YXNtL2xlZHMuaD4NCiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPg0KQEAg
LTIwMywxMCArMjAyLDggQEAgdm9pZCBfX3Nob3dfcmVncyhzdHJ1Y3QgcHRf
cmVncyAqcmVncykNCiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCiAJY2hhciBi
dWZbNjRdOw0KIA0KLQlwcmludGsoIkNQVTogJWQgICAgJXMgICglcyAlLipz
KVxuIiwNCi0JCXNtcF9wcm9jZXNzb3JfaWQoKSwgcHJpbnRfdGFpbnRlZCgp
LCBpbml0X3V0c25hbWUoKS0+cmVsZWFzZSwNCi0JCShpbnQpc3RyY3Nwbihp
bml0X3V0c25hbWUoKS0+dmVyc2lvbiwgIiAiKSwNCi0JCWluaXRfdXRzbmFt
ZSgpLT52ZXJzaW9uKTsNCisJcHJpbnRrKCJDUFU6ICVkICAgICVzXG4iLA0K
KwkJc21wX3Byb2Nlc3Nvcl9pZCgpLCBwcmludF90YWludGVkKCkpOw0KIAlw
cmludF9zeW1ib2woIlBDIGlzIGF0ICVzXG4iLCBpbnN0cnVjdGlvbl9wb2lu
dGVyKHJlZ3MpKTsNCiAJcHJpbnRfc3ltYm9sKCJMUiBpcyBhdCAlc1xuIiwg
cmVncy0+QVJNX2xyKTsNCiAJcHJpbnRrKCJwYyA6IFs8JTA4bHg+XSAgICBs
ciA6IFs8JTA4bHg+XSAgICBwc3I6ICUwOGx4XG4iDQpkaWZmIC0tZ2l0IGEv
YXJjaC9pMzg2L2tlcm5lbC9wcm9jZXNzLmMgYi9hcmNoL2kzODYva2VybmVs
L3Byb2Nlc3MuYw0KaW5kZXggMDZkZmE2NS4uMTcwMzI0MyAxMDA2NDQNCi0t
LSBhL2FyY2gvaTM4Ni9rZXJuZWwvcHJvY2Vzcy5jDQorKysgYi9hcmNoL2kz
ODYva2VybmVsL3Byb2Nlc3MuYw0KQEAgLTI3LDcgKzI3LDYgQEAgI2luY2x1
ZGUgPGxpbnV4L3ZtYWxsb2MuaD4NCiAjaW5jbHVkZSA8bGludXgvdXNlci5o
Pg0KICNpbmNsdWRlIDxsaW51eC9hLm91dC5oPg0KICNpbmNsdWRlIDxsaW51
eC9pbnRlcnJ1cHQuaD4NCi0jaW5jbHVkZSA8bGludXgvdXRzbmFtZS5oPg0K
ICNpbmNsdWRlIDxsaW51eC9kZWxheS5oPg0KICNpbmNsdWRlIDxsaW51eC9y
ZWJvb3QuaD4NCiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPg0KQEAgLTMwOCwx
MCArMzA3LDggQEAgdm9pZCBzaG93X3JlZ3Moc3RydWN0IHB0X3JlZ3MgKiBy
ZWdzKQ0KIA0KIAlpZiAodXNlcl9tb2RlX3ZtKHJlZ3MpKQ0KIAkJcHJpbnRr
KCIgRVNQOiAlMDR4OiUwOGx4IiwweGZmZmYgJiByZWdzLT54c3MscmVncy0+
ZXNwKTsNCi0JcHJpbnRrKCIgRUZMQUdTOiAlMDhseCAgICAlcyAgKCVzICUu
KnMpXG4iLA0KLQkgICAgICAgcmVncy0+ZWZsYWdzLCBwcmludF90YWludGVk
KCksIGluaXRfdXRzbmFtZSgpLT5yZWxlYXNlLA0KLQkgICAgICAgKGludClz
dHJjc3BuKGluaXRfdXRzbmFtZSgpLT52ZXJzaW9uLCAiICIpLA0KLQkgICAg
ICAgaW5pdF91dHNuYW1lKCktPnZlcnNpb24pOw0KKwlwcmludGsoIiBFRkxB
R1M6ICUwOGx4ICAgICVzXG4iLA0KKwkgICAgICAgcmVncy0+ZWZsYWdzLCBw
cmludF90YWludGVkKCkpOw0KIAlwcmludGsoIkVBWDogJTA4bHggRUJYOiAl
MDhseCBFQ1g6ICUwOGx4IEVEWDogJTA4bHhcbiIsDQogCQlyZWdzLT5lYXgs
cmVncy0+ZWJ4LHJlZ3MtPmVjeCxyZWdzLT5lZHgpOw0KIAlwcmludGsoIkVT
STogJTA4bHggRURJOiAlMDhseCBFQlA6ICUwOGx4IiwNCmRpZmYgLS1naXQg
YS9hcmNoL3Bvd2VycGMva2VybmVsL3Byb2Nlc3MuYyBiL2FyY2gvcG93ZXJw
Yy9rZXJuZWwvcHJvY2Vzcy5jDQppbmRleCA2ZTJmMDM1Li4wNGM0YWJkIDEw
MDY0NA0KLS0tIGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9wcm9jZXNzLmMNCisr
KyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvcHJvY2Vzcy5jDQpAQCAtMzIsNyAr
MzIsNiBAQCAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQogI2luY2x1ZGUg
PGxpbnV4L2thbGxzeW1zLmg+DQogI2luY2x1ZGUgPGxpbnV4L21xdWV1ZS5o
Pg0KICNpbmNsdWRlIDxsaW51eC9oYXJkaXJxLmg+DQotI2luY2x1ZGUgPGxp
bnV4L3V0c25hbWUuaD4NCiANCiAjaW5jbHVkZSA8YXNtL3BndGFibGUuaD4N
CiAjaW5jbHVkZSA8YXNtL3VhY2Nlc3MuaD4NCkBAIC00MTQsOCArNDEzLDgg
QEAgdm9pZCBzaG93X3JlZ3Moc3RydWN0IHB0X3JlZ3MgKiByZWdzKQ0KIA0K
IAlwcmludGsoIk5JUDogIlJFRyIgTFI6ICJSRUciIENUUjogIlJFRyJcbiIs
DQogCSAgICAgICByZWdzLT5uaXAsIHJlZ3MtPmxpbmssIHJlZ3MtPmN0cik7
DQotCXByaW50aygiUkVHUzogJXAgVFJBUDogJTA0bHggICAlcyAgKCVzKVxu
IiwNCi0JICAgICAgIHJlZ3MsIHJlZ3MtPnRyYXAsIHByaW50X3RhaW50ZWQo
KSwgaW5pdF91dHNuYW1lKCktPnJlbGVhc2UpOw0KKwlwcmludGsoIlJFR1M6
ICVwIFRSQVA6ICUwNGx4ICAgJXNcbiIsDQorCSAgICAgICByZWdzLCByZWdz
LT50cmFwLCBwcmludF90YWludGVkKCkpOw0KIAlwcmludGsoIk1TUjogIlJF
RyIgIiwgcmVncy0+bXNyKTsNCiAJcHJpbnRiaXRzKHJlZ3MtPm1zciwgbXNy
X2JpdHMpOw0KIAlwcmludGsoIiAgQ1I6ICUwOGx4ICBYRVI6ICUwOGx4XG4i
LCByZWdzLT5jY3IsIHJlZ3MtPnhlcik7DQpkaWZmIC0tZ2l0IGEvYXJjaC94
ODZfNjQva2VybmVsL3Byb2Nlc3MuYyBiL2FyY2gveDg2XzY0L2tlcm5lbC9w
cm9jZXNzLmMNCmluZGV4IDU5MDkwMzkuLjk0ZmI3ZTMgMTAwNjQ0DQotLS0g
YS9hcmNoL3g4Nl82NC9rZXJuZWwvcHJvY2Vzcy5jDQorKysgYi9hcmNoL3g4
Nl82NC9rZXJuZWwvcHJvY2Vzcy5jDQpAQCAtMzIsNyArMzIsNiBAQCAjaW5j
bHVkZSA8bGludXgvYS5vdXQuaD4NCiAjaW5jbHVkZSA8bGludXgvaW50ZXJy
dXB0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQogI2luY2x1ZGUg
PGxpbnV4L3B0cmFjZS5oPg0KLSNpbmNsdWRlIDxsaW51eC91dHNuYW1lLmg+
DQogI2luY2x1ZGUgPGxpbnV4L3JhbmRvbS5oPg0KICNpbmNsdWRlIDxsaW51
eC9ub3RpZmllci5oPg0KICNpbmNsdWRlIDxsaW51eC9rcHJvYmVzLmg+DQpA
QCAtMzEwLDExICszMDksOCBAQCB2b2lkIF9fc2hvd19yZWdzKHN0cnVjdCBw
dF9yZWdzICogcmVncykNCiANCiAJcHJpbnRrKCJcbiIpOw0KIAlwcmludF9t
b2R1bGVzKCk7DQotCXByaW50aygiUGlkOiAlZCwgY29tbTogJS4yMHMgJXMg
JXMgJS4qc1xuIiwNCi0JCWN1cnJlbnQtPnBpZCwgY3VycmVudC0+Y29tbSwg
cHJpbnRfdGFpbnRlZCgpLA0KLQkJaW5pdF91dHNuYW1lKCktPnJlbGVhc2Us
DQotCQkoaW50KXN0cmNzcG4oaW5pdF91dHNuYW1lKCktPnZlcnNpb24sICIg
IiksDQotCQlpbml0X3V0c25hbWUoKS0+dmVyc2lvbik7DQorCXByaW50aygi
UGlkOiAlZCwgY29tbTogJS4yMHMgJXNcbiIsDQorCQljdXJyZW50LT5waWQs
IGN1cnJlbnQtPmNvbW0sIHByaW50X3RhaW50ZWQoKSk7DQogCXByaW50aygi
UklQOiAlMDRseDpbPCUwMTZseD5dICIsIHJlZ3MtPmNzICYgMHhmZmZmLCBy
ZWdzLT5yaXApOw0KIAlwcmludGtfYWRkcmVzcyhyZWdzLT5yaXApOyANCiAJ
cHJpbnRrKCJSU1A6ICUwNGx4OiUwMTZseCAgRUZMQUdTOiAlMDhseFxuIiwg
cmVncy0+c3MsIHJlZ3MtPnJzcCwNCmRpZmYgLS1naXQgYS9rZXJuZWwvc3lz
LmMgYi9rZXJuZWwvc3lzLmMNCmluZGV4IDg3MjI3MWMuLjZlMDEwODUgMTAw
NjQ0DQotLS0gYS9rZXJuZWwvc3lzLmMNCisrKyBiL2tlcm5lbC9zeXMuYw0K
QEAgLTMxLDYgKzMxLDcgQEAgI2luY2x1ZGUgPGxpbnV4L3NpZ25hbC5oPg0K
ICNpbmNsdWRlIDxsaW51eC9jbl9wcm9jLmg+DQogI2luY2x1ZGUgPGxpbnV4
L2dldGNwdS5oPg0KICNpbmNsdWRlIDxsaW51eC90YXNrX2lvX2FjY291bnRp
bmdfb3BzLmg+DQorI2luY2x1ZGUgPGxpbnV4L2tkZWJ1Zy5oPg0KIA0KICNp
bmNsdWRlIDxsaW51eC9jb21wYXQuaD4NCiAjaW5jbHVkZSA8bGludXgvc3lz
Y2FsbHMuaD4NCkBAIC05OCw2ICs5OSwzNiBAQCBzdHJ1Y3QgcGlkICpjYWRf
cGlkOw0KIEVYUE9SVF9TWU1CT0woY2FkX3BpZCk7DQogDQogLyoNCisgKiBE
dW1wIG91dCBVVFMgaW5mbyBvbiBvb3BzIC8gcGFuaWMuICBXZSBwcmVnZW5l
cmF0ZSB1dHNuYW1lX2luZm8gc28gdGhhdA0KKyAqIHdlIGRvbid0IGFjY2Vz
cyB1dHNuYW1lKCkgaWYgdGhlIG1hY2hpbmUgaXMgaW4gYSBwb3RlbnRpYWxs
eSBiYWQgc3RhdGUuDQorICovDQorDQorc3RhdGljIGNoYXIgKnV0c25hbWVf
aW5mbzsNCisNCitzdGF0aWMgaW50IGR1bXBfdXRzbmFtZShzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKnNlbGYsIHVuc2lnbmVkIGxvbmcgZGllY29kZSwNCisJ
CXZvaWQgKnApDQorew0KKwlwcmludGsoS0VSTl9FTUVSRyAiJXNcbiIsIHV0
c25hbWVfaW5mbyk7DQorCXJldHVybiAwOw0KK30NCisNCitzdGF0aWMgc3Ry
dWN0IG5vdGlmaWVyX2Jsb2NrIHV0c25hbWVfbm90aWZpZXIgPSB7DQorCS5u
b3RpZmllcl9jYWxsID0gZHVtcF91dHNuYW1lDQorfTsNCisNCitzdGF0aWMg
aW50IF9faW5pdCByZWdpc3Rlcl91dHNuYW1lX2R1bXAodm9pZCkNCit7DQor
CXV0c25hbWVfaW5mbyA9IGthc3ByaW50ZihHRlBfS0VSTkVMLCAiJXMgJXMg
JXMgJXMiLA0KKwkJdXRzbmFtZSgpLT5zeXNuYW1lLA0KKwkJdXRzbmFtZSgp
LT5yZWxlYXNlLA0KKwkJdXRzbmFtZSgpLT52ZXJzaW9uLA0KKwkJdXRzbmFt
ZSgpLT5tYWNoaW5lKTsNCisJcmVnaXN0ZXJfZGllX25vdGlmaWVyKCZ1dHNu
YW1lX25vdGlmaWVyKTsNCisJcmV0dXJuIDA7DQorfQ0KK21vZHVsZV9pbml0
KHJlZ2lzdGVyX3V0c25hbWVfZHVtcCk7DQorDQorLyoNCiAgKglOb3RpZmll
ciBsaXN0IGZvciBrZXJuZWwgY29kZSB3aGljaCB3YW50cyB0byBiZSBjYWxs
ZWQNCiAgKglhdCBzaHV0ZG93bi4gVGhpcyBpcyB1c2VkIHRvIHN0b3AgYW55
IGlkbGluZyBETUEgb3BlcmF0aW9ucw0KICAqCWFuZCB0aGUgbGlrZS4gDQo=

--313268086-999895010-1183686747=:617--
