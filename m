Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXF0C6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXF0C6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXF0C55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:57:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:19702 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbXF0C54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=DTPAr7e6IgiEMoqpqCgToJ3kRiiyhVS+q8+3DbrG8qV36q6Cys3J481jJx0Q9VxIpev6Et5JPfVvuad0ZiipewNCs7nRGW1vVgaSvButXM/USkdI5Rn+Rh2uf9soYROnncYLrj4pCymxaizK3atUKDfKAxDbYYZanrYvb942L7s=
Date: Wed, 27 Jun 2007 10:59:07 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] atkbd: cleanup only once
Message-ID: <20070627105907.GA1802@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If you press ctrl+alt+del several times as kernel booting (before user level bootin), the kernel will oops. I found the ps2_command is called more than once, then the ps2dev->serio maybe NULL pointer.

2.6.22-rc5 and 2.6.22-rc6 have same result.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
diff -upr linux/drivers/input/keyboard/atkbd.c linux.new/drivers/input/keyboard/atkbd.c
--- linux/drivers/input/keyboard/atkbd.c	2007-06-27 10:38:37.000000000 +0000
+++ linux.new/drivers/input/keyboard/atkbd.c	2007-06-27 10:37:39.000000000 +0000
@@ -795,6 +795,11 @@ static int atkbd_activate(struct atkbd *
 
 static void atkbd_cleanup(struct serio *serio)
 {
+	static int flag;
+
+	if(flag)
+		return;
+	flag = 1;
 	struct atkbd *atkbd = serio_get_drvdata(serio);
 	ps2_command(&atkbd->ps2dev, NULL, ATKBD_CMD_RESET_BAT);
 }

Regards
dave
