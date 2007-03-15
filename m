Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbXCOUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbXCOUXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbXCOUXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:23:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:53670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834AbXCOUXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:23:49 -0400
Date: Thu, 15 Mar 2007 21:23:43 +0100
From: Bernhard Walle <bwalle@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Initialise SAK member for each virtual console to prevent oops
Message-ID: <20070315202342.GE1618@strauss.suse.de>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070311204137.GD12950@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311204137.GD12950@strauss.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initialises the SAK member of the vc_cons variable on all virtual
terminals, not only the first one. This prevents an oops when trying
Sysrq-C on e.g. the second virtual terminal:

  kernel BUG at kernel/workqueue.c:212!
  invalid opcode: 0000 [1] SMP 
  CPU 0 
  Modules linked in: i915 drm deflate zlib_deflate twofish twofish_common serpent blowfish des ce
  Pid: 0, comm: swapper Not tainted 2.6.21-rc3-default #15
  RIP: 0010:[<ffffffff8028c955>]  [<ffffffff8028c955>] queue_work+0x32/0x51
  RSP: 0018:ffffffff805fada8  EFLAGS: 00010013
  RAX: ffffffff80683f38 RBX: ffffffff804ae700 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff80683f30 RDI: ffff81000134a840
  RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000002
  R10: ffffffff805990e0 R11: ffff810037f4c0f0 R12: 000000000000006b
  R13: ffff81007aa23000 R14: 0000000000000001 R15: 0000000000000096
  FS:  0000000000000000(0000) GS:ffffffff804d8000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
  CR2: 00002b72026e9000 CR3: 0000000079175000 CR4: 00000000000006e0
  Process swapper (pid: 0, threadinfo ffffffff8059e000, task ffffffff80490840)
  Stack:  0000000000000096 ffffffff803635db ffffffff805fadf8 0000000000000001
   ffff8100013c2e40 0000000000000025 ffff81007c931c00 ffff81007aa23000
   0000000000000001 ffffffff8035e3ee 0000000000000092 ffff810037cc8000
  Call Trace:
   <IRQ>  [<ffffffff803635db>] __handle_sysrq+0x98/0x129
   [<ffffffff8035e3ee>] kbd_event+0x32e/0x56a
   [<ffffffff8037d502>] input_event+0x422/0x44a
   [<ffffffff80381d71>] atkbd_interrupt+0x449/0x503
   [<ffffffff8037a42d>] serio_interrupt+0x37/0x6f
   [<ffffffff8037affb>] i8042_interrupt+0x1f4/0x20a
   [<ffffffff8026bd20>] smp_send_timer_broadcast_ipi+0x2d/0x4e
   [<ffffffff8020eee5>] handle_IRQ_event+0x25/0x53
   [<ffffffff802a924c>] handle_edge_irq+0xe4/0x128
   [<ffffffff802562ac>] call_softirq+0x1c/0x28
   [<ffffffff802632eb>] do_IRQ+0x6c/0xd3
   [<ffffffff8024f4e7>] mwait_idle+0x0/0x45
   [<ffffffff80255631>] ret_from_intr+0x0/0xa
   <EOI>  [<ffffffff80248a4d>] datagram_poll+0x0/0xc8
   [<ffffffff8024f529>] mwait_idle+0x42/0x45
   [<ffffffff80242c05>] cpu_idle+0x8b/0xae
   [<ffffffff805a8779>] start_kernel+0x2b9/0x2c5
   [<ffffffff805a815e>] _sinittext+0x15e/0x162


  Code: 0f 0b eb fe 48 8b 07 48 63 d2 48 f7 d0 48 8b 3c d0 e8 13 ff 
  RIP  [<ffffffff8028c955>] queue_work+0x32/0x51
   RSP <ffffffff805fada8>
  Kernel panic - not syncing: Aiee, killing interrupt handler!


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/char/vt.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-rc3/drivers/char/vt.c
===================================================================
--- linux-2.6.21-rc3.orig/drivers/char/vt.c
+++ linux-2.6.21-rc3/drivers/char/vt.c
@@ -724,6 +724,7 @@ int vc_allocate(unsigned int currcons)	/
 		return -ENOMEM;
 	    memset(vc, 0, sizeof(*vc));
 	    vc_cons[currcons].d = vc;
+	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
