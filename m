Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYCZTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYCZTWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759313AbYCZTWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:22:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34554 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759027AbYCZTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:22:24 -0400
Date: Wed, 26 Mar 2008 20:10:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Dave Airlie <airlied@gmail.com>, I2C <i2c@lm-sensors.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080326201031.7c2cefb2@hyperion.delvare>
In-Reply-To: <20080326173701.GA16882@deepthought>
References: <20080325200714.GA25487@deepthought>
	<20080326161934.7eae544f@hyperion.delvare>
	<20080326173701.GA16882@deepthought>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 17:37:01 +0000, Ken Moffat wrote:
> On Wed, Mar 26, 2008 at 04:19:34PM +0100, Jean Delvare wrote:
> > Hi Ken,
> > 
> > On Tue, 25 Mar 2008 20:07:14 +0000, Ken Moffat wrote:
> > > Hi,
> > > 
> > >  on one of my boxes, I've got a problem with gdm and kernels newer
> > > than 2.6.24 (tested on 2.6.24.2, 2.6.24.4).  If I try to restart or
> > > shut down from gdm, the window disappears but the X background remains
> > > and the box stays in runlevel 5 until I switch to a tty and shut it
> > > down (as root) or give it a 3-fingered salute to reboot.
> > 
> > I have to admit that I am very skeptical. The i2c-viapro driver deals
> > with the motherboard's SMBus. It's not related in any way to gdm nor
> > drm, so I just can't see how it could cause the problem you report.
> > What gave you the idea to try unloading this driver?
>
>  Your skepticism seems reasonable.  I tried this after I went back
> to the "bad" 2.6.24.4 (to see if there was anything in the X log)
> only to discover it was now shutting sown ok.  I knew I had
> forgotten to change the extraversion when I reverted the patch, so
> I figured it must be something in the modules (i.e. the good ones
> overwrote the bad ones - dunno if they all load or not).

The fact is that there is no i2c-viapro change in 2.6.24.2 nor .4, and
in fact no i2c change at all. So if anything changed in this driver,
this has to be a side effect of some (non-i2c) header file change.
That's a long shot, though.

> 
>  After going back to 2.6.24.2 where I'd first seen this, I had a
> look at what was loaded - only r8169, w83627hf with hwmon_vid, and
> i2c_viapro.  I tried hwmon_vid and w83627hf but it didn't help.
> Then I tried i2c_viapro and it seemed to fix it.

Did you try unloading r8169 instead? It's certainly less easy to test,
but I think it's worth a try. The only thing that unloading i2c-viapro
really does is unbinding a PCI device and removing a PCI driver. So, if
for some reason shaking the PCI bits solves your problem, then maybe
unloading r8169 would have the same effect.

You could also try reloading i2c-viapro after unloading it. I wonder if
your problem will be back or not. (Not that I would be able to come up
to any conclusion either way...)

> > 
> > Do you have I2C or SMBus devices connected to the SMBus on that machine?
> > If you don't know, i2cdetect should tell.
> 
>  After modprobing i2c-dev I get
> root@bluesbreaker /home/ken #i2cdetect -l
> i2c-0	i2c       	monid                           	I2C
> adapter
> i2c-1	i2c       	dvi                             	I2C
> adapter
> i2c-2	i2c       	vga                             	I2C
> adapter
> i2c-3	i2c       	crt2                            	I2C
> adapter
> i2c-4	smbus     	SMBus Via Pro adapter at 0400
> SMBus adapter
>  [ nothing shows on 1 ]
> root@bluesbreaker /home/ken #i2cdetect 2
> WARNING! This program can confuse your I2C bus, cause data loss and
> worse!
> I will probe file /dev/i2c-2.
> I will probe address range 0x03-0x77.
> Continue? [Y/n] 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --                         

Totally unrelated, but FYI: the chip at 0x50 is an EDID EEPROM in your
display (which the radeonfb driver can use to switch to the correct
resolution / refresh rate.)

>  [ othing shows on 3 ]

Just in case... You might want to check that the problem is still
present with the radeonfb driver not built into your kernel (and
not loaded as a module either). Framebuffer drivers and X can fight
for resources sometimes.

> root@bluesbreaker /home/ken #i2cdetect 4
> WARNING! This program can confuse your I2C bus, cause data loss and
> worse!
> I will probe file /dev/i2c-4.
> I will probe address range 0x03-0x77.
> Continue? [Y/n] 
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 2f 
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: 50 51 -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 60: -- -- -- -- -- -- -- -- -- 69 -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --                         

OK... 0x50 and 0x51 are the SPD EEPROMs on your two memory modules. At
0x69 you have a clock chip. At 0x2f... maybe a hardware monitoring
chip, maybe something else. But more importantly, no driver attached to
any of these chips. So, the mysterious effect of unloading the
i2c-viapro driver can't be explained by an i2c chip driver detaching
from its device. So, again, I really can't see how i2c can be involved
in your problem.

Good luck,
-- 
Jean Delvare
