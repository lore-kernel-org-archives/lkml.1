Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZD2DIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZD2DIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZD2DH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:07:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:59049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZD2DHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,264,1239001200"; 
   d="scan'208";a="407822180"
Subject: Re: acpi 'video' driver, and issues with
	'brightness_switch_enabled=0'
From: Zhang Rui <rui.zhang@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <1240912731.29860.11.camel@maxim-laptop>
References: <1240855052.11237.7.camel@maxim-laptop>
	 <1240886605.4639.19.camel@rzhang-dt>
	 <1240912731.29860.11.camel@maxim-laptop>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Apr 2009 11:08:20 +0800
Message-Id: <1240974500.4639.54.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 17:58 +0800, Maxim Levitsky wrote:
> On Tue, 2009-04-28 at 10:43 +0800, Zhang Rui wrote:
> > On Tue, 2009-04-28 at 01:57 +0800, Maxim Levitsky wrote:
> > > I have a notebook which handles brightness keys in hardware, but tells
> > > loudly when it does so.
> > > 
> > if you boot into console mode w/o ACPI video driver, does the brightness
> > still change when you press the hotkeys?
> They always work.
> For s while, due to buggy ACPI table, acpi 'video' driver won't work, so
> I blacklisted it, and yet hw keys did work.
> 
so if you kill acpid, and run "cat /proc/acpi/event", there are some
ACPI video events popping up when you press the hotkeys, right?

this is bad, because these events are "Used to notify OSPM that the
output device brightness should be increased/decreased by one level.
Used to notify OSPM that the user pressed a button or key that is
associated with cycling brightness." according to the ACPI spec.
So, if BIOS changes the brightness for OS, it should not issue an event
any more.

> > 
> > > Currently, acpi 'video' also sets the brightness, which result in double
> > > setting, and on top of that it emits a key that makes gpm set brightness
> > > again.
> > > 
> > we need to support the brightness control in console mode.
> > and "﻿brightness_switch_enabled" should be cleared in graphics mode to
> > prevent the ACPI video driver action upon hotkey events.
> How gnome power manager can do that, use /sys/module iface?
> 
> > 
> > > And (yes...) on top of that keyboard emits a brightness up/down even,
> > > which (you guessed...) sets brightness again.
> > > 
> > > I found out that it is possible to tell gnome-power-manager not to set
> > > brightness, but yet in kernel driver still sets it.
> > > 
> > > I found out even earlier that I can use brightness_switch_enabled=0,
> > > which supposed to make inkernel driver not touch the brightness.
> > > But I found out that this driver won't update the brightness, in /sys
> > > interface when I set this param.
> > > 
> > No, when ﻿"﻿brightness_switch_enabled" is cleared, gdm should still use
> > the ACPI backlight sysfs I/F if available to change the backlight,
> > i.e. /sys/class/backlight/acpi_video0/...
> Indeed it does, but I don't like it, hardware already changed the
> brightness, but it receives another two events about brightness up/down.
> 
well, this is rather a hardware problem to me.
Because OS should change the brightness upon such a notification, either
in ACPI video driver, or in user space.
IMO, if BIOS doesn't want OS to change the backlight, it should not
issue such events at all.

> It (and I too) can change the brightness, but it doesn't update to
> reflect current brightness
> (/sys/class/backlight/acpi_video0/brightness) shows cached value from
> last time it was set.
> 
> there is also the actual_brightness, but I think it isn't used by gpm.
> 
﻿/sys/class/backlight/acpi_video0/brightness doesn't reflect the actual
brightness level, gdm should use actual_brightness instead.

But if gdm uses the sysfs backlight I/F, the value of these two files
should be the same.

can you do this test please?
1. attach the output of "grep . /sys/class/backlight/acpi_video0/*"
2. press the hotkey
3. redo step 1.

> 
> > 
> > what's the model name of your laptop?
> acer aspire 5720G

hah, I know this laptop.
> > are you using Intel graphics?
> no, nvidia 8400GS
> 
> > please attach the output of acpidump and lspci.
> 
> > It would be great if you can file a bug report about this issue at
> > bugzilla.kernel.org.
> No problem.
And I know you're good at reporting bugs. :p

why not move this discussion to the bugzilla so that I can better track
this bug?

thanks,
rui


