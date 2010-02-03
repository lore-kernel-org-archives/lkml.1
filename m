Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab0BCTAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:00:09 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39723 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0BCTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:00:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=wDz94Pe6PggApeNYtJaCJpLsrTdmQI74c24N50kWpnUAP/9a4rV6yvz4R3XXnDRpQi
         KZU9Z4hOeYzOQNX6/EuIEovztpApFS4WXGPlvqulj9iGgBrzQ65t6Ds6V7xarnXHHccu
         nuCVHyd+wQXGTDj9HbvWhQf4u6WGTuD1G9bxc=
Message-ID: <4B69C7AA.7000904@tuffmail.co.uk>
Date: Wed, 03 Feb 2010 18:59:54 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Input: serio - re-add thaw (and add freeze)
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

So let's add the thaw handler back.

Also set the freeze handler.  It looks like PMSG_FREEZE
didn't do anything in the past, but I think that must
have been an oversight.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/input/serio/i8042.c |    2 ++
 drivers/input/serio/serio.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d84a36e..9599766 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1164,6 +1164,8 @@ static int i8042_pm_restore(struct device *dev)
 static const struct dev_pm_ops i8042_pm_ops = {
 	.suspend	= i8042_pm_reset,
 	.resume		= i8042_pm_restore,
+	.freeze		= i8042_pm_reset,
+	.thaw		= i8042_pm_restore,
 	.poweroff	= i8042_pm_reset,
 	.restore	= i8042_pm_restore,
 };
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index e0f3018..2e8f544 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -949,6 +949,8 @@ static int serio_resume(struct device *dev)
 static const struct dev_pm_ops serio_pm_ops = {
 	.suspend	= serio_suspend,
 	.resume		= serio_resume,
+	.freeze		= serio_suspend,
+	.thaw		= serio_resume,
 	.poweroff	= serio_suspend,
 	.restore	= serio_resume,
 };
-- 
1.6.3.3



