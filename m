Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbZE2SfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbZE2SfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZE2Seh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:34:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:64750 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759442AbZE2Seg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:34:36 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/2] usb_serial: only allow sysrq on a console port
Date: Fri, 29 May 2009 13:34:17 -0500
Message-Id: <1243622057-17671-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1243622057-17671-2-git-send-email-jason.wessel@windriver.com>
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com>
 <1243622057-17671-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 May 2009 18:36:25.0562 (UTC) FILETIME=[5F4BDBA0:01C9E08C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only time a sysrq should get processed is if the attached device
is a console.  This is intended to protect sysrq execution on a host
connected with a terminal program.

Here is the problem scenario:

host A <-- rs232 link --> host B

Host A is using mincom and a usb pl2303 device to connect to host b
which is a linux system with a usb pl2303 device acting as the serial
console.  When host B is rebooted the pl2303 emits random junk
characters on reset.  These character sequences contain serial break
signals most of the time and when translated to a sysrq have caused
host A to get random processes killed, reboots or power down.

It is true that in this setup with this patch host B might still have
the same problem as host A if you reboot host A.  In most cases host A
is a development host which seldom gets rebooted, and you could turn
off sysrq temporarily on host B if you need to reboot host A.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index df56ed3..4797402 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -529,7 +529,7 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 
 int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
 {
-	if (port->sysrq) {
+	if (port->sysrq && port->console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
 			handle_sysrq(ch, tty_port_tty_get(&port->port));
 			port->sysrq = 0;
-- 
1.6.3.1.9.g95405b

