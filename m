Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbXFUDLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbXFUDLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXFUDLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:11:34 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33490 "EHLO
	asav08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXFUDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:11:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQuAJiJeUZKhRO4R2dsb2JhbACHI4dvAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Writing a driver for a legacy serial device
Date: Wed, 20 Jun 2007 23:11:32 -0400
User-Agent: KMail/1.9.3
Cc: LKML <linux-kernel@vger.kernel.org>, Vojtech Pavlik <vojtech@ucw.cz>
References: <20070619190502.05d4e0c8@hyperion.delvare> <d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com> <20070620105648.6d18ad66@hyperion.delvare>
In-Reply-To: <20070620105648.6d18ad66@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706202311.33326.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 04:56, Jean Delvare wrote:
> Hi Dmitry,
> 
> Thanks for your answer, very much appreciated.
> 
> On Tue, 19 Jun 2007 14:59:34 -0400, Dmitry Torokhov wrote:
> > 
> > You need to load serport modue and play with inputattach utility.
> 
> Ah, I see. There's no way to detect what device is connected to the
> serial port, so we need a user-space tool to bind the port to the right
> driver? Makes some sense, even though it's a but strange that I need
> something called inputattach for a device which isn't an input device.

Because serio interface is mostly used with input devices. For all other
devices I think universal answer is "userspace" but with input devices
we want to do processing in kernel so we can route events into console
and other standard interfaces (although one coudl use uinput to achieve
similar result).

> 
> So I've set CONFIG_SERIO_SERPORT=m, compiled and loaded serport. Then I
> added a new protocol number in <linux/serio.h>:
> 
> #define SERIO_TAOSEVM	0x40
> 
> Then I added the following entry to inputattach and recompiled it:
> 
> { "--taos-evm",		"-taos",	B1200, CS8,			SERIO_TAOSEVM,	0,	0,	0,	NULL },
> 
> Then I changed my driver code to:
> 
> static struct serio_device_id taos_serio_ids[] = {
> 	{
> 		.type	= SERIO_RS232,
> 		.proto	= SERIO_TAOSEVM,
> 		.id	= SERIO_ANY,
> 		.extra	= SERIO_ANY,
> 	},
> 	{ 0 }
> };
> 
> And lastly I ran, as root:
> 
> ./inputattach -taos /dev/ttyS0
> 
> I see the following line in the logs as a result:
> 
> serio: Serial port ttyS0
> 
> But unfortunately, my driver's .connect function is still not called.
> I guess that I missed one step? Any idea what it would be?
> 

Not sure. Could you check /sys/bus/serio/devices/serioX/id/* and verify
that inputattach sets up serio port properly?

-- 
Dmitry
