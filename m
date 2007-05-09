Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbXEIVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbXEIVse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbXEIVsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:48:23 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:63829
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbXEIVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:48:22 -0400
Message-ID: <1229.192.168.1.10.1178747299.squirrel@eggplant.ddo.jp>
Date: Thu, 10 May 2007 06:48:19 +0900 (JST)
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: "Richard Purdie" <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp><1178628889.6061.33.camel@localhost.localdomain><2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp><1178723594.6291.21.camel@localhost.localdomain>
In-Reply-To: <1178723594.6291.21.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-05-09 at 23:26 +0900, kogiidena wrote:
>> Hi Richard-san
>> The following three points were corrected.
>> 1.
>> > You can't do this since the trigger will appear for all LEDs and it only
>> > applies to a single LED. There has been previous discussion of LED
>> > specific triggers and we'll need that support before you can make
>> > something like this work. Nobody has sent me a patch for that yet and I
>> > haven't had time to write one...
>> The trigger name past "disk" was changed to the name "hard".
>> This is to mean the hardware of LANDISK controls LED.
>> The problem of "LED specific triggers" is solved.
>
> No, its not solved.
>
> Imagine I connect some device with its own LEDs and LED drivers. I'll
> use "corgi:amber" as an example.
>
> I run:
>
> 'cat /sys/class/leds/corgi:amber/triggers'
>
> I see "hard" listed.
>
> 'echo "hard" > /sys/class/leds/corgi:amber/triggers'
>
> doesn't work though...
>
> If its not going to work, it shouldn't be listed.
>
> Regards,
>
> Richard
>

I think, "Solved it" because I changed the source code.

LANDISK have two LED.
One is power-led. The other is status-led.
Power-led and status-led can respectively set "hard", and it operates normally.

'echo "hard" >  /sys/class/leds/power/triggers'
It works. Power-led behaves as always lights.
Power-led is controlled with hardware based on specific logic (CPLD) in LANDISK.

'echo "hard" >  /sys/class/leds/status/triggers'
It works too. Status-LED behaves as HDD-access-LED.
Status-led is controlled with hardware based on specific logic (CPLD) in LANDISK too.

+/*
+ * LANDISK hardware controled LED trigger
+ *
+ *  bit[3:0] = x0xx : power-led  is allways ON.
+ *  bit[3:0] = x1x0 : power-led  is ON.
+ *  bit[3:0] = x1x1 : power-led  is OFF.
+ *  bit[3:0] = 0xxx : status-led is HDD access-LED.
+ *  bit[3:0] = 1x0x : status-led is ON
+ *  bit[3:0] = 1x1x : status-led is OFF
+ */
+static void landisk_hard_trig_activate(struct led_classdev *led_cdev)
+{
+        unsigned long flags;
+        int bitmask;
+
+        bitmask = 0x04 << (led_cdev - &landisk_leds[0]);
+
+        spin_lock_irqsave(&landisk_led_lock, flags);
+        ctrl_outb(ctrl_inb(PA_LED) & ~bitmask, PA_LED);
+        spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static void landisk_hard_trig_deactivate(struct led_classdev *led_cdev)
+{
+        unsigned long flags;
+        int bitmask;
+
+        bitmask = 0x04 << (led_cdev - &landisk_leds[0]);
+
+        spin_lock_irqsave(&landisk_led_lock, flags);
+        ctrl_outb(ctrl_inb(PA_LED) | bitmask, PA_LED);
+        spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+

kogiidena



