Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYGAIFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYGAIFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYGAIF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:05:27 -0400
Received: from nebensachen.de ([195.34.83.29]:32918 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbYGAIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:05:25 -0400
X-Hashcash: 1:20:080701:edwintorok@gmail.com::J4T+a6d+THezKiBI:000000000000000000000000000000000000000000xSZ
X-Hashcash: 1:20:080701:alan@lxorguk.ukuu.org.uk::lSu1uXE6mFyF2wux:0000000000000000000000000000000000000DhIi
X-Hashcash: 1:20:080701:joe@skyrush.com::Czf+4vbGrGic3727:003UAz
X-Hashcash: 1:20:080701:linux-kernel@vger.kernel.org::0lrdq6lUYIZeWrHk:0000000000000000000000000000000008Ex7
From: Elias Oltmanns <eo@nebensachen.de>
To: =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Peterson <joe@skyrush.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
Date: Tue, 01 Jul 2008 10:02:59 +0200
In-Reply-To: <87fxqurqpz.fsf@denkblock.local> (Elias Oltmanns's message of
	"Tue, 01 Jul 2008 09:47:04 +0200")
Message-ID: <87abh2rpzg.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
[...]
> The following patch to 2.6.26-rc8 fixes the issue for me.

Sorry, resending without MIME encoding the message.

Regards,

Elias


--------
From: Elias Oltmanns <eo@nebensachen.de>
Subject: Make sure that interrupt characters get through reliably

Since commit ec5b1157f8e819c72fc93aa6d2d5117c08cdc961, users have been
unable to interrupt interactive processes reliably by pressing CTRL+C.
This patch reverts the original commit except for the most important
part: actually echoing ^C is preserved.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/char/n_tty.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 8096389..74018ef 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -759,20 +759,9 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			/*
-			 * Echo character, and then send the signal.
-			 * Note that we do not use isig() here because we want
-			 * the order to be:
-			 * 1) flush, 2) echo, 3) signal
-			 */
-			if (!L_NOFLSH(tty)) {
-				n_tty_flush_buffer(tty);
-				tty_driver_flush_buffer(tty);
-			}
 			if (L_ECHO(tty))
 				echo_char(c, tty);
-			if (tty->pgrp)
-				kill_pgrp(tty->pgrp, signal, 1);
+			isig(signal, tty, 0);
 			return;
 		}
 	}
