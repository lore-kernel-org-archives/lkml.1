Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYECXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYECXur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYECXuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:50:40 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:24750 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354AbYECXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:50:39 -0400
Date: Sun, 4 May 2008 00:50:28 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080503235027.GO8032@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430194920.GD7501@1wt.eu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Willy Tarreau, le Wed 30 Apr 2008 21:49:20 +0200, a écrit :
> On Wed, Apr 30, 2008 at 01:08:51AM +0100, Samuel Thibault wrote:
> > Willy Tarreau wrote:
> > > 3) if I enter Alt-196, I get a "Ä". Flushing the buffer shows that od
> > > got two bytes: c3 84.
> > 
> > Confirmed.
> > 
> > Try init=/bin/stty -a, that will show
> > 
> > -iutf8
> > 
> > So there is little wonder that canonical mode does not work as expected.
> > 
> > Try init=/bin/sh, from that shell run stty iutf8. Then things will work
> > fine.  The fix is thus just to make the VT's tty initial iutf8 setup
> > follow vt.default_utf8.
> 
> Will try that on a more recent install. Mine's stty does not support
> this option. Your analysis makes quite a lot of sense, and such a fix
> would wipe part of my annoyances/anger with this recent change.

Can you give the patch below a try?
Dynamic per-VT utf-8 switch should also work, provided that you reopen
the VT (i.e. log out).

Samuel



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
