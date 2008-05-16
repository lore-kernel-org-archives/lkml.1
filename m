Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYEPL12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYEPL12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYEPL1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:27:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40130 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYEPL1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:27:19 -0400
Date: Fri, 16 May 2008 14:25:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080516112531.GB8029@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota> <20080514165434.GC22115@cs181133002.pp.htv.fi> <20080514145554.10e3385c@gaivota> <20080514193822.GA21795@cs181133002.pp.htv.fi> <20080514170405.330c0d0a@gaivota> <20080515160245.GA1936@cs181133002.pp.htv.fi> <20080515225032.5a9235d7@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080515225032.5a9235d7@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:50:32PM -0300, Mauro Carvalho Chehab wrote:
> On Thu, 15 May 2008 19:02:46 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Wed, May 14, 2008 at 05:04:05PM -0300, Mauro Carvalho Chehab wrote:
> > >...
> > > > but otherwise that 
> > > > would be a straightforward solution to solve these problems.
> > > 
> > > This will solve several troubles. Still, I think that there are still some
> > > other missing dependencies (like INPUT, on drivers that select IR).
> > 
> > We could select INPUT from drivers/media/
> 
> Several drivers don't need INPUT (webcams, radio, etc). This is needed only by
> the TV reception devices (analog and digital). 

I wanted to simply turn the existing dependencies on INPUT to select's
(and add a dependency on S390 to the "Multimedia devices" menu).

> Yet, I can't imagine any production kernel without INPUT. What happens if INPUT
> is disabled? No keyboard, no tablet and no mouse at all?

CONFIG_INPUT is always y unless you enable CONFIG_EMBEDDED.

But on some kinds of embedded systems kernels without INPUT are actually 
not uncommon - and they don't have any keyboard or mouse.

> > And FW_LOADER should really select HOTPLUG - there's no good reason for 
> > FW_LOADER to be a user-visible option with dependencies.
> 
> It seems safe to select HOTPLUG instead of depending on it.
> 
> > But these two are problems that are only relevant for randconfig users 
> 
> True. Hotplug may eventually be relevant for embedded users. However,
> "depends on HOTPLUG" is already present to all points where FW_LOADER is
> needed (I added such patch at my previous pull request). So, the way it is
> seems OK. I don't see much reason to change it.

I'm not only thinking about today, that's an ongoing problem that could 
be fixed this way.

Plus the fact that the dependencies on HOTPLUG don't help you when the 
option gets select'ed.

> > while the I2C troubles hit real users, so I want to attack the I2C 
> > issues first.
> 
> Very true. Also, it is not obvious to the final user that he would need to
> select I2C to have a video input driver.
> 
> > > > Any problem I miss or should I bake a patch?
> > > 
> > > I can't see any trouble on this approach. Feel free to work on it.
> > 
> > First issue when working on it:
> > 
> > The dependencies between VIDEO_IR and VIDEO_IR_I2C look wrong
> > (consider VIDEO_IR=y and I2C=m).
> > 
> > It's not a problem since currently all users of VIDEO_IR also depend
> > on I2C.
> 
> True. I got a compilation error with saa7134 that seems to be caused by this
> trouble.

That sounds unrelated.

Do you have a list of open issues (preferably with .config's)?

> > Should I fix the dependency or can I let VIDEO_IR select I2C and remove 
> > VIDEO_IR_I2C?
> 
> The better would be to fix the dependency. The proper way seems to remove the
> select from VIDEO_IR, and add an explicit select to VIDEO_IR_I2C where needed.
> 
> I would add an entry to allow the user to select this explicitly, for power
> users, and select it implicitly. Something like:
> 
> select VIDEO_IR_I2C  if VIDEO_HELPER_CHIPS_AUTO
> 
> at the drivers under media/video that selects IR. This need to be mandatory for
> a few drivers like saa7134, where some exported symbols at kbd-ir-i2c are used
> there.

Are there any real use cases for this justifying adding yet another 
twist to the kconfig stuff?

I want to make it simpler, not more complicated, and your last sentence 
just describes another new pitfall.

I get the point that it makes sense that it's possible to build only the 
one tuner you actually have instead of a dozen automatically select'ed,
but you must somewhere draw a "this twist is not worth the maintainance 
overhead" line.

The overall picture is that we cannot add a kconfig option and an 
#ifdef around each line of code in the kernel only because someone might 
want to disable it.

We simply cannot maintain that in the long term
(drivers/media/ is already at the edge).

And as soon as you enter the 10kB object code size area there are enough 
lower hanging fruits for saving space that do not involve increased 
complexity in kconfig. 

> Cheers,
> Mauro

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

