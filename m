Return-Path: <linux-kernel-owner+w=401wt.eu-S2993057AbXCIH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993057AbXCIH1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993059AbXCIH1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:27:30 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:38415 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993057AbXCIH11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ttmL7ZfE9sUyo/+4F/ylPFSGHY6bys3cto3escC1pb9Q5tyJGIzH6hKiE+SYtE7OypFvPIEljWdFIQUT57M0YFbZPsIhD1sxHDIvLo10K3vX8HYxYOEh1uxxK74/tIErXktdystboqYAmGtMJsq9znoZrdpMd93fhRJRnjo0AP8=
Date: Thu, 8 Mar 2007 23:27:13 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char/vt.c: check kmalloc() return value.
Message-Id: <20070308232713.ef9c608e.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function con_init(), in file drivers/char/vt.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 87587b4..6aa08cb 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2640,6 +2640,15 @@ static int __init con_init(void)
 	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		if (!vc_cons[currcons].d) {
+			for (--currcons; currcons >= 0; currcons--) {
+				kfree(vc_cons[currcons].d);
+				vc_cons[currcons].d = NULL;
+			}
+			release_console_sem();
+			return -ENOMEM;
+		}
+
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
 		vc->vc_kmalloced = 0;
