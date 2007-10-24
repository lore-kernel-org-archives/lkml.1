Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXJXTog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXJXTog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbXJXTo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:44:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbXJXTo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:44:27 -0400
Date: Wed, 24 Oct 2007 21:44:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] portman2x4.c: fix boot hang
Message-ID: <20071024194417.GA17025@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
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

Subject: portman2x4.c: fix boot hang
From: Ingo Molnar <mingo@elte.hu>

when booting an allyesconfig bzImage kernel the bootup hangs in the 
portman2x4 driver (on a box that does not have this hardware), at:

 Pid: 1, comm:              swapper
 EIP: 0060:[<c02f763c>] CPU: 0
 EIP is at parport_pc_read_status+0x4/0x8
  EFLAGS: 00000202    Not tainted  (2.6.23-rc9 #904)
 EAX: f7e57a7f EBX: 00000010 ECX: c2b808c0 EDX: 00000379
 ESI: f7cb8230 EDI: 00000010 EBP: f7cb8230 DS: 007b ES: 007b FS: 0000
 CR0: 8005003b CR2: fff9c000 CR3: 007ec000 CR4: 00000690
 DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
 DR6: ffff0ff0 DR7: 00000400
  [<c04613de>] portman_flush_input+0xde/0x12c
  [<c0461a24>] snd_portman_probe+0x368/0x484
  [<c02fbb8c>] __device_attach+0x0/0x8
  [<c02fce68>] platform_drv_probe+0xc/0x10
  [<c02fba6c>] driver_probe_device+0x74/0x194
  [<c0587174>] klist_next+0x38/0x70
  [<c02fbb8c>] __device_attach+0x0/0x8
  [<c02faea1>] bus_for_each_drv+0x35/0x68
  [<c02fbc22>] device_attach+0x72/0x78

the reason is due to an inconsistent error return code of 1 or 2, while 
snd_portman_probe only realizes negative error codes.

with this fixed the probe fails as it should and the bootup continues.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/drivers/portman2x4.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/sound/drivers/portman2x4.c
===================================================================
--- linux.orig/sound/drivers/portman2x4.c
+++ linux/sound/drivers/portman2x4.c
@@ -467,7 +467,7 @@ static int portman_probe(struct parport 
 	/* Check for ESTB to be clear */
 	/* 4 */
 	if ((parport_read_status(p) & ESTB) == ESTB)
-		return 1;	/* CODE 1 - Strobe Failure. */
+		return -EIO;	/* CODE 1 - Strobe Failure. */
 
 	/* Set for RXDATA0 where no damage will be done. */
 	/* 5 */
@@ -475,7 +475,7 @@ static int portman_probe(struct parport 
 
 	/* 6 */
 	if ((parport_read_status(p) & ESTB) != ESTB)
-		return 1;	/* CODE 1 - Strobe Failure. */
+		return -EIO;	/* CODE 1 - Strobe Failure. */
 
 	/* 7 */
 	parport_write_control(p, 0);	/* Reset Strobe=0. */
@@ -491,7 +491,7 @@ static int portman_probe(struct parport 
 	 */
 	/* 9 */
 	if ((parport_read_status(p) & TXEMPTY) == 0)
-		return 2;
+		return -EIO;
 
 	/* Return OK status. */
 	return 0;

