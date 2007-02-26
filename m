Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXBZKCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXBZKCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964932AbXBZKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:02:44 -0500
Received: from tim.rpsys.net ([194.106.48.114]:37725 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbXBZKCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:02:43 -0500
Subject: Re: Nvidiafb broken in 2.6.21-rc1
From: Richard Purdie <rpurdie@rpsys.net>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <jezm737pxc.fsf@sykes.suse.de>
References: <jezm737pxc.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 10:02:01 +0000
Message-Id: <1172484121.5824.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 12:31 +0100, Andreas Schwab wrote:
> With 2.6.21-rc1 I get no video signal from nvidiafb on PowerMac G5.
> Bisection has identified this patch:
> 
> commit 599a52d12629394236d785615808845823875868
> Author: Richard Purdie <rpurdie@rpsys.net>
> Date:   Sat Feb 10 23:07:48 2007 +0000
> 
>     backlight: Separate backlight properties from backlight ops pointers
>     
>     Per device data such as brightness belongs to the indivdual device
>     and should therefore be separate from the the backlight operation
>     function pointers. This patch splits the two types of data and
>     allows simplifcation of some code.
>     
>     Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

Thanks, I think I know what the problem is. Could you try this change
please:

diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index b7016e9..a50b303 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -23,8 +23,6 @@
 #define MAX_LEVEL 0x534
 #define LEVEL_STEP ((MAX_LEVEL - MIN_LEVEL) / FB_BACKLIGHT_MAX)
 
-static struct backlight_properties nvidia_bl_data;
-
 static int nvidia_bl_get_level_brightness(struct nvidia_par *par,
 		int level)
 {
@@ -119,7 +117,7 @@ void nvidia_bl_init(struct nvidia_par *par)
 		0x534 * FB_BACKLIGHT_MAX / MAX_LEVEL);
 
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
-	bd->props.brightness = nvidia_bl_data.max_brightness;
+	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
 


