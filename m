Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXJPF6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXJPF6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbXJPF6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:58:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760993AbXJPF6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:58:17 -0400
Date: Tue, 16 Oct 2007 07:58:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch] sound: fix bootup crash in snd_gus_interrupt()
Message-ID: <20071016055809.GA1648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sound: fix bootup crash in snd_gus_interrupt()
From: Ingo Molnar <mingo@elte.hu>

when simulating a storm of fake GUS interrupts (without actually owning 
this venerable piece of ISA hardware) the driver falls over (crashes) in 
two ways:

1) spinlocks being initialized too late:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
 [<401058ca>] show_trace_log_lvl+0x1a/0x30
 [<401064b2>] show_trace+0x12/0x20
 [<401064d6>] dump_stack+0x16/0x20
 [<4014a72b>] __lock_acquire+0xcfb/0x1030
 [<4014aac0>] lock_acquire+0x60/0x80
 [<40721a68>] _spin_lock_irqsave+0x38/0x50
 [<4058fc12>] snd_gf1_i_look8+0x22/0x60
 [<405906fe>] snd_gus_interrupt+0x13e/0x270
 [<401548e8>] handle_IRQ_event+0x28/0x60
 [<40155cc1>] handle_fasteoi_irq+0x71/0xe0
 [<40107238>] do_IRQ+0x48/0xa0
 [<401051fe>] common_interrupt+0x2e/0x40
 [<40156822>] register_handler_proc+0x92/0xf0
 [<401550c2>] setup_irq+0xe2/0x190
 [<40155224>] request_irq+0xb4/0xd0
 [<4058f524>] snd_gus_create+0x124/0x3c0
 [<40aa4087>] snd_gusclassic_probe+0x2a7/0x4b0
 [<403f5eff>] isa_bus_probe+0x1f/0x30
 [<403f1944>] driver_probe_device+0x84/0x190
 [<403f1a58>] __device_attach+0x8/0x10
 [<403f0e63>] bus_for_each_drv+0x53/0x80
 [<403f1b1b>] device_attach+0x8b/0x90
 [<403f0dd8>] bus_attach_device+0x48/0x80
 [<403efdbd>] device_add+0x45d/0x5a0
 [<403eff12>] device_register+0x12/0x20
 [<403f60c3>] isa_register_driver+0xb3/0x140
 [<40aa3dd2>] alsa_card_gusclassic_init+0x12/0x20
 [<40a665c3>] kernel_init+0x133/0x310
 [<401054a7>] kernel_thread_helper+0x7/0x10
 =======================

2) callback functions not being filled in yet:

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 00000000
Oops: 0000 [#1]
SMP DEBUG_PAGEALLOC
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010002   (2.6.23 #37)
EIP is at 0x0
eax: 7fe94000   ebx: 7fe94000   ecx: 00000000   edx: 00000226
esi: 00000000   edi: 00000005   ebp: 7ff87c28   esp: 7ff87bf4
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=7ff86000 task=7ff84000 task.ti=7ff86000)
Stack: 40590683 408424a9 408db87c 00000029 40787406 00000064 00000046 ff000000 
       000000ff 00000001 7faefaf0 00000000 00000005 7ff87c40 401548e8 00000000 
       40a52000 7faefaf0 00000005 7ff87c58 40155cc1 40a52030 00000005 00000000 
Call Trace:
 [<401058ca>] show_trace_log_lvl+0x1a/0x30
 [<4010598b>] show_stack_log_lvl+0xab/0xd0
 [<40105b7c>] show_registers+0x1cc/0x2d0
 [<40105d96>] die+0x116/0x240
 [<4011d7bb>] do_page_fault+0x18b/0x670
 [<40721d22>] error_code+0x72/0x80
 [<401548e8>] handle_IRQ_event+0x28/0x60
 [<40155cc1>] handle_fasteoi_irq+0x71/0xe0
 [<40107238>] do_IRQ+0x48/0xa0
 [<401051fe>] common_interrupt+0x2e/0x40
 [<401a344e>] proc_create+0x3e/0x120
 [<401a3733>] proc_mkdir_mode+0x23/0x50
 [<401a376f>] proc_mkdir+0xf/0x20
 [<40156864>] register_handler_proc+0xd4/0xf0
 [<401550c2>] setup_irq+0xe2/0x190
 [<40155224>] request_irq+0xb4/0xd0
 [<4058f524>] snd_gus_create+0x124/0x3c0
 [<40aa4087>] snd_gusclassic_probe+0x2a7/0x4b0
 [<403f5eff>] isa_bus_probe+0x1f/0x30
 [<403f1944>] driver_probe_device+0x84/0x190
 [<403f1a58>] __device_attach+0x8/0x10
 [<403f0e63>] bus_for_each_drv+0x53/0x80
 [<403f1b1b>] device_attach+0x8b/0x90
 [<403f0dd8>] bus_attach_device+0x48/0x80
 [<403efdbd>] device_add+0x45d/0x5a0
 [<403eff12>] device_register+0x12/0x20
 [<403f60c3>] isa_register_driver+0xb3/0x140
 [<40aa3dd2>] alsa_card_gusclassic_init+0x12/0x20
 [<40a665c3>] kernel_init+0x133/0x310
 [<401054a7>] kernel_thread_helper+0x7/0x10
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:7ff87bf4
Kernel panic - not syncing: Fatal exception in interrupt

with these things fixed, i get the expected "no such hardware" result 
from the driver initialization:

 Calling initcall 0x40aa3dc0: alsa_card_gusclassic_init+0x0/0x20()
 ALSA sound/isa/gus/gusclassic.c:136: [0x220] check 1 failed - 0xff
 initcall 0x40aa3dc0: alsa_card_gusclassic_init+0x0/0x20() returned 0.
 initcall 0x40aa3dc0 ran for 133 msecs: 
 alsa_card_gusclassic_init+0x0/0x20()

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/isa/gus/gus_irq.c  |   18 ++++++++++++------
 sound/isa/gus/gus_main.c |   16 ++++++++--------
 2 files changed, 20 insertions(+), 14 deletions(-)

Index: linux/sound/isa/gus/gus_irq.c
===================================================================
--- linux.orig/sound/isa/gus/gus_irq.c
+++ linux/sound/isa/gus/gus_irq.c
@@ -45,11 +45,13 @@ __again:
 	// snd_printk("IRQ: status = 0x%x\n", status);
 	if (status & 0x02) {
 		STAT_ADD(gus->gf1.interrupt_stat_midi_in);
-		gus->gf1.interrupt_handler_midi_in(gus);
+		if (gus->gf1.interrupt_handler_midi_in)
+			gus->gf1.interrupt_handler_midi_in(gus);
 	}
 	if (status & 0x01) {
 		STAT_ADD(gus->gf1.interrupt_stat_midi_out);
-		gus->gf1.interrupt_handler_midi_out(gus);
+		if (gus->gf1.interrupt_handler_midi_out)
+			gus->gf1.interrupt_handler_midi_out(gus);
 	}
 	if (status & (0x20 | 0x40)) {
 		unsigned int already, _current_;
@@ -85,20 +87,24 @@ __again:
 	}
 	if (status & 0x04) {
 		STAT_ADD(gus->gf1.interrupt_stat_timer1);
-		gus->gf1.interrupt_handler_timer1(gus);
+		if (gus->gf1.interrupt_handler_timer1)
+			gus->gf1.interrupt_handler_timer1(gus);
 	}
 	if (status & 0x08) {
 		STAT_ADD(gus->gf1.interrupt_stat_timer2);
-		gus->gf1.interrupt_handler_timer2(gus);
+		if (gus->gf1.interrupt_handler_timer2)
+			gus->gf1.interrupt_handler_timer2(gus);
 	}
 	if (status & 0x80) {
 		if (snd_gf1_i_look8(gus, SNDRV_GF1_GB_DRAM_DMA_CONTROL) & 0x40) {
 			STAT_ADD(gus->gf1.interrupt_stat_dma_write);
-			gus->gf1.interrupt_handler_dma_write(gus);
+			if (gus->gf1.interrupt_handler_dma_write)
+				gus->gf1.interrupt_handler_dma_write(gus);
 		}
 		if (snd_gf1_i_look8(gus, SNDRV_GF1_GB_REC_DMA_CONTROL) & 0x40) {
 			STAT_ADD(gus->gf1.interrupt_stat_dma_read);
-			gus->gf1.interrupt_handler_dma_read(gus);
+			if (gus->gf1.interrupt_handler_dma_read)
+				gus->gf1.interrupt_handler_dma_read(gus);
 		}
 	}
 	if (--loop > 0)
Index: linux/sound/isa/gus/gus_main.c
===================================================================
--- linux.orig/sound/isa/gus/gus_main.c
+++ linux/sound/isa/gus/gus_main.c
@@ -154,6 +154,14 @@ int snd_gus_create(struct snd_card *card
 	gus = kzalloc(sizeof(*gus), GFP_KERNEL);
 	if (gus == NULL)
 		return -ENOMEM;
+	spin_lock_init(&gus->reg_lock);
+	spin_lock_init(&gus->voice_alloc);
+	spin_lock_init(&gus->active_voice_lock);
+	spin_lock_init(&gus->event_lock);
+	spin_lock_init(&gus->dma_lock);
+	spin_lock_init(&gus->pcm_volume_level_lock);
+	spin_lock_init(&gus->uart_cmd_lock);
+	mutex_init(&gus->dma_mutex);
 	gus->gf1.irq = -1;
 	gus->gf1.dma1 = -1;
 	gus->gf1.dma2 = -1;
@@ -218,14 +226,6 @@ int snd_gus_create(struct snd_card *card
 	gus->gf1.pcm_channels = pcm_channels;
 	gus->gf1.volume_ramp = 25;
 	gus->gf1.smooth_pan = 1;
-	spin_lock_init(&gus->reg_lock);
-	spin_lock_init(&gus->voice_alloc);
-	spin_lock_init(&gus->active_voice_lock);
-	spin_lock_init(&gus->event_lock);
-	spin_lock_init(&gus->dma_lock);
-	spin_lock_init(&gus->pcm_volume_level_lock);
-	spin_lock_init(&gus->uart_cmd_lock);
-	mutex_init(&gus->dma_mutex);
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, gus, &ops)) < 0) {
 		snd_gus_free(gus);
 		return err;
