Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbXHEQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbXHEQQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXHEQQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:16:17 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:57113 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbXHEQQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:16:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=LdQ66LdyFO27rX5GQXEJiFOOInFHclKxs8YFOnFnDFHLHzYH4aEAI+OVCUiKyQy0zgvBPwmTov23ohRmOEeCyYqJqMejcj2mV+9cM3Ai6P1VERo/JtYsPKGMfHgMpcVg;
Message-ID: <46B5F7C9.6000006@simon.arlott.org.uk>
Date: Sun, 05 Aug 2007 17:16:09 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux DVB <linux-dvb@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] DVB: remove bogus BUG_ON in videobuf_dvb_thread
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since videobuf_waiton is called with intr=1, it can return -EINTR and therefore 
err may be non-zero. This happens when the system goes into the standby state.

Without the BUG() occurring, there's no problem with standby mode while DVB 
is being used.

---
int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr);

[  224.561803] Stopping tasks ... <0>------------[ cut here ]------------
[  224.712939] kernel BUG at drivers/media/video/video-buf-dvb.c:59!
[  224.712951] invalid opcode: 0000 [#1]
[  224.712957] PREEMPT
[  224.712969] Modules linked in:
[  224.712985] CPU:    0
[  224.712987] EIP:    0060:[<b03a0740>]    Not tainted VLI
[  224.712989] EFLAGS: 00010286   (2.6.23-rc2-git #282)
[  224.713019] EIP is at videobuf_dvb_thread+0x160/0x170
[  224.713028] eax: fffffffc   ebx: 00000282   ecx: 00000000   edx: 00000000
[  224.713038] esi: eeda63c0   edi: b1a1fa3c   ebp: ea82bfcc   esp: ea82bfb0
[  224.713046] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[  224.713055] Process saa7134[0] dvb (pid: 6649, ti=ea82a000 task=eb1d5550 task.ti=ea82a000)
[  224.713064] Stack: 00000009 b011ec68 b1a1fa44 b1a1fb28 b1a1fa3c b03a05e0 fffffffc ea82bfe0
[  224.713103]        b0135dec b0135d90 00000000 00000000 00000000 b0104e57 ea82fd70 00000000
[  224.713140]        00000000 00000000 09010df7 862a0510
[  224.713170] Call Trace:
[  224.713178]  [<b0104fca>] show_trace_log_lvl+0x1a/0x30
[  224.713206]  [<b010508b>] show_stack_log_lvl+0x8b/0xb0
[  224.713220]  [<b01052d3>] show_registers+0x1c3/0x320
[  224.713235]  [<b01055af>] die+0xff/0x210
[  224.713248]  [<b0105751>] do_trap+0x91/0xd0
[  224.713261]  [<b01059f8>] do_invalid_op+0x88/0xa0
[  224.713274]  [<b052206a>] error_code+0x6a/0x70
[  224.713296]  [<b0135dec>] kthread+0x5c/0x90
[  224.713313]  [<b0104e57>] kernel_thread_helper+0x7/0x10
[  224.713327]  =======================
[  224.713335] Code: 8b 00 c7 04 24 c8 21 63 b0 89 44 24 04 e8 c9 29 d8 ff e9 cd fe ff ff 8b
	07 c7 04 24 e8 21 63 b0 89 44 24 04 e8 b2 29 d8 ff eb c2 <0f> 0b eb fe 8d b6 00 00
	00 00 8d bf 00 00 00 00 55 ba ea ff ff
[  224.713590] EIP: [<b03a0740>] videobuf_dvb_thread+0x160/0x170 SS:ESP 0068:ea82bfb0
[  224.713893] done.

 drivers/media/video/video-buf-dvb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/video-buf-dvb.c b/drivers/media/video/video-buf-dvb.c
index e617925..d2af82d 100644
--- a/drivers/media/video/video-buf-dvb.c
+++ b/drivers/media/video/video-buf-dvb.c
@@ -56,7 +56,6 @@ static int videobuf_dvb_thread(void *data)
 				 struct videobuf_buffer, stream);
 		list_del(&buf->stream);
 		err = videobuf_waiton(buf,0,1);
-		BUG_ON(0 != err);
 
 		/* no more feeds left or stop_feed() asked us to quit */
 		if (0 == dvb->nfeeds)
-- 
1.5.0.1

-- 
Simon Arlott
