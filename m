Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYEQLAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYEQLAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYEQLAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:00:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYEQLAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:00:09 -0400
Date: Sat, 17 May 2008 06:58:47 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
In-Reply-To: <20080516112531.GB8029@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0805170624490.11757@bombadil.infradead.org>
References: <20080514114910.4bcfd220@gaivota> <20080514165434.GC22115@cs181133002.pp.htv.fi>
 <20080514145554.10e3385c@gaivota> <20080514193822.GA21795@cs181133002.pp.htv.fi>
 <20080514170405.330c0d0a@gaivota> <20080515160245.GA1936@cs181133002.pp.htv.fi>
 <20080515225032.5a9235d7@gaivota> <20080516112531.GB8029@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Adrian Bunk wrote:

> I wanted to simply turn the existing dependencies on INPUT to select's
> (and add a dependency on S390 to the "Multimedia devices" menu).

I suspect you're maning depends on !S390. This is not needed, since 
Multimedia devices is already dependent on HAS_IOMEM.

>> Yet, I can't imagine any production kernel without INPUT. What happens if INPUT
>> is disabled? No keyboard, no tablet and no mouse at all?
>
> CONFIG_INPUT is always y unless you enable CONFIG_EMBEDDED.
>
> But on some kinds of embedded systems kernels without INPUT are actually
> not uncommon - and they don't have any keyboard or mouse.

There are several embedded V4L/DVB devices: Cellular phones, Set Top 
Boxes, surveillance systems, etc. I'm not sure if forcing the need for 
INPUT would be nice. Also, from time to time, people ask for a feature of 
allowing to disable the IR.

Maybe the better would be to allow the user to explicitly select/unselect 
IR (for advanced users, and if INPUT). If IR is disabled, we may disable 
the corresponding <board>-input.c compilation. It doesn't seem hard to do 
this way, but it will require more time to bake a patch.

> I'm not only thinking about today, that's an ongoing problem that could
> be fixed this way.
>
> Plus the fact that the dependencies on HOTPLUG don't help you when the
> option gets select'ed.

Yes, but the committed patch is adding "depends on HOTPLUG" to all devices 
that selects FW_LOADER.

If you want, feel free to change this to select, although I can't see any 
real gain.

> Do you have a list of open issues (preferably with .config's)?

The open issue I see is to check the "depends on" for all symbols that are 
selected.

>>> Should I fix the dependency or can I let VIDEO_IR select I2C and remove
>>> VIDEO_IR_I2C?

I would remove the select inside VIDEO_IR, adding a separate select for 
VIDEO_IR_I2C. There's a problem on saa7134-input: It uses some symbols 
defined on ir-kbd-i2c:

$ grep EXPORT ir-kbd-i2c.c
EXPORT_SYMBOL_GPL(get_key_pinnacle_grey);
EXPORT_SYMBOL_GPL(get_key_pinnacle_color);

This breaks saa7134 compilation, if IR-I2C is not selected (or if it is a 
module, and saa7134 is 'Y).

The proper fix here is to move those symbols to ir-keymaps.c, where the 
shared IR tables should be.

Except for this, it is safe to allow the user to not compile VIDEO_IR_I2C, 
even for devices that has i2c IR's. If the module is not compiled, 
request_module() will fail, but everything else will work properly.

>> I would add an entry to allow the user to select this explicitly, for power
>> users, and select it implicitly. Something like:
>>
>> select VIDEO_IR_I2C  if VIDEO_HELPER_CHIPS_AUTO
>>
>> at the drivers under media/video that selects IR. This need to be mandatory for
>> a few drivers like saa7134, where some exported symbols at kbd-ir-i2c are used
>> there.
>
> Are there any real use cases for this justifying adding yet another
> twist to the kconfig stuff?
>
> I want to make it simpler, not more complicated, and your last sentence
> just describes another new pitfall.
>
> I get the point that it makes sense that it's possible to build only the
> one tuner you actually have instead of a dozen automatically select'ed,
> but you must somewhere draw a "this twist is not worth the maintainance
> overhead" line.
>
> The overall picture is that we cannot add a kconfig option and an
> #ifdef around each line of code in the kernel only because someone might
> want to disable it.
>
> We simply cannot maintain that in the long term
> (drivers/media/ is already at the edge).

True.

>
> And as soon as you enter the 10kB object code size area there are enough
> lower hanging fruits for saving space that do not involve increased
> complexity in kconfig.

Yes, but in is, in fact, 10K * lots of modules.

The point is that the I2C modules behave very well if they aren't 
compiled.

I can, for example, compile bttv with just tuner-simple, and nothing else. 
This will work with all bttv functionalities for two devices I have here. 
A third analog-only device will require TVAUDIO, otherwise, the audio chip 
won't be loaded, and audio decoder won't happen. So, the device will work 
only with video.

I don't see much troubles with most of those I2C helper modules, since the 
vast majority depends only on I2C (only a few also depends on FW_LOADER).

Cheers,
Mauro
