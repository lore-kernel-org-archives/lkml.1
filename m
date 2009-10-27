Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZJ0Fel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZJ0Fel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZJ0Fek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:34:40 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:38674 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZJ0Fek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=C5ZJnbdDF03nnVjyaVhQKFZZjIo/rwkVQFeSdVwYYIHrTa+LAW77QDW661Wyaret5J
         WToypzNLeiHlhGNrZf46SlHGOJwiJqFcMrPaT2Z4TIp9rL+pLPRSJkVSY62Ng1z/PWmg
         sqzohzwq3Db7VFQYzmHicR9GaDJS9PLgK39vg=
Date: Tue, 27 Oct 2009 13:34:04 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091027053404.GA2241@darkstar.vlan7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pressing somekey at early booting phase cause keyboard to be not usable
(The hardware is DELL latitude e5400):

atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.

i8042.c set i8042_direct to true when the controller init. But the result
is keyboard not usable, The only option is press the power button to shutdown. 

So here remove the bios check to fix it.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/input/serio/i8042.c |    8 --------
 1 file changed, 8 deletions(-)

--- linux-2.6.orig/drivers/input/serio/i8042.c	2009-10-13 08:57:07.000000000 +0800
+++ linux-2.6/drivers/input/serio/i8042.c	2009-10-27 13:15:13.000000000 +0800
@@ -869,14 +869,6 @@ static int i8042_controller_init(void)
 	spin_unlock_irqrestore(&i8042_lock, flags);
 
 /*
- * If the chip is configured into nontranslated mode by the BIOS, don't
- * bother enabling translating and be happy.
- */
-
-	if (~i8042_ctr & I8042_CTR_XLATE)
-		i8042_direct = true;
-
-/*
  * Set nontranslated mode for the kbd interface if requested by an option.
  * After this the kbd interface becomes a simple serial in/out, like the aux
  * interface is. We don't do this by default, since it can confuse notebook
