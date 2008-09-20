Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYITIXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYITIXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYITIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:23:13 -0400
Received: from mailfilter12.ihug.co.nz ([203.109.136.12]:20672 "EHLO
	mailfilter12.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYITIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:23:12 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Sep 2008 04:23:11 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMFAPJM1Eh2XKLH/2dsb2JhbACBXbQxgWWBAw
X-IronPort-AV: E=Sophos;i="4.32,436,1217764800"; 
   d="scan'208";a="117341208"
Date: Sat, 20 Sep 2008 20:12:58 +1200
From: Ralph Loader <suckfish@ihug.co.nz>
To: linux-uvc-devel <linux-uvc-devel@lists.berlios.de>
Cc: linux-kernel@vger.kernel.org
Subject: Buffer overflow in uvc-video.
Message-ID: <20080920201258.66c4c657@i.geek.nz>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There appears to be a buffer overflow in
drivers/media/video/uvc/uvc_ctrl.c:

Sep 20 17:53:12 i kernel: BUG kmalloc-8 (Not tainted): Redzone
overwritten Sep 20 17:53:12 i kernel:
--------------------------------------------------------------------
--------- Sep 20 17:53:12 i kernel:
Sep 20 17:53:12 i kernel: INFO: 0xf2c5ce08-0xf2c5ce0b. First byte 0xa1
instead of 0xcc 
Sep 20 17:53:12 i kernel: INFO: Allocated in
uvc_query_v4l2_ctrl+0x3c/0x239 [uvcvideo] age=13 cpu=1 pid=4975
...


A fixed size 8-byte buffer is allocated, and a variable size field is
read into it; there is no particular bound on the size of the field
(it is dependent on hardware and configuration) and it can overflow
[also verified by inserting printk's.]

The patch below attempts to size the buffer to the correctly; I do not
know if sufficient validation of that size is carried out.

Cheers,
Ralph Loader.

diff --git a/drivers/media/video/uvc/uvc_ctrl.c
b/drivers/media/video/uvc/uvc_ct rl.c
index 6ef3e52..feab12a 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -592,7 +592,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device
*video, if (ctrl == NULL)
                return -EINVAL;
 
-       data = kmalloc(8, GFP_KERNEL);
+       data = kmalloc(ctrl->info->size, GFP_KERNEL);
        if (data == NULL)
                return -ENOMEM;
 
