Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYCCPCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYCCPCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYCCPCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:02:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42696 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYCCPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:02:03 -0500
Date: Mon, 3 Mar 2008 07:01:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-ID: <20080303070117.0325e77a@laptopd505.fenrus.org>
In-Reply-To: <20080303121335.GA15381@elte.hu>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi>
	<47C99FE1.8080206@gmail.com>
	<20080301183550.GC25835@cs181133002.pp.htv.fi>
	<20080303085720.GD15943@elte.hu>
	<20080303091314.GC4457@cs181133002.pp.htv.fi>
	<20080303091714.GA18250@elte.hu>
	<20080303093103.GA23651@uranus.ravnborg.org>
	<20080303103933.GC21190@elte.hu>
	<20080303113451.GF4457@cs181133002.pp.htv.fi>
	<20080303114533.GA4183@elte.hu>
	<20080303121335.GA15381@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 13:13:35 +0100
Ingo Molnar <mingo@elte.hu> wrote:


> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > no, what we should nuke is this always_inline definition. That
> > > > was always the intention of FORCED_INLINE, and the removal of 
> > > > FORCED_INLINE was to _remove the forcing_, not to make it 
> > > > unconditional.
> > > 
> > > It was always unconditional, and neither adding, toggling nor 
> > > removing of CONFIG_FORCED_INLINING changed this invariant.
> > > 
> > > And what we should do is to attack the excessive wrong usage of 
> > > inlines in .c files, not messing with a global #define in a way
> > > that the results on 24 architectures with 7 different releases of
> > > gcc would be unpredictable.
> > 
> > i see, so you never properly reported and fixed it because you
> > prefer a 1000 small crappy changes over one change. You could have 
> > significantly contributed to truly making Linux smaller, but you 
> > decided not to do it.
> > 
> > and i disagree with your notion that flipping it around is risky in 
> > any unacceptable or unmanageable way. It has far less risks on the 
> > compiler than say CONFIG_CC_OPTIMIZE_FOR_SIZE. It has far less
> > risks than changing to a new compiler version. Why you think it's 
> > "unpredictable" is a mystery to me.
> > 
> > It almost seems to me you were happy with having that bug in the 
> > kernel? Please tell me that i'm wrong about that impression!
> > 
> > i'll reinstate this .config option and let it do the right thing. 
> > Forced inlining was supposed to be _phased out_, not phased in.
> 
> i just implemented the trivial fix below and it gave me a massive,
> 2.3% text size reduction (!) on a typical .config. That's more than
> 120K shaved off the vmlinux.
> 
> Why, despite being aware of this bug, you never fixed this properly
> is a mystery to me - this is more .text size savings than you have
> done so far with all your uninlining patches of the past few years
> combined, and it's probably more than you could have achieved in the
> next 5 years.
> 
> 	Ingo
> 
> ---------------------->
> Subject: x86: phase out forced inlining
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon Mar 03 12:38:52 CET 2008
> 
> allow gcc to optimize the kernel image's size by uninlining
> functions that have been marked 'inline'. Previously gcc was
> forced by Linux to always-inline these functions via a gcc
> attribute:
> 
>  #define inline	inline __attribute__((always_inline))
> 
> Especially when the user has already selected
> CONFIG_OPTIMIZE_FOR_SIZE=y this can make a huge difference in
> kernel image size (using a standard Fedora .config):
> 
>    text    data     bss     dec           hex filename
>    5613924  562708 3854336 10030968    990f78 vmlinux.before
>    5486689  562708 3854336  9903733    971e75 vmlinux.after
> 
> that's a 2.3% text size reduction (!).
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig.debug            |   13 +++++++++++++
>  arch/x86/configs/i386_defconfig   |    1 +
>  arch/x86/configs/x86_64_defconfig |    1 +
>  include/linux/compiler-gcc.h      |   12 +++++++++---
>  4 files changed, 24 insertions(+), 3 deletions(-)
> 
> Index: linux-x86.q/arch/x86/Kconfig.debug
> ===================================================================
> --- linux-x86.q.orig/arch/x86/Kconfig.debug


eh.. we ALREADY HAD THIS.
someone seems to have removed this wronly; not forcing inline should have been
the default after the removal (in 2.6.25-rc)!

So lets fix it that way, rather than putting the config option back under a different name.
