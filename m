Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYGVNCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYGVNCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYGVNCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:02:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33907 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754328AbYGVNCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:02:22 -0400
Date: Tue, 22 Jul 2008 13:44:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Alan Cox <alan@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] istallion: Small follow up for the fixes to istallion
Message-ID: <20080722134414.19a14ca7@lxorguk.ukuu.org.uk>
In-Reply-To: <48845B8B.300@cn.fujitsu.com>
References: <48845504.20102@cn.fujitsu.com>
	<48845B8B.300@cn.fujitsu.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix the compile error which was caused by commit "istallion: use tty_port" and "tty: Ldisc revamp".
> Also make the warning silent.

Sorry about that one.

There is a bit more fixing needed as the ldisc reference isn't held
during close. 

--

istallion: Use helpers

From: Alan Cox <alan@redhat.com>

The ldisc needs to be referenced properly when used. The tty layer has a
helper for this which should have been used but this driver got missed
originally.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/istallion.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 63d22b5..f9ebcd4 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -925,8 +925,7 @@ static void stli_close(struct tty_struct *tty, struct file *filp)
 	clear_bit(ST_TXBUSY, &portp->state);
 	clear_bit(ST_RXSTOP, &portp->state);
 	set_bit(TTY_IO_ERROR, &tty->flags);
-	if (tty->ldisc.ops->flush_buffer)
-		(tty->ldisc.ops->flush_buffer)(tty);
+	tty_ldisc_flush(tty);
 	set_bit(ST_DOFLUSHRX, &portp->state);
 	stli_flushbuffer(tty);
 
