Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZIGOQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZIGOQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZIGOQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:16:11 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:45910 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZIGOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:16:09 -0400
Date: Mon, 7 Sep 2009 19:45:58 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix error handling in load_module()
Message-ID: <20090907141558.GA5456@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

	During our testing following call trace was seen. The testcase was
to compile the kernel based on the distro config and try to insert all the
modules compiled.

#!/bin/sh

for module in `modprobe -l | tr '\n' ' '`
do
	insert_module=`basename $module .ko`
	modprobe -v $insert_module
done

freq_table sputrace hvcserver axonram pmi ipv6 fuse ehea ib
Sep  7 15:46:04 mjs22lp5 kernel: mveth ibmvscsic scsi_transport_srp scsi_tgt
Sep  7 15:46:04 mjs22lp5 kernel: NIP: c0000000000ebba0 LR: c0000000000ee79c CTR: 0000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: REGS: c00000002c90b8e0 TRAP: 0700 Tainted: P      D     (2.6.31-rc8)
Sep  7 15:46:04 mjs22lp5 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR> CR: 24222488  XER: 00000008
Sep  7 15:46:04 mjs22lp5 kernel: TASK = c00000002ff40000[9062] 'modprobe' THREAD: c00000002c908000 CPU: 0
Sep  7 15:46:04 mjs22lp5 kernel: GPR00: 0000000000000010 c00000002c90bb60 c000000001421e68 0000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: GPR04: c000000000691a5c c00000000009f5c4 0000000000000000 c0000000167f6630
Sep  7 15:46:04 mjs22lp5 kernel: GPR08: c0000000167f72a4 000000000000031f c000000000bb9580 000000000000031e
Sep  7 15:46:04 mjs22lp5 kernel: GPR12: 800000000631b800 c0000000015a2600 0000000000000000 0000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: GPR16: 0000000000000033 d00000000fb1f6d0 d00000000fb1fe50 000000000000000e
Sep  7 15:46:04 mjs22lp5 kernel: GPR20: d00000000fb1efb8 d00000000fb62260 d00000000fb00000 8000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: GPR24: 0000000000000004 d00000000fb1f190 0000000000000035 fffffffffffffff4
Sep  7 15:46:04 mjs22lp5 kernel: GPR28: 0000000000000000 000000000000031e c00000000137def8 c00000002c90bb60
Sep  7 15:46:04 mjs22lp5 kernel: NIP [c0000000000ebba0] .percpu_modfree+0xe8/0x210
Sep  7 15:46:04 mjs22lp5 kernel: LR [c0000000000ee79c] .load_module+0x14f8/0x1650
Sep  7 15:46:04 mjs22lp5 kernel: Call Trace:
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90bb60] [c00000002c90bc00] 0xc00000002c90bc00 (unreliable)
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90bc00] [c0000000000ee79c] .load_module+0x14f8/0x1650
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90bd90] [c0000000000ee988] .SyS_init_module+0x94/0x2ac
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90be30] [c0000000000084dc] syscall_exit+0x0/0x40
Sep  7 15:46:04 mjs22lp5 kernel: Instruction dump:
Sep  7 15:46:05 mjs22lp5 kernel: 48000038 e8080006 793d0020 39080004 78090020 2f800000 409c000c 7c0000d0
Sep  7 15:46:05 mjs22lp5 kernel: 78090020 7d4a4a14 393d0001 4200ffb0 <0fe00000> 48000000 38a30001 7f83e378
Sep  7 15:46:05 mjs22lp5 kernel: ---[ end trace 3c8bbdf1034c7f0d ]---

Once the percpu_modalloc fails, percpu_modfree(mod->refptr) is called on a NULL pointer.
We try calling it on a NULL pointer. The following patch fixes the problem by introducing 
a check for mod->refptr before calling percpu_modfree.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 kernel/module.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2d53718..7f89258 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2379,7 +2379,8 @@ static noinline struct module *load_module(void __user *umod,
 	module_unload_free(mod);
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
  free_init:
-	percpu_modfree(mod->refptr);
+	if (mod->refptr)
+		percpu_modfree(mod->refptr);
 #endif
 	module_free(mod, mod->module_init);
  free_core:
			
			Kamalesh
