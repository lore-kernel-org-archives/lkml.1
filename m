Return-Path: <linux-kernel-owner+w=401wt.eu-S1751383AbZLUHJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbZLUHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZLUHJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:09:57 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:45485 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZLUHJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Te8H39t+pYvurHyR4KMkUl7TVu7yBr8aYdujChSPRKIkqwJ7wesINzySeO3pcPs8it
         8R/Wxp9q27GBHZsKwGfnu4a+gpqNOH0LIFAKdU+akzE5dUpstuhTlW1sjRuw+/QaTpNL
         lzxicXAgnTpH/ifLnYj3RQq2E3Cd4j0Z7Sefg=
Date: Sun, 20 Dec 2009 23:09:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFT] Input: speed up suspend/shutdown for PS/2 mice and keyboards
Message-ID: <20091221070951.GA4170@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am asking everyone to give this patch a try. It is reported to speed
up suspend process, however there is a risk that there are boxes out
there that do require full reset and I would prefer to know that sooner
than later.

Thanks!

-- 
Dmitry


Input: speed up suspend/shutdown for PS/2 mice and keyboards

Instead of doing full-blown reset while suspending or shutting down
the box use lighter form of reset that should take less time.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/atkbd.c     |    5 +++--
 drivers/input/mouse/psmouse-base.c |    5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)


diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index a357357..1f5e2ce 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -134,7 +134,8 @@ static const unsigned short atkbd_unxlate_table[128] = {
 #define ATKBD_CMD_GETID		0x02f2
 #define ATKBD_CMD_SETREP	0x10f3
 #define ATKBD_CMD_ENABLE	0x00f4
-#define ATKBD_CMD_RESET_DIS	0x00f5
+#define ATKBD_CMD_RESET_DIS	0x00f5	/* Reset to defaults and disable */
+#define ATKBD_CMD_RESET_DEF	0x00f6	/* Reset to defaults */
 #define ATKBD_CMD_SETALL_MBR	0x00fa
 #define ATKBD_CMD_RESET_BAT	0x02ff
 #define ATKBD_CMD_RESEND	0x00fe
@@ -836,7 +837,7 @@ static void atkbd_cleanup(struct serio *serio)
 	struct atkbd *atkbd = serio_get_drvdata(serio);
 
 	atkbd_disable(atkbd);
-	ps2_command(&atkbd->ps2dev, NULL, ATKBD_CMD_RESET_BAT);
+	ps2_command(&atkbd->ps2dev, NULL, ATKBD_CMD_RESET_DEF);
 }
 
 
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index fd0bc09..401ac6b 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1137,7 +1137,10 @@ static void psmouse_cleanup(struct serio *serio)
 	if (psmouse->cleanup)
 		psmouse->cleanup(psmouse);
 
-	psmouse_reset(psmouse);
+/*
+ * Reset the mouse to defaults (bare PS/2 protocol).
+ */
+	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
 
 /*
  * Some boxes, such as HP nx7400, get terribly confused if mouse
