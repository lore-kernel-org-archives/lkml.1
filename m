Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZGERcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZGERcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 13:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZGERbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 13:31:53 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39727 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZGERbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 13:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Jji50jgjZaxEeBsilrJmUuZDqqC6j+me3W/qXAr4p/SKIm+uuADaVFxRJXp4XCWfyC
         467z9vaheotvOTFIH5c0FcApHHyBdO6OVHDEahzUWhdZSe5+aSbgvF+OLJq/WHkcKEl7
         QDXh3mvXV7vHOx/WQOnU6lXgT3a9zrs8wq9Hs=
MIME-Version: 1.0
Date: Sun, 5 Jul 2009 18:31:54 +0100
Message-ID: <6278d2220907051031r50280d2ch903b7804e9e95696@mail.gmail.com>
Subject: [2.6.30.1] DMA debug/AHCI SG inconsistency...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running 2.6.30.1 checked for a while, I observed:

WARNING: at lib/dma-debug.c:565 check_unmap+0x518/0x5f0()

Hardware name: OEM

ahci 0000:00:1f.2: DMA-API: device driver frees DMA sg list with
different entry count [map count=124] [unmap count=117]

Modules linked in: coretemp w83627ehf hwmon_vid snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_pcm snd_timer ath9k snd mac80211
led_class soundcore snd_page_alloc pl2303

Pid: 0, comm: swapper Not tainted 2.6.30.1-273s #1

Call Trace:

 <IRQ>  [<ffffffff803f6b98>] ? check_unmap+0x518/0x5f0

 [<ffffffff8023ffb8>] warn_slowpath_common+0x78/0xd0

 [<ffffffff80240094>] warn_slowpath_fmt+0x64/0x70

 [<ffffffff805ca430>] ? _spin_lock_irqsave+0x70/0x90

 [<ffffffff803f678c>] ? check_unmap+0x10c/0x5f0

 [<ffffffff803f6b98>] check_unmap+0x518/0x5f0

 [<ffffffff80266675>] ? lock_release_holdtime+0x35/0x1c0

 [<ffffffff803f6e2d>] debug_dma_unmap_sg+0x12d/0x1e0

 [<ffffffff804794c7>] ata_sg_clean+0x77/0xf0

 [<ffffffff80479575>] __ata_qc_complete+0x35/0x110

 [<ffffffff8047970d>] ata_qc_complete+0xbd/0x250

 [<ffffffff80479c47>] ata_qc_complete_multiple+0x97/0xe0

 [<ffffffff8048ee74>] ahci_interrupt+0x94/0x550

 [<ffffffff80266675>] ? lock_release_holdtime+0x35/0x1c0

 [<ffffffff8027a5da>] handle_IRQ_event+0x3a/0xe0

 [<ffffffff8027c291>] handle_edge_irq+0xc1/0x160

 [<ffffffff8020efc6>] handle_irq+0x46/0xa0

 [<ffffffff8020e42a>] do_IRQ+0x6a/0xf0

 [<ffffffff8020c793>] ret_from_intr+0x0/0xf

 <EOI>  [<ffffffff80213e25>] ? mwait_idle+0x75/0x90

 [<ffffffff80213e1c>] ? mwait_idle+0x6c/0x90

 [<ffffffff8020b030>] ? cpu_idle+0xa0/0x140

 [<ffffffff805bc6d5>] ? rest_init+0x65/0x70

 [<ffffffff807bbb9d>] ? start_kernel+0x39a/0x449

 [<ffffffff807bb0a9>] ? x86_64_start_reservations+0x99/0xb9

 [<ffffffff807bb1a9>] ? x86_64_start_kernel+0xe0/0xf2

---[ end trace df6d791d18fe80b5 ]---

Mapped at:

 [<ffffffffffffffff>] 0xffffffffffffffff

(then ~4000s later)
DMA-API: debugging out of memory - disabling

The logic in the ata_sg_setup->dma_map_sg->debug_dma_map_sg and
ata_sg_clean->dma_unmap_sg->debug_dma_unmap_sg->check_unmap call
chains looks good, perhaps pointing to data corruption/race in the DMA
debug API or problem with the AHCI driver?

Daniel
-- 
Daniel J Blueman
