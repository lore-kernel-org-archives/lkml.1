Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYEPBwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYEPBwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYEPBwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:52:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYEPBwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:52:37 -0400
Date: Thu, 15 May 2008 22:50:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080515225032.5a9235d7@gaivota>
In-Reply-To: <20080515160245.GA1936@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota>
	<20080514165434.GC22115@cs181133002.pp.htv.fi>
	<20080514145554.10e3385c@gaivota>
	<20080514193822.GA21795@cs181133002.pp.htv.fi>
	<20080514170405.330c0d0a@gaivota>
	<20080515160245.GA1936@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 19:02:46 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, May 14, 2008 at 05:04:05PM -0300, Mauro Carvalho Chehab wrote:
> >...
> > > but otherwise that 
> > > would be a straightforward solution to solve these problems.
> > 
> > This will solve several troubles. Still, I think that there are still some
> > other missing dependencies (like INPUT, on drivers that select IR).
> 
> We could select INPUT from drivers/media/

Several drivers don't need INPUT (webcams, radio, etc). This is needed only by
the TV reception devices (analog and digital). 

Yet, I can't imagine any production kernel without INPUT. What happens if INPUT
is disabled? No keyboard, no tablet and no mouse at all?

> And FW_LOADER should really select HOTPLUG - there's no good reason for 
> FW_LOADER to be a user-visible option with dependencies.

It seems safe to select HOTPLUG instead of depending on it.

> But these two are problems that are only relevant for randconfig users 

True. Hotplug may eventually be relevant for embedded users. However,
"depends on HOTPLUG" is already present to all points where FW_LOADER is
needed (I added such patch at my previous pull request). So, the way it is
seems OK. I don't see much reason to change it.

> while the I2C troubles hit real users, so I want to attack the I2C 
> issues first.

Very true. Also, it is not obvious to the final user that he would need to
select I2C to have a video input driver.

> > > Any problem I miss or should I bake a patch?
> > 
> > I can't see any trouble on this approach. Feel free to work on it.
> 
> First issue when working on it:
> 
> The dependencies between VIDEO_IR and VIDEO_IR_I2C look wrong
> (consider VIDEO_IR=y and I2C=m).
> 
> It's not a problem since currently all users of VIDEO_IR also depend
> on I2C.

True. I got a compilation error with saa7134 that seems to be caused by this
trouble.
> 
> Should I fix the dependency or can I let VIDEO_IR select I2C and remove 
> VIDEO_IR_I2C?

The better would be to fix the dependency. The proper way seems to remove the
select from VIDEO_IR, and add an explicit select to VIDEO_IR_I2C where needed.

I would add an entry to allow the user to select this explicitly, for power
users, and select it implicitly. Something like:

select VIDEO_IR_I2C  if VIDEO_HELPER_CHIPS_AUTO

at the drivers under media/video that selects IR. This need to be mandatory for
a few drivers like saa7134, where some exported symbols at kbd-ir-i2c are used
there.

Cheers,
Mauro
