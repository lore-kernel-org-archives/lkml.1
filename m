Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZFJP4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZFJP4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZFJP4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:56:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:55300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758709AbZFJP4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:56:45 -0400
Subject: Re: [GIT-PULL -tip] x86: xpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090608083947.GC6372@elte.hu>
References: <1244447882.6943.2.camel@ht.satnam>
	 <20090608083947.GC6372@elte.hu>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 21:27:31 +0530
Message-Id: <1244649451.3295.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Mon, 2009-06-08 at 10:39 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Ingo,
> > 
> > Please pull cpu_debug patches :
> > 
> > The following changes since commit 5095f59bda6793a7b8f0856096d6893fe98e0e51:
> >   Jaswinder Singh Rajput (1):
> >         x86: cpu_debug: Remove model information to reduce encoding-decoding
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git x86/cpu
> > 
> > Jaswinder Singh Rajput (5):
> >       x86: cpu_debug update Kconfig entry
> >       x86: cpu_debug.c remove some not required header files
> >       x86: cpu_debug.c use a WARN_ONCE() instead of a pr_err()
> >       x86: cpu_debug make room to support more categories
> >       x86: cpu_debug update MSR list to support new architectures
> > 
> >  arch/x86/Kconfig                 |   12 ++++-
> >  arch/x86/include/asm/cpu_debug.h |  102 +++++++++++++-------------------------
> >  arch/x86/kernel/cpu/cpu_debug.c  |   45 +++++++++-------
> >  3 files changed, 70 insertions(+), 89 deletions(-)
> > 
> > Complete diff:
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index a6efe0a..cd2debd 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -955,9 +955,19 @@ config X86_CPUID
> >  
> >  config X86_CPU_DEBUG
> >  	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
> > +	select DEBUG_FS
> >  	---help---
> >  	  If you select this option, this will provide various x86 CPUs
> > -	  information through debugfs.
> > +	  information through debugfs. Any user can read these file but writing
> > +	  needs root privilege.
> > +
> > +	  Note: 1. If you compile cpu_debug as a module, it will _not_ be loaded
> > +	  automatically (like usual drivers). You will need to load it manually
> > +	  (or add it to list of modules loaded during boot).
> > +
> > +	  2. You need debugfs, if you want to mount debugfs automatically
> > +	  append this line in /etc/fstab:
> > +	  debugfs	/sys/kernel/debug	debugfs	defaults	0 0
> 
> Those look like good fixes - but before we start extending on all 
> this - a more general question has to be raised: do people find this 
> useful?
> 
> I had a look at the current /debug/x86/cpu*/ layout, and a fair 
> portion of it looks completely meaningless at the moment: there's a 
> lot of hexa fields with absolutely zero symbolic information about 
> what the fields actually mean.
> 
> There's a few good exceptions like /debug/x86/cpu/cpu0/apic/apic or 
> /debug/x86/cpu/cpu0/cr/cr, although even those should probably be 
> renamed to:
> 
>   /debug/x86/cpu/cpu0/apic/state
>   /debug/x86/cpu/cpu0/cr/state
> 
> as 'apic/apic' and 'cr/cr' is meaningless.
> 
> Or better yet, why isnt there a directory structure to known values:
> 
>   /debug/x86/cpu/cpu0/apic/LVTERR/value
> 
> ?
> 
> This would allow the changing/reading of all known values.
> 
> The 'total state' could still be accessed easily as well, via:
> 
>   cat /debug/x86/cpu/cpu0/apic/*/value
> 
> Paradoxically, all the _unknown_ values have a split out per 
> register layout. I.e. the namespace is bloated with a lot of 
> 'unknown' state - while the 'known' (and printed/interpreted) 
> registers are hidden and collected into meaninglessly named files. 
> It should be exactly the other way around.
> 

I tried to fix few of the issues you pointed and send new pull request,
Can you please pull it :

[git-pull -tip] cpu_debug patches 20090610

> All in one, this code either needs to become useful in practice, 
> needs to provide a nice, structured, intuitive 'view' of the CPU's 
> current state (as known to the kernel) - or it should not be done at 
> all.
> 
> If we want a quirky interface we can use msr-tools and /sbin/rdmsr 
> just fine. So /debug/x86/cpu/ really has to become a strikingly 
> intuitive big step forward in terms of CPU state enumeration and 
> visualization, for it to make sense to be carried in the kernel.
> 

I am adding more features in cpu_debug to make it more useful.

Thanks,
--
JSR

