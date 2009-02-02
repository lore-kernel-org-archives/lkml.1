Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZBBOKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZBBOKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZBBOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:10:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZBBOKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:10:02 -0500
Subject: Re: [PATCH] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
From: Steven Rostedt <srostedt@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233534919.18767.69.camel@pasglop>
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru>
	 <1233534919.18767.69.camel@pasglop>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 02 Feb 2009 09:04:15 -0500
Message-Id: <1233583455.16878.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-02-02 at 11:35 +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2009-01-31 at 22:06 +0300, Anton Vorontsov wrote:
> > According to this discussion:
> > 
> > http://lkml.org/lkml/2008/7/25/338
> > http://lkml.org/lkml/2008/7/26/72
> > 
> > Frame pointers do nothing useful on PowerPC, so lib/Kconfig.debug
> > makes CONFIG_FRAME_POINTER unselectable on PPC targets. But ftrace.h
> > requires CONFIG_FRAME_POINTER for CALLER_ADDR macros. Therefore
> > tracing is completely useless on PowerPC:
> 
> But we need them for -pg which ftrace uses no ? (ie, gcc forces you to
> have -fno-omit-frame-pointers with -fpg iirc).

Yes, ftrace function tracing requires -pg which requires FRAME_POINTER
turned on.

> 
> Now, regardless, I agree that on PPC, __builtin_return_address() should
> always work with our without that cruft, so we may as well apply that
> patch...
> 
> > [...]
> >   <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1733:120:S mvtsd
> >   <idle>-0       0X.h3    9us+: 0 (0)
> >   <idle>-0       0X..3   72us : 0 (0)
> >   <idle>-0       0X..3   73us :      0:140:R ==> [000]  1733:120:R mvtsd
> > 
> > On PPC we can safely use __builtin_return_address(1..6) w/o frame
> > pointers, and with this patch the trace output looks OK:
> > 
> > [...]
> >   <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1740:120:S mvtsd
> >   <idle>-0       0X.h3    9us+: hrtimer_wakeup (__run_hrtimer)
> >   <idle>-0       0X..3   87us : cpu_idle (__got2_end)
> >   <idle>-0       0X..3   89us :      0:140:R ==> [000]  1740:120:R mvtsd
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> > 
> > Btw, on PowerPC tracing is also broken w/o "ring-buffer: fix alignment
> > problem" patch (currently collecting dust in the -tip tree, commit
> > 082605de5f82eb692cc90f7fda071cc01bb5ac34). Any chance the fix go into
> > Linus' tree, to not waste other people's time bisecting and debugging
> > the problem? ;-)
> > 
> > For google: tracing, regression, "ring-buffer: move some metadata
> > into buffer page", commit abc9b56d66fbd4d93302ef4bf6fa726e1b8255f9,
> > answer is here.
> > 
> >  include/linux/ftrace.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 9c5bc6b..13eba02 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -146,7 +146,7 @@ static inline void __ftrace_enabled_restore(int enabled)
> >  #endif
> >  }
> >  
> > -#ifdef CONFIG_FRAME_POINTER
> > +#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_PPC)

Perhaps we should add a HAVE_NORMAL_FRAME_POINTERS in 
arch/powerpc/Kconfig under PPC and then we can change the above line to:

#if defined(CONFIG_FRAME_POINTERS) || \
		defined(CONFIG_HAVE_NORMAL_FRAME_POINTERS)

This way when another arch wants to belong to this, we do not need to
have a list of archs here.

-- Steve

> >  /* TODO: need to fix this for ARM */
> >  # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> >  # define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> 

