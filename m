Return-Path: <linux-kernel-owner+w=401wt.eu-S964817AbXCYDcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbXCYDcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 23:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbXCYDcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 23:32:09 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:18753 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXCYDcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 23:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:from;
        b=PcqAYhm/2mWFlx+WP4rym0s5y4EqBdTMc3fUd9+HdbfrIJdxzkV9i/PR2oLRnVwpuPa8ybkZTzN0nPxrchwBz+ZOOqyXBgRbI4SkH/vx92M59LpcRWXYEvOqdSai4ExiAqrdqVZTBs/YC3FS0FrAGG8olj3Fa8Y2nhC37XTGc3M=
Date: Sat, 24 Mar 2007 23:32:03 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: keyboard.c: Stop flooding dmesg with useless warnings
Message-ID: <Pine.LNX.4.64.0703242315160.492@paragw-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I use  Apple keyboard and mouse which seem to generate events with 
keycode==0.

keyboard.c floods dmesg endlessly with below messages. This happens at a 
very fast rate and never stops, leaving the dmesg unusable.

[46591.960000] keyboard.c: can't emulate rawmode for keycode 0
[46591.996000] keyboard.c: can't emulate rawmode for keycode 0
[46592.032000] keyboard.c: can't emulate rawmode for keycode 0
[46592.068000] keyboard.c: can't emulate rawmode for keycode 0
[46592.104000] keyboard.c: can't emulate rawmode for keycode 0
[46592.140000] keyboard.c: can't emulate rawmode for keycode 0
[46592.176000] keyboard.c: can't emulate rawmode for keycode 0
[46592.212000] keyboard.c: can't emulate rawmode for keycode 0
[46592.248000] keyboard.c: can't emulate rawmode for keycode 0

The patch below avoids printing the warning if keycode == KEY_RESERVED.

If a more correct fix is possible please let me know and I will redo this.
(I suspect avoiding call to emulate_raw() with value ranges it cannot 
emulate might be a better fix?)

Otherwise please consider applying.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6-wk/drivers/char/keyboard.c	2007-03-24 23:01:19.000000000 -0400
+++ linux-2.6/drivers/char/keyboard.c	2007-03-24 21:43:58.000000000 -0400
@@ -1161,7 +1161,7 @@

  	if ((raw_mode = (kbd->kbdmode == VC_RAW)) && !hw_raw)
  		if (emulate_raw(vc, keycode, !down << 7))
-			if (keycode < BTN_MISC && keycode != KEY_RESERVED)
+			if (keycode < BTN_MISC)
  				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);

  #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
