Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYGAHtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYGAHtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYGAHtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:49:32 -0400
Received: from nebensachen.de ([195.34.83.29]:41082 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYGAHtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:49:31 -0400
X-Hashcash: 1:20:080701:edwintorok@gmail.com::jGPcQT/z6KzGRI07:000000000000000000000000000000000000000004WGE
X-Hashcash: 1:20:080701:alan@lxorguk.ukuu.org.uk::/5z6uDHpNNfSHdoZ:00000000000000000000000000000000000000Yd7
X-Hashcash: 1:20:080701:joe@skyrush.com::ql/4H1Q/v83oA/nI:00AmDh
X-Hashcash: 1:20:080701:linux-kernel@vger.kernel.org::G8t0jxA+uAlbS9Tw:0000000000000000000000000000000002AZS
From: Elias Oltmanns <eo@nebensachen.de>
To: =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Peterson <joe@skyrush.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com>
Date: Tue, 01 Jul 2008 09:47:04 +0200
Message-ID: <87fxqurqpz.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin <edwintorok@gmail.com> wrote:
> Hi,
>
> I have encountered the following situation several times, but I've been
> unable to come up with a way to reproduce this until now:
>  - some process is keeping the disk busy (some cron job for example:
> updatedb, chkrootkit, ...)
>  - other processes that want to do I/O have to wait (this is normal)
>  - I have a (I/O bound) process running in my terminal, and I want to
> interrupt it with Ctrl+C
>  - I type Ctrl+C several times, and the process is not interrupted for
> several seconds (10-30 secs)
>  - if I type Ctrl+Z, and use kill %1 the process dies faster than
> waiting for it to react to Ctrl+C

The following patch to 2.6.26-rc8 fixes the issue for me. Perhaps we
really want to do something else, but since I'm not all that familiar
with the standard behaviour on other Unices and since the comment
describing the changed order of function calls in the original commit
didn't give the reason for that change, I leave that to more
knowledgeable people.

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
