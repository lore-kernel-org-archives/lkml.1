Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYACWZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYACWZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYACWZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:25:17 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:38022 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYACWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:25:14 -0500
Date: Thu, 3 Jan 2008 23:00:39 +0100
From: Matthias Goebl <matthias@goebl.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de
Subject: [PATCH] isdn/i4l: 'NO CARRIER' message lost after ldisc flush
Message-ID: <20080103220039.GV19071@night.goebl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178571957.3665.8.camel@amdx2.microgate.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISDN tty layer doesn't produce a 'NO CARRIER' message after hangup.

I suppose it broke when tty_buffer_flush() has been added to
tty_ldisc_flush() in the commit below.

For isdn_tty_modem_result(RESULT_NO_CARRIER..) the
message inserted via isdn_tty_at_cout() -> tty_insert_flip_char()
is flushed immediately by tty_ldisc_flush() -> tty_buffer_flush().
More annoyingly, the audio abort sequence DLE-ETX is also lost.

This patch fixes only active audio connections, because I assume that nobody
changes the line discipline for audio.

For non-audio connections the problem remains.
Maybe we can remove the tty_ldisc_flush() in isdn_tty_modem_result()
at all because it's done at tty_close?


On Mon, May 07, 2007 at 04:05:57PM -0500, Paul Fulghum wrote:
> Flush the tty flip buffer when the line discipline
> input queue is flushed, including the user call
> tcflush(TCIFLUSH/TCIOFLUSH). This prevents unexpected
> stale data after a user application calls tcflush().
> 
> Cc: Alan Cox <alan@lxorguk.org.uk>
> Cc: Antonino Ingargiola <tritemio@gmail.com>
> Signed-off-by: Paul Fulghum <paulkf@microgate.com>
> 
> --- a/drivers/char/tty_io.c	2007-05-04 05:46:55.000000000 -0500
> +++ b/drivers/char/tty_io.c	2007-05-05 03:23:46.000000000 -0500
> @@ -1240,6 +1263,7 @@ void tty_ldisc_flush(struct tty_struct *
>  			ld->flush_buffer(tty);
>  		tty_ldisc_deref(ld);
>  	}
> +	tty_buffer_flush(tty);
[..]


Signed-off-by: Matthias Goebl <matthias.goebl@goebl.net>

--- linux-2.6.23.12.orig/drivers/isdn/i4l/isdn_tty.c	
+++ linux-2.6.23.12/drivers/isdn/i4l/isdn_tty.c	
@@ -2645,7 +2649,12 @@
 		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
 			return;
 		}
+#ifdef CONFIG_ISDN_AUDIO
+		if ( !info->vonline )
+			tty_ldisc_flush(info->tty);
+#else
 		tty_ldisc_flush(info->tty);
+#endif
 		if ((info->flags & ISDN_ASYNC_CHECK_CD) &&
 		    (!((info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
 		       (info->flags & ISDN_ASYNC_CALLOUT_NOHUP)))) {
