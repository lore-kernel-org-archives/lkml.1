Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYJXB6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYJXB6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYJXB6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:58:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51851 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJXB6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:58:05 -0400
Message-Id: <200810240158.m9O1w2PX032608@www262.sakura.ne.jp>
Subject: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb) to immediately after declaration of nousb.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Oct 2008 10:58:02 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I don't know the reason, but the below patch solves the problem which I'm
experiencing with CONFIG_USB=y on Debian Sarge (gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)).

Something is wrong with sorting symbol table or walking sysfs tree?

Without this patch:

# ls -ail /sys/module/usbcore/parameters/
total 0
200 drwxr-xr-x  2 root root    0 Oct 24 10:13
200 drwxr-xr-x  2 root root    0 Oct 24 10:13 .
199 drwxr-xr-x  4 root root    0 Oct 24 10:13 ..
201 -rw-r--r--  1 root root 4096 Oct 24 10:13 autosuspend
203 -r--r--r--  1 root root 4096 Oct 24 10:13 blinkenlights
204 -rw-r--r--  1 root root 4096 Oct 24 10:13 old_scheme_first
205 -rw-r--r--  1 root root 4096 Oct 24 10:13 use_both_schemes

With this patch:

# ls -ail /sys/module/usbcore/parameters/
total 0
200 drwxr-xr-x  2 root root    0 Oct 24 10:20 .
199 drwxr-xr-x  4 root root    0 Oct 24 10:20 ..
201 -rw-r--r--  1 root root 4096 Oct 24 10:20 autosuspend
202 -r--r--r--  1 root root 4096 Oct 24 10:20 blinkenlights
203 -rw-r--r--  1 root root 4096 Oct 24 10:20 old_scheme_first
205 -rw-r--r--  1 root root 4096 Oct 24 10:20 usbfs_snoop
204 -rw-r--r--  1 root root 4096 Oct 24 10:20 use_both_schemes

Regards.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/usb/core/usb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.27.3.orig/drivers/usb/core/usb.c
+++ linux-2.6.27.3/drivers/usb/core/usb.c
@@ -47,6 +47,8 @@
 const char *usbcore_name = "usbcore";
 
 static int nousb;	/* Disable USB when built into kernel image */
+/* format to disable USB on kernel command line is: nousb */
+__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
 
 /* Workqueue for autosuspend and for remote wakeup of root hubs */
 struct workqueue_struct *ksuspend_usb_wq;
@@ -962,9 +964,6 @@ void usb_buffer_unmap_sg(const struct us
 }
 EXPORT_SYMBOL_GPL(usb_buffer_unmap_sg);
 
-/* format to disable USB on kernel command line is: nousb */
-__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
-
 /*
  * for external read access to <nousb>
  */
