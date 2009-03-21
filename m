Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZCUWSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZCUWSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZCUWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:18:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZCUWSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:18:31 -0400
Message-ID: <49C56754.4080909@redhat.com>
Date: Sat, 21 Mar 2009 18:16:52 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ying.huang@intel.com
Subject: [PATCH] efifb: dmi set video type
Content-Type: multipart/mixed;
 boundary="------------010306000109040600090909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010306000109040600090909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The current logic for dmi matching in efifb does not allow efifb to load 
on all hardware that we can dmi match for.

For a real world example, boot with elilo (3.7 or 3.8 vanilla) and on a 
Apple (MacBook) and EFI framebuffer driver will not load (you will have 
no video).
This specific hardware is efi v1.10, so we have UGA and not GOP. Without 
special bootloader magic (i.e. extra elilo patches for UGA graphics 
detection) no screen info will be passed to the kernel and as a result 
efifb will not load.

This patch allows the dmi match to happen by moving it to earlier in 
efifb_init, and sets the video type (in set_system) so that efifb can 
load when we have a valid dmi match and already know the specifics of 
the hardware.

Without this patch the efifb driver will fail to load in the event 
screen info is not found and passed in by the bootloader, being that we 
will never get to look for a dmi match. A primary reason for matching 
with dmi is because not all bootloaders detect the video info properly. 
The solution is that in the event of a dmi match, we should set 
screen_info.orig_video_isVGA. Most bootloaders fail to set screen info 
on Apple hardware, and this is a big problem for people who use Apple 
hardware.

Tested on a MacBook SantaRosa with elilo-3.8 (vanilla) and resolves the 
issue, the dmi match now works, EFI framebuffer now loads and video works.


Signed-off-by: Brian Maly <bmaly@redhat>



--------------010306000109040600090909
Content-Type: text/x-patch;
 name="linux-2.6.29-efifb-dmi-set-video_isVGA.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.29-efifb-dmi-set-video_isVGA.patch"

--- a/drivers/video/efifb.c	2009-03-21 21:05:08.000000000 -0400
+++ b/drivers/video/efifb.c	2009-03-21 21:16:20.000000000 -0400
@@ -129,6 +129,8 @@ static int set_system(const struct dmi_s
 		screen_info.lfb_width = info->width;
 	if (screen_info.lfb_height == 0)
 		screen_info.lfb_height = info->height;
+	if (screen_info.orig_video_isVGA == 0)
+		screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
 
 	return 0;
 }
@@ -374,9 +376,10 @@ static int __init efifb_init(void)
 	int ret;
 	char *option = NULL;
 
+	dmi_check_system(dmi_system_table);
+
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
-	dmi_check_system(dmi_system_table);
 
 	if (fb_get_options("efifb", &option))
 		return -ENODEV;

--------------010306000109040600090909--
