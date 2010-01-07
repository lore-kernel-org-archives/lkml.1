Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059Ab0AGGwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0AGGwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771Ab0AGGwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:52:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34303 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0AGGwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:52:49 -0500
Date: Thu, 7 Jan 2010 07:52:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>, dtor@mail.ru,
       linux-input@vger.kernel.org
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
Message-ID: <20100107065230.GA1303@ucw.cz>
References: <20100106071026.GD1382@ucw.cz> <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-01-06 15:17:39, Eric Miao wrote:
> On Wed, Jan 6, 2010 at 3:10 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > Sharp-SL code uses strange, complex grouping of gpios for wakeups
> > toggling. Fortunately, it is unneeded in recent kernels (and actually
> > provokes WARN_ONs during resume). Remove it.
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Pavel,
> 
> The code to be removed below is used to support pxa27x_keypad
> to be able to resume from sleep. What's the exact reason to remove
> this on spitz?

Well, otherwise I get this during resume: (2.6.32 regression)

(and similar for matrix-keypad, but dmitry worked around that
already).

Problem is that gpio-keys and matrix-keypad want to set_wake for each
gpio individually, hw can do that, but pxa27x.c breaks it.

I don't get it; what is pxa27x_keypad used on? It looks like
matrix-keypad subset.

								Pavel

pxa2xx-spi pxa2xx-spi.2: resume
sharp-scoop sharp-scoop.0: resume
matrix-keypad matrix-keypad: resume
gpio-keys gpio-keys: resume
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 191 wake disable
Modules linked in:
[<c0024900>] (unwind_backtrace+0x0/0xe4) from [<c00354f4>] (warn_slowpath_common+0x4c/0x80)
[<c00354f4>] (warn_slowpath_common+0x4c/0x80) from [<c0035564>] (warn_slowpath_fmt+0x28/0x38)
[<c0035564>] (warn_slowpath_fmt+0x28/0x38) from [<c00622f4>] (set_irq_wake+0x7c/0x138)
[<c00622f4>] (set_irq_wake+0x7c/0x138) from [<c01d2370>] (gpio_keys_resume+0x94/0xd0)
[<c01d2370>] (gpio_keys_resume+0x94/0xd0) from [<c0193a50>] (platform_pm_resume+0x30/0x54)
[<c0193a50>] (platform_pm_resume+0x30/0x54) from [<c01961e4>] (pm_op+0xa0/0xc0)
[<c01961e4>] (pm_op+0xa0/0xc0) from [<c0196c94>] (dpm_resume_end+0x100/0x474)
[<c0196c94>] (dpm_resume_end+0x100/0x474) from [<c005ef7c>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005ef7c>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005f1b4>] (enter_state+0xe8/0x120)
[<c005f1b4>] (enter_state+0xe8/0x120) from [<c005e8b8>] (state_store+0x90/0xc4)
[<c005e8b8>] (state_store+0x90/0xc4) from [<c01481a4>] (kobj_attr_store+0x1c/0x24)
[<c01481a4>] (kobj_attr_store+0x1c/0x24) from [<c00daab0>] (sysfs_write_file+0x104/0x18c)
[<c00daab0>] (sysfs_write_file+0x104/0x18c) from [<c00922cc>] (vfs_write+0xb0/0x164)
[<c00922cc>] (vfs_write+0xb0/0x164) from [<c0092450>] (sys_write+0x40/0x70)
[<c0092450>] (sys_write+0x40/0x70) from [<c001ff60>] (ret_fast_syscall+0x0/0x28)
---[ end trace d1b2070efbc838e4 ]---
leds-gpio leds-gpio: resume
sharpsl-nand sharpsl-nand: resume


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
