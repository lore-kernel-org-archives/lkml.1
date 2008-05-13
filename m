Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbYEMUMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbYEMUMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbYEMUMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:12:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:37395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761244AbYEMUMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:12:23 -0400
Date: Tue, 13 May 2008 13:11:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Willy Tarreau <w@1wt.eu>
Subject: [patch 02/37] vt: fix canonical input in UTF-8 mode
Message-ID: <20080513201125.GC31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vt-fix-canonical-input-in-utf-8-mode.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit c1236d31a1b9fc018b85e15a3e58e3601ddc90ae upstream

For e.g.  proper TTY canonical support, IUTF8 termios flag has to be set as
appropriate.  Linux used to not care about setting that flag for VT TTYs.

This patch fixes that by activating it according to the current mode of the
VT, and sets the default value according to the vt.default_utf8 parameter.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/vt.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
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

-- 
