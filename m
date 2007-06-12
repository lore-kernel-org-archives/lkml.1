Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbXFLPYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbXFLPYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXFLPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:24:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:56862 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754796AbXFLPYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:24:39 -0400
Date: Tue, 12 Jun 2007 17:25:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz> 
 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com> 
 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz> 
 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com> 
 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz> 
 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com> 
 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz> 
 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com> 
 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com>
 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, Renato Golin wrote:

> At joydev_connect, the last parameter "input_dev" reports me that range 
> (dev->absmax[i] and dev->absmin[i]). When I turned on HID_DEBUG it 
> reported [0, 4096] for both axis 0 and 1, which is correct so it must be 
> between HID and joydev.

Renato,

could you please apply the stupid patch below (against 2.6.20, I know you 
are using it :) ) and report the result? It should show us whether the 
values 0 and 4096 (which can be seen in your hid parsing debug dump) are 
correctly passed from HID to input, or they are garbled inside the hid 
layer somewhere already.

Thanks.

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c7a6833..9dea1e8 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -665,9 +665,16 @@ static void hidinput_configure_usage(str
 			b = field->logical_maximum = 255;
 		}
 
-		if (field->application == HID_GD_GAMEPAD || field->application == HID_GD_JOYSTICK)
+		if (field->application == HID_GD_GAMEPAD || field->application == HID_GD_JOYSTICK) {
+			printk(KERN_DEBUG "calling input_set_abs_params, code: %x, min: %x, max: %x, fuzz: %x, flat: %x\n", 
+					usage->code, a, b, (b - a) >> 8, (b - a) >> 4);
 			input_set_abs_params(input, usage->code, a, b, (b - a) >> 8, (b - a) >> 4);
-		else	input_set_abs_params(input, usage->code, a, b, 0, 0);
+		}
+		else {
+			printk(KERN_DEBUG "calling input_set_abs_params, code: %x, min: %x, max: %x, fuzz: %x, flat: %x\n", 
+					usage->code, a, b, (b - a) >> 8, (b - a) >> 4);
+			input_set_abs_params(input, usage->code, a, b, 0, 0);
+		}
 
 	}
 
