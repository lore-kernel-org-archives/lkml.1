Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXDBONu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXDBONu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbXDBONu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:13:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:57512 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXDBONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=pPqU17PFAb2cvHsdbFk78WAJVtlj9seaP9M7e9Jfj74zwrSeumnUsIhljFHEnJo1URny2j7KhTiaPSHCDYQR68mWxSwoVB5vy8Bf7qZl8w3kysM0EBw8sKLe/qd2hzwNFhELBI/vxKK2eWvV92skOWB3xaFrOGLXAVk3ZP4APNc=
Message-ID: <46110F88.5040905@gmail.com>
Date: Mon, 02 Apr 2007 22:13:28 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Subject: [PATCH] vt: Do not clear UTF when resetting console
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resetting the console, either by ANSI escape sequences or by the reset utility,
will drop the console back to legacy (non-UTF-8) mode. Fix this by leaving the
field vc_data.vc_utf untouched in reset_terminal(). In addition, a global
variable (default_utf8) which defines system-wide UTF-8 setting is created.
This variable can be adjusted via sysfs.

This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---

 drivers/char/vt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1bbb45b..fdd548f 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -157,6 +157,8 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
+static int default_utf8;
+module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -1497,7 +1499,6 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
@@ -2590,6 +2591,7 @@ static void vc_init(struct vc_data *vc, 
 	vc->vc_rows = rows;
 	vc->vc_size_row = cols << 1;
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
+	vc->vc_utf = default_utf8;
 
 	set_origin(vc);
 	vc->vc_pos = vc->vc_origin;
