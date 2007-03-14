Return-Path: <linux-kernel-owner+w=401wt.eu-S1422639AbXCNPUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639AbXCNPUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161338AbXCNPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:20:07 -0400
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:36648 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161325AbXCNPUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:05 -0400
Message-ID: <45F812A1.3060108@tremplin-utc.net>
Date: Wed, 14 Mar 2007 16:20:01 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
References: <45ECA23A.5010503@tremplin-utc.net>	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
In-Reply-To: <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

03/14/2007 02:54 PM, Dmitry Torokhov wrote/a écrit:
> Hi Eric,
> 
:
> I have couple of comments/requests:
> 
> 1. KEY_OPEN and KEY_CLOSE should not be used to signal state of the
> lid, they correspond to Accpication Control Open and Close keys from
> USB HID HUT spec:
> 
>     http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
> 
> SW_LID shoudl be used to signal lid state instead.
The keycodes put in the keymap are simply the same as in acerhk, just 
because I couldn't think of better. Indeed, KEY_OPEN and KEY_CLOSE seem 
to badly fit if they might be interpreted by userland as opening or 
closing a document! That would be better to generate a SW_LID event, but 
I'm not sure how to do that, is it just about using 
input_report_switch(x, SW_LID, 0 or 1) instead of using 
input_report_key()? Probably I need to update input_dev->swbit as well. 
Do I have to anything else to generate switch events?

Sincerely, I don't think anyone is using this info (especially because 
probably the info is also passed though ACPI) so that would be fine with 
me to just not generate any event :-P Tell me if you think it worths it.


> 2. I also have a concern about using KEY_SCREEN to signal toggling
> display on and off. I am CCing Vojtech - he must know what the
> original intent of this key code was. BTW, when user presses
> corresponding button - does the display actually goes off? Maybe we
> need another switch.
Only few laptops generate an event for this key (most of the laptop 
simply switch the screen). I don't have access to any of those, so I've 
no idea if it's the userland which has to control the display or if it's 
just information for the userland. Maybe Olaf knows? I don't think it's 
possible to convert it to a switch event because it doesn't report the 
information about if screen is on or off.

On the same topic, there are some "KEY_MEDIA" generated when key to 
change display output is pressed. Is it fine for you or do have a more 
suiting keycode in mind?


> 3. The number of keymap tables grew considerably ;) Do you think it
> woudl make sense to allocate memory for keymap at device creation time
> and copy selected keymap and them mark all original keymaps as
> __initdata so they are discarded one module completed initialization?
In the patch, I've reduced the keymap structure to only take 32bits per 
key. So, in the absolute, it's not that terrible with each keymap taking 
about 40 bytes. Still, it wouldn't hurt to save space knowing that it's 
likely that the list keeps growing up. It shouldn't be hard to do as you 
propose with the __initdata.

I had thought about a different way: as the generic keymap should fit 
most of the laptop, we could save only the difference of a given laptop 
to this keymap (then behaving more like a "quirk"). This would have the 
advantage of saving space even in the source file ;-)

I'll try to tinker a bit with both approaches and see what fit best. 
Anyway, is it ok for you to merge those patches first and later I'll 
come up with a space-saver patch?

See you,
Eric
