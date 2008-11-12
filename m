Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYKLRF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYKLRF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYKLRFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:05:07 -0500
Received: from mail.queued.net ([207.210.101.209]:4253 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYKLRFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:05:05 -0500
Date: Wed, 12 Nov 2008 12:04:59 -0500
From: Andres Salomon <dilinger@queued.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org, Jeremy Katz <katzj@redhat.com>
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
Message-ID: <20081112120459.3b421df6@ephemeral>
In-Reply-To: <s5hljvpkyfw.wl%tiwai@suse.de>
References: <s5h3ahyqwmn.wl%tiwai@suse.de>
	<20081111125402.GB14989@elte.hu>
	<s5hzlk6pea6.wl%tiwai@suse.de>
	<20081111135306.GA32709@elte.hu>
	<s5hwsfapdoj.wl%tiwai@suse.de>
	<20081111140406.GA3244@elte.hu>
	<20081109201710.4c490f04@debxo>
	<s5hljvpkyfw.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 11:53:23 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Sun, 9 Nov 2008 20:17:10 -0800,
> Andres Salomon wrote:
> > 
> > On Tue, 11 Nov 2008 15:04:06 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > 
> > > > At Tue, 11 Nov 2008 14:53:06 +0100,
> > > > Ingo Molnar wrote:
> > > > > 
> > > > > 
> > > > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > > > 
> > > > > > At Tue, 11 Nov 2008 13:54:02 +0100,
> > > > > > Ingo Molnar wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > * Takashi Iwai <tiwai@suse.de> wrote:
> > > > > > > 
> > > > > > > > The OLPC-specpfic codes require geode_gpio_*() functions
> > > > > > > > although these functions are defined only with
> > > > > > > > CONFIG_MGEODE_LX=y. Add a proper dependency to fix build
> > > > > > > > errors.
> > > > > > > > 
> > > > > > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > > > > 
> > > > > > > hm, could you please send a .config that shows the build
> > > > > > > errors?
> > > > > > 
> > > > > > Here it is.  It's for today's linux-next.
> > > > > 
> > > > > hm, which tree did that build failure in linux-next originate
> > > > > from? Your config builds fine here with the latest x86 tree.
> > > > 
> > > > Ah, sorry, forgot to mention that the build error comes from the
> > > > latest ALSA code.  It contains an OLPC-specific code that is
> > > > enabled via CONFIG_OLPC like:
> > > > 
> > > > 	snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
> > > > 
> > > > where this includes geode_gpio_*() calls.
> > > > 
> > > > Of course, I can add an if in Makefile or create a new Kconfig,
> > > > but since asm/olpc.h itself includes asm/geode.h and contains 
> > > > geode_gpio*() calls, it would be a proper fix to make
> > > > CONFIG_OLPC dependent on geode.
> > > 
> > > ah, okay, agreed - i was worried whether this is something
> > > affecting v2.6.28 or slipping through our testing before commits
> > > hit linux-next.
> > > 
> > > I've queued up your fix in tip/x86/kconfig, thanks Takashi!
> > > 
> > > 	Ingo
> > 
> > 
> > This works for now (though it's probably going to anger some people
> > who are trying to make generic distro kernels),
> 
> Well, no reason to get angry.  It can't be generic as is now because
> of geode-specific features.
> 
> > but what we really need to
> > do is to make geode_gpio* defined even when we're not specifically
> > building with MGEODE_LX.  I'm not sure how best to do that, but the
> > answer probably includes using the generic x86 gpio api.
> 
> OTOH, if geode-specific functions are silently ignored, e.g. via dummy
> inline functions, the resultant kernel/driver won't work properly
> although you don't get any build errors with CONFIG_OLPC=y.  With the
> explicit option, you can know at least something has to be enabled
> properly...
> 
> 

Right.  The gpio stuff probably needs to be a
generic CONFIG_X86_GPIO, and CONFIG_MGEODE_LX should just set cpu
optimizations/cache sizes.  We also need to not conflict w/ any other
potential x86 gpio users as well.
