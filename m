Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZD2LPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZD2LPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZD2LPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:15:40 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:48336 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZD2LPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XnodGNmEXlfc6BaM/UHR4/ee4Jk9meCyqnBIgud/+EX6P2Z/j8NFp7cZGX2S3AIbZM
         heiF82ClyCIuUirRwMKNo5fFvxQics7lCvyJkqM1cmZe8psBDoxOdfiMUtKkQ4s1ujhF
         KnphyvrnAeaH64HMoN3wzRJAMNbj/6QiTJ8sA=
Subject: Re: acpi 'video' driver, and issues with
 'brightness_switch_enabled=0'
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <1240974500.4639.54.camel@rzhang-dt>
References: <1240855052.11237.7.camel@maxim-laptop>
	 <1240886605.4639.19.camel@rzhang-dt>
	 <1240912731.29860.11.camel@maxim-laptop>
	 <1240974500.4639.54.camel@rzhang-dt>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Apr 2009 14:15:31 +0300
Message-Id: <1241003731.26698.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 11:08 +0800, Zhang Rui wrote:
> On Tue, 2009-04-28 at 17:58 +0800, Maxim Levitsky wrote:
> > On Tue, 2009-04-28 at 10:43 +0800, Zhang Rui wrote:
> > > On Tue, 2009-04-28 at 01:57 +0800, Maxim Levitsky wrote:
> > > > I have a notebook which handles brightness keys in hardware, but tells
> > > > loudly when it does so.
> > > > 
> > > if you boot into console mode w/o ACPI video driver, does the brightness
> > > still change when you press the hotkeys?
> > They always work.
> > For s while, due to buggy ACPI table, acpi 'video' driver won't work, so
> > I blacklisted it, and yet hw keys did work.
> > 
> so if you kill acpid, and run "cat /proc/acpi/event", there are some
> ACPI video events popping up when you press the hotkeys, right?
> 
> this is bad, because these events are "Used to notify OSPM that the
> output device brightness should be increased/decreased by one level.
> Used to notify OSPM that the user pressed a button or key that is
> associated with cycling brightness." according to the ACPI spec.
> So, if BIOS changes the brightness for OS, it should not issue an event
> any more.
> 
> > > 
> > > > Currently, acpi 'video' also sets the brightness, which result in double
> > > > setting, and on top of that it emits a key that makes gpm set brightness
> > > > again.
> > > > 
> > > we need to support the brightness control in console mode.
> > > and "﻿brightness_switch_enabled" should be cleared in graphics mode to
> > > prevent the ACPI video driver action upon hotkey events.
> > How gnome power manager can do that, use /sys/module iface?
> > 
> > > 
> > > > And (yes...) on top of that keyboard emits a brightness up/down even,
> > > > which (you guessed...) sets brightness again.
> > > > 
> > > > I found out that it is possible to tell gnome-power-manager not to set
> > > > brightness, but yet in kernel driver still sets it.
> > > > 
> > > > I found out even earlier that I can use brightness_switch_enabled=0,
> > > > which supposed to make inkernel driver not touch the brightness.
> > > > But I found out that this driver won't update the brightness, in /sys
> > > > interface when I set this param.
> > > > 
> > > No, when ﻿"﻿brightness_switch_enabled" is cleared, gdm should still use
> > > the ACPI backlight sysfs I/F if available to change the backlight,
> > > i.e. /sys/class/backlight/acpi_video0/...
> > Indeed it does, but I don't like it, hardware already changed the
> > brightness, but it receives another two events about brightness up/down.
> > 
> well, this is rather a hardware problem to me.
> Because OS should change the brightness upon such a notification, either
> in ACPI video driver, or in user space.
> IMO, if BIOS doesn't want OS to change the backlight, it should not
> issue such events at all.
> 
> > It (and I too) can change the brightness, but it doesn't update to
> > reflect current brightness
> > (/sys/class/backlight/acpi_video0/brightness) shows cached value from
> > last time it was set.
> > 
> > there is also the actual_brightness, but I think it isn't used by gpm.
> > 
> ﻿/sys/class/backlight/acpi_video0/brightness doesn't reflect the actual
> brightness level, gdm should use actual_brightness instead.
> 
> But if gdm uses the sysfs backlight I/F, the value of these two files
> should be the same.
> 
> can you do this test please?
> 1. attach the output of "grep . /sys/class/backlight/acpi_video0/*"
> 2. press the hotkey
> 3. redo step 1.
> 
> > 
> > > 
> > > what's the model name of your laptop?
> > acer aspire 5720G
> 
> hah, I know this laptop.
> > > are you using Intel graphics?
> > no, nvidia 8400GS
> > 
> > > please attach the output of acpidump and lspci.
> > 
> > > It would be great if you can file a bug report about this issue at
> > > bugzilla.kernel.org.
> > No problem.
> And I know you're good at reporting bugs. :p
> 
> why not move this discussion to the bugzilla so that I can better track
> this bug?
> 
> thanks,
> rui
> 
> 

I''ll check this.

Best regards,
	Maxim Levitsky

