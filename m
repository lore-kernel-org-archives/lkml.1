Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550Ab0AJO3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0AJO3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389Ab0AJO3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:29:23 -0500
Received: from mv-drv-hcb004.ocn.ad.jp ([118.23.109.134]:46675 "EHLO
	mv-drv-hcb004.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0AJO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:29:23 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] compat_ioctl: Supress "unknown cmd" message on serial /dev/console
Date: Sun, 10 Jan 2010 23:29:16 +0900
Message-Id: <1263133756-27804-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
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

And by quick search, I found some programs using VT_GETMODE to check
vt-console is available or not.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 fs/compat_ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 332dd00..c5c45de 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1005,6 +1005,9 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
 COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
 #endif
+/* Big V (don't complain on serial console) */
+IGNORE_IOCTL(VT_OPENQRY)
+IGNORE_IOCTL(VT_GETMODE)
 /* Little p (/dev/rtc, /dev/envctrl, etc.) */
 COMPATIBLE_IOCTL(RTC_AIE_ON)
 COMPATIBLE_IOCTL(RTC_AIE_OFF)
-- 
1.5.6.5

