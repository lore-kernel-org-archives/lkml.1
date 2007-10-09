Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXJIV3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXJIV3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXJIV3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:29:25 -0400
Received: from mail.tmr.com ([64.65.253.246]:43489 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbXJIV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:29:24 -0400
Message-ID: <470BF449.5000708@tmr.com>
Date: Tue, 09 Oct 2007 17:36:09 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr> <1191885157.5508.27.camel@daplas> <Pine.LNX.4.64.0710090118040.14524@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710090118040.14524@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried something useful with this, see below.

Jan Engelhardt wrote:
> On Oct 9 2007 07:12, Antonino A. Daplas wrote:
>>> References: http://lkml.org/lkml/2007/4/1/162
>>> 	http://lkml.org/lkml/2007/10/5/199
>> This is quite a long thread :-)
> 
> It was a patch series after all. But as Greg puts it, be persistent.
> 
>>> +config VT_PRINTK_COLOR
>>> +	hex "Colored kernel message output"
>>> +	range 0x00 0xFF
>>> +	depends on VT_CKO
>>> +	default 0x07
>>> +	---help---
>>> +	This option defines with which color kernel messages will be
>>> +	printed to the console.
>>> +
>>> +	The value you need to enter here is the value is composed
>> The more correct term for "The value" is probably "The attribute".
> 
> "The value for this kconfig entry" it should read in the minds.
> 
>>> +	(Foreground colors 0x08 to 0x0F do not work when a VGA
>>> +	console font with 512 glyphs is used.)
>> You might have to include a warning that those values or attributes are 
>> interpreted differently depending on the driver used, and the above is
>> mostly true for 16-color console drivers only.
> 
> Are there any other drivers besides vgacon and fbcon that use vt.c?
> 
>> For 2-colors [...] With a 4-color fb console (4-level grayscale) [...]
>> With an 8-color console, only the first 8 values are considered.
>> With a 16-color console, that is also not consistent:[...]
> 
> I see. That probably means the explanation of values moves from Kconfig 
> to Documentation/. Somehow I think we could do without doc and let 
> interested starts find out for themselves and learn a little about 
> vgacon/fbcon. ;)

It probably means that the very clear explanations you shortened above 
should go it a file in Documentation. Particularly with the feature to 
have different levels of message different colors this allows monitoring 
of machines even when you can't read the message from a distance. When 
you see the magic color you can go look closer.
> 
>> With vgacon, it supports 16-color foreground (fg), 8-color
>> background (bg) at 256 chars. Becomes 8 fg and 8 bg with 512 chars.
>>
>> With fbcon, it supports 16 fg and 16 bg at 256, 16 fg and 8 bg at
>> 512 chars.
> 
> And then there is fbiterm, which supports at least 16 fg/16 bg with ... 
> the whole Unicode set of chars. :)
> 
>> And for drivers that have their own con_build_attr() hook, they will be
>> interpreted differently again.
> 
>>> +	Background:
>>> +	0x00 = black,   0x40 = blue,
>>> +	0x10 = red,     0x50 = magenta,
>>> +	0x20 = green,   0x60 = cyan,
>>> +	0x30 = brown,   0x70 = gray,
>>> +
>>> +	For example, 0x1F would yield white on red.
>> You may need to specify that the values here are the console default,
>> ie, the default_blue|grn|red boot options are not filled up.
> 
>>> +static inline void vc_set_color(struct vc_data *vc, unsigned char color)
>>> +{
>>> +	vc->vc_color = color_table[color & 0xF] |
>>> +	               (color_table[(color >> 4) & 0x7] << 4) |
>>> +	               (color & 0x80);
>> You may want to leave out the blink attribute (0x80) from this part.
>> Otherwise setterm -blink on|off will produce the opposite effect. 
> 
> But 0x80 might be interpreted in a different fashion for some othercon, 
> yielding for example superbold rather than blinking.
> I'll have to try this, because usually, setterm operates on TTYs
> rather than VCs.

I tried something here, I have a monitor page on my window manager with 
lots of xterms opened to machines like DNS, HTTP, mail and NNTP servers. 
I use 100x25 xterms, with font size default. So just for fun I put a one 
line message on one in green on black (instead of black on white) and 
sized them all down to "unreadable" (cntl-right click menu) and I could 
clearly tell which one had the message even on the postage stamps.

Then I tried white on red, white on blue, and white on green. Those 
messages made the tiny xterm stand out as well. So I think it's a true 
statement that using colors to make important stuff stand out is 
something which in practice would be useful. Obviously if you use the 
"unreadable" font you can't read it, but that one xterm can be resized 
to a sane font to actually use it.

This isn't any dumber that Fedora printing the boot status of anything 
which fails in red, that may be "damned by faint praise" of course.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
