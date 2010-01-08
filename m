Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673Ab0AHPGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0AHPGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652Ab0AHPGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:06:49 -0500
Received: from defer-dn04.ocn.ad.jp ([125.170.100.158]:34415 "EHLO
	defer-dn04.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0AHPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:06:48 -0500
Date: Sat, 09 Jan 2010 00:05:10 +0900 (JST)
Message-Id: <20100109.000510.193873785.anemo@mba.ocn.ne.jp>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: compat_ioctl: unknown cmd on serial /dev/console
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the commit fb07a5f8 ("compat_ioctl: remove all VT ioctl
handling"), I got this error message on 64-bit mips kernel with 32-bit
busybox userland:

ioctl32(init:1): Unknown cmd fd(0) cmd(00005600){t:'V';sz:0} arg(7fd76480) on /dev/console

The cmd 5600 is VT_OPENQRY.  The busybox's init issues this ioctl to
know vt-console or serial-console.  If the console was serial console,
VT ioctls are not handled by the serial driver.

How this error should be fixed?  Is this patch OK?

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 332dd00..731478f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1005,6 +1005,8 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
 COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
 #endif
+/* Big V (for serial console case) */
+COMPATIBLE_IOCTL(VT_OPENQRY)
 /* Little p (/dev/rtc, /dev/envctrl, etc.) */
 COMPATIBLE_IOCTL(RTC_AIE_ON)
 COMPATIBLE_IOCTL(RTC_AIE_OFF)

And by quick search, I found some programs using VT_GETMODE to check
vt-console is available or not.  So VT_GETMODE might be an another
candidate, but not sure.

---
Atsushi Nemoto
