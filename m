Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYAPV1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYAPV1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYAPV1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:27:44 -0500
Received: from lazybastard.de ([212.112.238.170]:59187 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYAPV1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:27:43 -0500
Date: Wed, 16 Jan 2008 22:20:54 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, Erez Zadok <ezk@cs.sunysb.edu>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
Message-ID: <20080116212054.GA891@lazybastard.org>
References: <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu> <1199700326.7143.10.camel@twins> <200801081147.00701.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801081147.00701.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 January 2008 11:47:00 +1100, Rusty Russell wrote:
> 
>     There's nothing wrong with this patch, but I think it papers over a more
> general problem: we enter the module (to parse args) while it's not in the
> module list.  This also means we won't get a nice oops if it crashes.
> 
>     This is untested, but does it solve it for you?

Not sure about lockdep, but it makes all the difference for an oops,
forced by explicit BUG() in block2mtd.

Before:
kernel BUG at drivers/mtd/devices/block2mtd.c:382!
invalid opcode: 0000 [#1]
Modules linked in:
CPU:    0
EIP:    0060:[<e0818003>]    Not tainted VLI
EFLAGS: 00000246   (2.6.22 #38)
EIP is at 0xe0818003
eax: dfe8c7da   ebx: dfe8c7d0   ecx: e08185a8   edx: e08185a8
esi: e0818b1c   edi: dfe8c7da   ebp: df95de78   esp: df95de78
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process insmod (pid: 1076, ti=df95c000 task=df903080 task.ti=df95c000)
Stack: df95dec4 c0125576 00000000 df95de90 fffffff8 e0815932 00000006 00000000 
       e08185a8 e0818b4c 00000283 00000000 0000000b e0818b1c 00000000 dfe8c7dc 
       00000014 e0815b48 00000014 df95dfb0 c01314e4 00000001 00000000 df95df24 
Call Trace:
 [<c0103248>] show_trace_log_lvl+0x1a/0x2f
 [<c01032f8>] show_stack_log_lvl+0x9b/0xa3
 [<c01034be>] show_registers+0x1be/0x290
 [<c010366f>] die+0xdf/0x1a1
 [<c01037ba>] do_trap+0x89/0xa2
 [<c0103b25>] do_invalid_op+0x88/0x92
 [<c0384e82>] error_code+0x6a/0x70
 [<c0125576>] parse_args+0x120/0x1f6
 [<c01314e4>] sys_init_module+0xf76/0x1297
 [<c01023ee>] syscall_call+0x7/0xb
 =======================
Code: <0f> 0b eb fe 55 85 c0 89 e5 53 89 c3 74 31 8b 40 28 e8 ee 3e 93 df 
EIP: [<e0818003>] 0xe0818003 SS:ESP 0068:df95de78

After:
kernel BUG at drivers/mtd/devices/block2mtd.c:382!
invalid opcode: 0000 [#1]
Modules linked in: block2mtd
CPU:    0
EIP:    0060:[<f8820003>]    Not tainted VLI
EFLAGS: 00000246   (2.6.22 #39)
EIP is at block2mtd_setup+0x3/0x7 [block2mtd]
eax: f7da387a   ebx: f7da3870   ecx: f88205a8   edx: f88205a8
esi: f8820b1c   edi: f7da387a   ebp: f788be78   esp: f788be78
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process insmod (pid: 1072, ti=f788a000 task=c1b22b00 task.ti=f788a000)
Stack: f788bec4 c0125576 00000000 f788be90 fffffff8 f881d932 00000006 00000000 
       f88205a8 f8820b4c 00000283 00000000 0000000b f8820b1c 00000000 f7da387c 
       00000014 f881db48 00000014 f788bfb0 c01314f1 00000001 00000000 f788bf24 
Call Trace:
 [<c0103248>] show_trace_log_lvl+0x1a/0x2f
 [<c01032f8>] show_stack_log_lvl+0x9b/0xa3
 [<c01034be>] show_registers+0x1be/0x290
 [<c010366f>] die+0xdf/0x1a1
 [<c01037ba>] do_trap+0x89/0xa2
 [<c0103b25>] do_invalid_op+0x88/0x92
 [<c0384e92>] error_code+0x6a/0x70
 [<c0125576>] parse_args+0x120/0x1f6
 [<c01314f1>] sys_init_module+0xf83/0x12a4
 [<c01023ee>] syscall_call+0x7/0xb
 =======================
Code: <0f> 0b eb fe 55 85 c0 89 e5 53 89 c3 74 31 8b 40 28 e8 fa be 92 c7 
EIP: [<f8820003>] block2mtd_setup+0x3/0x7 [block2mtd] SS:ESP 0068:f788be78


Patch didn't compile due to function ordering.  Here is an updated version.

Acked-and-tested-by: Joern Engel <joern@lazybastard.org>

diff --git a/kernel/module.c b/kernel/module.c
index c2e3e2e..0397b1e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1645,6 +1645,17 @@ static inline void add_kallsyms(struct module *mod,
 }
 #endif /* CONFIG_KALLSYMS */
 
+/*
+ * link the module with the whole machine is stopped with interrupts off
+ * - this defends against kallsyms not taking locks
+ */
+static int __link_module(void *_mod)
+{
+	struct module *mod = _mod;
+	list_add(&mod->list, &modules);
+	return 0;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static struct module *load_module(void __user *umod,
@@ -2023,6 +2034,11 @@ static struct module *load_module(void __user *umod,
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
 		       mod->name);
 
+	/* Now sew it into the lists so we can get lockdep and oops
+         * info during argument parsing.  Noone should access us, since
+         * strong_try_module_get() will fail. */
+	stop_machine_run(__link_module, mod, NR_CPUS);
+
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
 			 (struct kernel_param *)
@@ -2031,7 +2047,7 @@ static struct module *load_module(void __user *umod,
 			 / sizeof(struct kernel_param),
 			 NULL);
 	if (err < 0)
-		goto arch_cleanup;
+		goto unlink;
 
 	err = mod_sysfs_setup(mod,
 			      (struct kernel_param *)
@@ -2039,7 +2055,7 @@ static struct module *load_module(void __user *umod,
 			      sechdrs[setupindex].sh_size
 			      / sizeof(struct kernel_param));
 	if (err < 0)
-		goto arch_cleanup;
+		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
@@ -2054,7 +2070,8 @@ static struct module *load_module(void __user *umod,
 	/* Done! */
 	return mod;
 
- arch_cleanup:
+ unlink:
+	stop_machine_run(__unlink_module, mod, NR_CPUS);
 	module_arch_cleanup(mod);
  cleanup:
 	module_unload_free(mod);
@@ -2076,17 +2093,6 @@ static struct module *load_module(void __user *umod,
 	goto free_hdr;
 }
 
-/*
- * link the module with the whole machine is stopped with interrupts off
- * - this defends against kallsyms not taking locks
- */
-static int __link_module(void *_mod)
-{
-	struct module *mod = _mod;
-	list_add(&mod->list, &modules);
-	return 0;
-}
-
 /* This is where the real work happens */
 asmlinkage long
 sys_init_module(void __user *umod,
@@ -2111,10 +2117,6 @@ sys_init_module(void __user *umod,
 		return PTR_ERR(mod);
 	}
 
-	/* Now sew it into the lists.  They won't access us, since
-           strong_try_module_get() will fail. */
-	stop_machine_run(__link_module, mod, NR_CPUS);
-
 	/* Drop lock so they can recurse */
 	mutex_unlock(&module_mutex);
 
