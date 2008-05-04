Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYEDK3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYEDK3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYEDK3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:29:42 -0400
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:25373 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYEDK3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:29:41 -0400
Date: Sun, 4 May 2008 11:25:54 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stable@kernel.org
Subject: Fix VT canonical input in UTF-8 mode [Was: UTF-8 fixes in comments]
Message-ID: <20080504102554.GA4729@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, stable@kernel.org
References: <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation> <20080504085514.GA27263@1wt.eu> <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080504085514.GA27263@1wt.eu> <20080503235027.GO8032@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Sun 04 May 2008 00:50:27 +0100, a écrit :
> Willy Tarreau, le Wed 30 Apr 2008 21:49:20 +0200, a écrit :
> > On Wed, Apr 30, 2008 at 01:08:51AM +0100, Samuel Thibault wrote:
> > > Willy Tarreau wrote:
> > > > 3) if I enter Alt-196, I get a "Ä". Flushing the buffer shows that od
> > > > got two bytes: c3 84.
> > > 
> > > Confirmed.
> > > 
> > > Try init=/bin/stty -a, that will show
> > > 
> > > -iutf8
> > > 
> > > So there is little wonder that canonical mode does not work as expected.
> > > 
> > > Try init=/bin/sh, from that shell run stty iutf8. Then things will work
> > > fine.  The fix is thus just to make the VT's tty initial iutf8 setup
> > > follow vt.default_utf8.
> > 
> > Will try that on a more recent install. Mine's stty does not support
> > this option. Your analysis makes quite a lot of sense, and such a fix
> > would wipe part of my annoyances/anger with this recent change.
> 
> Can you give the patch below a try?
> Dynamic per-VT utf-8 switch should also work, provided that you reopen
> the VT (i.e. log out).

Willy Tarreau, le Sun 04 May 2008 10:55:14 +0200, a écrit :
> I confirm that your patch works perfectly for me. Now backspace correctly
> removes multi-byte characters. My bash is still fooled though but as Alan
> explained it, it's readline which has to be upgraded now.

I guess this is suitable for the stable trees of 2.6.24 and 2.6.25
(where UTF-8 is by default now).




Set IUTF8 as appropriate on VT tty open.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/drivers/char/vt.c.orig	2008-05-04 00:37:50.000000000 +0100
+++ linux/drivers/char/vt.c	2008-05-04 00:47:39.000000000 +0100
@@ -2723,6 +2723,10 @@ static int con_open(struct tty_struct *t
 				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
 				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
 			}
+			if (vc->vc_utf)
+				tty->termios->c_iflag |= IUTF8;
+			else
+				tty->termios->c_iflag &= ~IUTF8;
 			release_console_sem();
 			vcs_make_sysfs(tty);
 			return ret;
@@ -2899,6 +2903,8 @@ int __init vty_init(void)
 	console_driver->minor_start = 1;
 	console_driver->type = TTY_DRIVER_TYPE_CONSOLE;
 	console_driver->init_termios = tty_std_termios;
+	if (default_utf8)
+		console_driver->init_termios.c_iflag |= IUTF8;
 	console_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_RESET_TERMIOS;
 	tty_set_operations(console_driver, &con_ops);
 	if (tty_register_driver(console_driver))

