Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYCLRk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYCLRk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCLRkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:40:14 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38696
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbYCLRkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:40:13 -0400
Subject: Re: + n_tty-loss-of-sync-following-a-buffer-overflow.patch added
	to -mm tree
From: Paul Fulghum <paulkf@microgate.com>
To: rupesh.sugathan@gmail.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1205339539.8873.14.camel@estonia>
References: <200803120455.m2C4t4Aw010881@imap1.linux-foundation.org>
	 <20080312102729.58956d2c@the-village.bc.nu>
	 <47D7F531.2070400@microgate.com>  <1205339539.8873.14.camel@estonia>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 12:39:50 -0500
Message-Id: <1205343590.4094.17.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 09:32 -0700, Rupesh Sugathan wrote:
> The max line size from sender is 100 bytes. The read call waits for a
> maximum of 200 bytes.

OK, I understand what is happening.

Multiple lines are received while the N_TTY buffer is
full which increments canon_data multiple time without
setting multiple bits in read_flags. Essentially the
same bit in read_flags is set over and over.

When read_chan starts returning data, canon_data is
decremented once for each bit in read_flags which
leaves canon_data > 0 when there is no data to be read.

Even for the case of a single NL when N_TTY buffer is
full, the read_flag bit is set for tty->read_head when
that slot already contains data (same as tty->read_tail).

So the current code is wrong for the buffer full case.

What I suggest is the following patch for processing NL
in canonical mode.

If buffer full and previous character is not NL then
overwrite that char with NL truncating that line so
it is not prepended to subsequent data or left waiting
without a final NL.

If buffer full and previous character is NL (read_flag set)
then do nothing so canon_data remains in sync with read_flags.

Rupesh, can you try this out please?
Also, none of this answers why your N_TTY buffer is overflowing
it simply keeps things sane when it happens.

--- a/drivers/char/n_tty.c	2008-01-24 16:58:37.000000000 -0600
+++ b/drivers/char/n_tty.c	2008-03-12 12:16:06.000000000 -0500
@@ -839,10 +839,24 @@ send_signal:
 
 		handle_newline:
 			spin_lock_irqsave(&tty->read_lock, flags);
-			set_bit(tty->read_head, tty->read_flags);
-			put_tty_queue_nolock(c, tty);
-			tty->canon_head = tty->read_head;
-			tty->canon_data++;
+			if (tty->read_cnt == N_TTY_BUF_SIZE) {
+				int prev_head;
+				if (tty->read_head)
+					prev_head = tty->read_head - 1;
+				else
+					prev_head = N_TTY_BUF_SIZE - 1;
+				if (!test_bit(prev_head, tty->read_flags)) {
+					/* overwrite previous non NL char */
+					tty->read_cnt--;
+					tty->read_head = prev_head;
+				}
+			}
+			if (tty->read_cnt < N_TTY_BUF_SIZE) {
+				set_bit(tty->read_head, tty->read_flags);
+				put_tty_queue_nolock(c, tty);
+				tty->canon_head = tty->read_head;
+				tty->canon_data++;
+			}
 			spin_unlock_irqrestore(&tty->read_lock, flags);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 			if (waitqueue_active(&tty->read_wait))


