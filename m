Return-Path: <linux-kernel-owner+w=401wt.eu-S1030349AbXBZRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030349AbXBZRWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030356AbXBZRWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:22:39 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48365 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030349AbXBZRWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:22:38 -0500
Date: Mon, 26 Feb 2007 18:21:59 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling
In-Reply-To: <20070226161203.GD2909@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0702261752050.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
 <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
 <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain>
 <20070226152035.GB2909@khazad-dum.debian.net> <20070226161203.GD2909@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Henrique de Moraes Holschuh wrote:

> Improve the backlight code to emulate as much as possible the power
> management events, as we are unable to really power on or power off the
> backlight.

This still easily leads to confusing behavior, doesn't it? As there are 
power-related calls from backlight driver, which won't get handled 
properly by your code, in result confusing the brightness status.

I would suggest applying something like the patch below instead, if you 
find it OK.



From: Jiri Kosina <jkosina@suse.cz>

[PATCH] ibm-acpi: handle power calls from backlight class

Don't ignore the power-related calls from backlight class driver
and always adjust the brightness accordingly.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

 drivers/acpi/ibm_acpi.c             |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
index 7c1b418..4cfa5f8 100644
--- a/drivers/acpi/ibm_acpi.c
+++ b/drivers/acpi/ibm_acpi.c
@@ -87,6 +87,7 @@
 #include <linux/proc_fs.h>
 #include <linux/backlight.h>
 #include <asm/uaccess.h>
+#include <linux/fb.h>
 
 #include <linux/dmi.h>
 #include <linux/jiffies.h>
@@ -1701,7 +1702,12 @@ static int brightness_write(char *buf)
 
 static int brightness_update_status(struct backlight_device *bd)
 {
-	return brightness_set(bd->props.brightness);
+	int brightness = 0;
+
+	if (bd->props.fb_blank == FB_BLANK_UNBLANK || bd->props.power == FB_BLANK_UNBLANK)
+		brightness = bd->props.brightness;
+	return brightness_set(brightness); 
+
 }
 
 static struct backlight_ops ibm_backlight_data = {
