Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZAYJz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZAYJz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 04:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZAYJzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 04:55:12 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:43495 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZAYJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 04:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G5rXX9lX0iDqyG1E6vfO+0byuUTedzZ1NBoIS9E3KY5FADBpnP+12GwNs3MU6UrUy7
         6ysKbgzTm4D92nRhEZ/DZ392u9Jb1KZ3roaaavJokP5r/8eORqNSnM0K8TSu3iFWAouJ
         P1oBjupA5L2dZi80wWpL8aaDwBhO0BcNn6R04=
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: jayakumar.lkml@gmail.com
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [RFC 2.6.28 3/3] mach-pxa: use batch set/get in am300epd
Date: Sun, 25 Jan 2009 17:54:49 +0800
Message-Id: <1232877301524-git-send-email-jayakumar.lkml@gmail.com>
X-Mailer: git-send-email 1.5.2.3
In-Reply-To: <123287728936-git-send-email-jayakumar.lkml@gmail.com>
References: <123287728936-git-send-email-jayakumar.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to am300epd uses the batch gpiolib set/get API in order
to significantly improve performance when transferring framebuffer
data.

Cc: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: linux-embedded@vger.kernel.org
Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
---
 arch/arm/mach-pxa/am300epd.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 4bd10a1..237e3be 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -187,24 +187,25 @@ static void am300_cleanup(struct broadsheetfb_par *par)
 
 static u16 am300_get_hdb(struct broadsheetfb_par *par)
 {
-	u16 res = 0;
-	int i;
-
-	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
-		res |= (gpio_get_value(DB0_GPIO_PIN + i)) ? (1 << i) : 0;
+	int err;
+	u32 val;
 
-	return res;
+	err = gpio_get_batch(DB0_GPIO_PIN, 0xFFFF, &val);
+	if (err) {
+		dev_err(&am300_device->dev, "get failed: %d\n", err);
+		return 0;
+	}
+	return (u16) val;
 }
 
 static void am300_set_hdb(struct broadsheetfb_par *par, u16 data)
 {
-	int i;
-
-	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
-		gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
+	int err;
+	err = gpio_set_batch(DB0_GPIO_PIN, 0xFFFF, data);
+	if (err)
+		dev_err(&am300_device->dev, "set failed: %d\n", err);
 }
 
-
 static void am300_set_ctl(struct broadsheetfb_par *par, unsigned char bit,
 				u8 state)
 {
-- 
1.5.2.3

