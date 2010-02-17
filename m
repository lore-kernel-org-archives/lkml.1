Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0BQLEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:04:07 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47666 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0BQLEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZV7ybG5fZWuSsolgLGwzfJYLZyQCrXqtA2liASvPdw2OBt5MuaaQGH4ujyapPmTCez
         fnuAebWnPopsMMwMF2Yo4iToOFZqvysoM6rifzAVjiDr2fv07MBrdtvq0kZM4zBqGySv
         IqDnGpKRw9ENGx1xnQKsBTka/ekJJtrInZicY=
Message-ID: <4B7BCD1C.4020102@tuffmail.co.uk>
Date: Wed, 17 Feb 2010 11:03:56 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Input: serio - add thaw
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

633aae2 "Input: i8042 - switch to using dev_pm_ops"
removed handling for PMSG_THAW, causing obscure breakage.

It can break if you press keys during hibernation,
which causes subsequent keypresses to be lost -
so you can't cancel s2disk by pressing backspace -
and then just before system poweroff you get
"psmouse.c: Failed to deactivate mouse".

Apparently freeze/thaw doesn't need the heavyweight
enable/disable cycle.  So we just need to check for
pending events at thaw time, by running the interrupt
handler.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d84a36e..b54aee7 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1161,9 +1161,17 @@ static int i8042_pm_restore(struct device *dev)
 	return 0;
 }
 
+static int i8042_pm_thaw(struct device *dev)
+{
+	i8042_interrupt(0, NULL);
+
+	return 0;
+}
+
 static const struct dev_pm_ops i8042_pm_ops = {
 	.suspend	= i8042_pm_reset,
 	.resume		= i8042_pm_restore,
+	.thaw		= i8042_pm_thaw,
 	.poweroff	= i8042_pm_reset,
 	.restore	= i8042_pm_restore,
 };


