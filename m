Return-Path: <linux-kernel-owner+w=401wt.eu-S965365AbXAYPQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365AbXAYPQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXAYPQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:16:40 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58613 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965365AbXAYPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:16:40 -0500
Date: Thu, 25 Jan 2007 10:16:39 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070125151639.GH7582@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B7CDB5.7020909@microgate.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 03:20:53PM -0600, Paul Fulghum wrote:
> In 2.6.16 the tty buffering pushes data to the line
> discipline without regard to tty->receive_room.
> If the line discipline can't keep up, the data gets dropped.
> I observed this data loss at higher speeds when
> placing the system under heavy load.
> 
> 2.6.18 added code to respect tty->receive_room.
> 
> This may or may not be your problem, but you should
> be able to check by adding a conditional printk
> to drivers/char/tty_io.c:flush_to_ldisc()
> 
> If tty->receive_room is less than the size of the buffer
> passed to disc->receive_buf() then you are losing data.

I am now trying this, which so far seem to help (I had a printk in there
earlier and managed to trigger that).

--- ori/drivers/char/tty_io.c	2007-01-24 18:02:48.000000000 -0500
+++ new/drivers/char/tty_io.c	2007-01-25 09:50:02.000000000 -0500
@@ -2774,6 +2778,14 @@
 	spin_lock_irqsave(&tty->buf.lock, flags);
 	while((tbuf = tty->buf.head) != NULL) {
 		while ((count = tbuf->commit - tbuf->read) != 0) {
+			if (!tty->receive_room) {
+				schedule_delayed_work(&tty->buf.work, 1);
+				spin_unlock_irqrestore(&tty->buf.lock, flags);
+				goto out;
+			}
+			if (count > tty->receive_room) {
+				count = tty->receive_room;
+			}
 			char_buf = tbuf->char_buf_ptr + tbuf->read;
 			flag_buf = tbuf->flag_buf_ptr + tbuf->read;
 			tbuf->read += count;

This appeared to be (essentially) the key change in 2.6.18 related to
the check of tty->receive_room.

I will now run a bunch more tests to see if it manages to keep it from
having any more character losses.

Thank you for the suggestion of where to look.

--
Len Sorensen
