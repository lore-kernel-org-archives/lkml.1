Return-Path: <linux-kernel-owner+w=401wt.eu-S940819AbXGSTmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940819AbXGSTmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXGSTmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:42:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762499AbXGSTmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:42:44 -0400
Date: Thu, 19 Jul 2007 21:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: [patch] slub crashes with recent -git
Message-ID: <20070719194234.GA27917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, Christoph,

recent slub commits in -git cause this bootup crash:

 Freeing unused kernel memory: 324k freed
 Write protecting the kernel read-only data: 1294k
 ------------[ cut here ]------------
 kernel BUG at mm/slub.c:2401!
 invalid opcode: 0000 [#1]
 PREEMPT SMP 
 Modules linked in:
 CPU:    0
 EIP:    0060:[<c017dac3>]    Not tainted VLI
 EFLAGS: 00010046   (2.6.22 #1)
 EIP is at ksize+0x13/0x42
 eax: 00000000   ebx: 00000000   ecx: 00000020   edx: 00000000
 esi: f76a4000   edi: 00000004   ebp: f7b11e74   esp: f7b11e74
 ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
 Process udevd (pid: 824, ti=f7b11000 task=f7ca5000 task.ti=f7b11000)
 Stack: f7b11e94 c016c28b f768cb00 00000020 f7ca5000 00000004 f76a4000 fffffff4 
        f7b11eb4 c03cf158 00000002 f76a4000 00000020 f768cb00 f76a4000 f7b11ed8 
        f7b11ed0 c03cfbc6 f768cb00 f768cb00 c046bf80 f768cb00 0000000c f7b11f6c 
 Call Trace:
  [<c0105e3e>] show_trace_log_lvl+0x19/0x2e
  [<c0105ef0>] show_stack_log_lvl+0x9d/0xa5
  [<c010628f>] show_registers+0x1f5/0x334
  [<c01064e6>] die+0x118/0x1fc
  [<c0426e7f>] do_trap+0x8e/0xa8
  [<c0106ac3>] do_invalid_op+0x88/0x92
  [<c0426a92>] error_code+0x72/0x78
  [<c016c28b>] krealloc+0x27/0x6d
  [<c03cf158>] netlink_realloc_groups+0x61/0xd9
  [<c03cfbc6>] netlink_bind+0x4f/0x121
  [<c03afe8d>] sys_bind+0x67/0x86
  [<c03b11e3>] sys_socketcall+0x8f/0x244
  [<c0104ef2>] sysenter_past_esp+0x6b/0xb5
  =======================
 Code: 40 02 00 75 03 8b 52 0c 8b 02 5d 84 c0 b8 00 00 00 00 0f 49 d0 89 d0 c3 55 31 d2 83 f8 10 89 e5 74 34 e8 bc ff ff ff 85 c0 75 04 <0f> 0b eb fe 8b 40 10 85 c0 75 04 0f 0b eb fe 8b 10 f6 c6 0c 74 

i had to apply the patch below to make the kernel boot again.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -2394,7 +2394,7 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (object == ZERO_SIZE_PTR)
+	if (object == ZERO_SIZE_PTR || !object)
 		return 0;
 
 	page = get_object_page(object);
