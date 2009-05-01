Return-Path: <linux-kernel-owner+w=401wt.eu-S1751583AbZEAFAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbZEAFAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZEAFAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:00:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZEAFAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:00:06 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping around
Date: Fri, 1 May 2009 10:27:46 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <200904301939.51022.knikanth@novell.com> <20090430144526.10b3039a.akpm@linux-foundation.org>
In-Reply-To: <20090430144526.10b3039a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011027.46754.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009 03:15:26 Andrew Morton wrote:
> On Thu, 30 Apr 2009 19:39:50 +0530
> Nikanth Karthikesan <knikanth@novell.com> wrote:
>
>
>
> If I had a dollar for each wordwrapped patch I get sent...
>

Ah..very sorry, was a bit hasty. Would pay it, when I get to meet you. ;-)

> > Detect and warn on atomic_inc/atomic_dec overflow.
> >
> > Add a debug option to detect and warn when the 32-bit atomic_t overflows
> > during atomic_inc and atomic_dec.
>
> OK.
>
> I'll beef the changelog up a bit - this one is wimpy.
>

Thanks.

> The question is: do we put this in mainline?  I guess we might as well
> give it a shot.  It may well find bugs and it might also trigger false
> positives.  We can then fix the bugs and decide whether the false
> positives warrant reverting it again, all very easy.
>
> > +#include <asm/bug.h>
>
> checkpatch says
>
> WARNING: Use #include <linux/bug.h> instead of <asm/bug.h>
> #215: FILE: include/asm-generic/atomic.h:11:
> +#include <asm/bug.h>
>
> Was this an oversight, or did you try using linux/bug.h and discovered
> some problem?

I tried with linux/bug.h. But it creates a cyclic dependency. linux/bug.h 
pulls in linux/module.h => linux/spinlock.h => asm/spinlock.h (which uses 
atomic_inc) => asm/atomic.h,.

>
> > index 812c282..773c1a4 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -17,6 +17,17 @@ config ENABLE_WARN_DEPRECATED
> >  	  Disable this to suppress the "warning: 'foo' is deprecated
> >  	  (declared at kernel/power/somefile.c:1234)" messages.
> >
> > +config HAVE_ARCH_DEBUG_ATOMIC
> > +	bool
> > +
> > +config ENABLE_WARN_ATOMIC_INC_WRAP
> > +	bool "Enable warning on atomic_inc()/atomic_dec() wrap"
> > +	depends on HAVE_ARCH_DEBUG_ATOMIC
> > +	default y
> > +	help
> > +	  Enable printing a warning when atomic_inc() or atomic_dec()
> > +	  operation wraps around the 32-bit value.
> > +
>
> Yes, I agree with `default y' for now.  But we might want to turn it
> off again later.  Adding that WARN to every atomic_inc/atomic_dec site
> must do terrible things to the kernel text footprint.
>
> Of course, if we make if `default y' for a while and then switch it to
> `default n', the `y' state will linger for a very long time in all the
> kernel developers' .configs.  Good!  Very sneaky.

:)

Thanks
Nikanth
