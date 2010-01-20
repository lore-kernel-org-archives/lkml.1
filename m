Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245Ab0ATXuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0ATXuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200Ab0ATXuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:51 -0500
Received: from kroah.org ([198.145.64.141]:33635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0ATXus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Arnd Bergmann <arnd@arndb.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/8] compat_ioctl: Supress "unknown cmd" message on serial /dev/console
Date: Wed, 20 Jan 2010 15:49:56 -0800
Message-Id: <1264031403-32239-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

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
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.7

