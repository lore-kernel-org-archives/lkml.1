Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZA2O0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZA2O0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZA2O0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:26:01 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57851 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751135AbZA2O0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:26:00 -0500
Date: Thu, 29 Jan 2009 08:25:57 -0600
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] - UV fix compile error on IA64 & eliminate compiler warning
Message-ID: <20090129142557.GB390@sgi.com>
References: <20090128212104.GA1156@sgi.com> <20090129133308.GE24391@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129133308.GE24391@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 02:33:08PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > 
> > The GRU driver is used on both IA64 & x86.
> > The 2 architectures have different ways of detecting the
> > platform type, ie. whether the platform is a UV system.
> > Although it is possible to reconcile the 2 methods,
> > only one place currently makes the test.
> > 
> > Also eliminate a warning message in uv.h.
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> > 
> > 
> > ---
> >  arch/x86/include/asm/uv/uv.h   |    1 +
> >  drivers/misc/sgi-gru/gru.h     |    2 --
> >  drivers/misc/sgi-gru/grufile.c |    1 +
> >  3 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux/arch/x86/include/asm/uv/uv.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/uv/uv.h	2009-01-28 12:43:27.000000000 -0600
> > +++ linux/arch/x86/include/asm/uv/uv.h	2009-01-28 15:13:58.000000000 -0600
> > @@ -2,6 +2,7 @@
> >  #define _ASM_X86_UV_UV_H
> >  
> >  enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
> > +struct mm_struct;
> 
> hm, why is this needed?

I don't see the error in your tip tree, but I saw the following earlier this week when
compiling in the linux-next tree:

	arch/x86/include/asm/uv/uv.h:16: warning: struct mm_struct declared inside parameter list
	include/asm/uv/uv.h:16: warning: its scope is only this definition or declaration,
						which is probably not what you want

Unfortunately my log does not capture the file that produced this error.
I believe it was from a non-UV file that indirectly included uv.h. It is
possible that subsequent changes have removed the indirect reference.


> 
> >  #define IS_UV()		is_uv_system()
> 
> btw., why is there an ugly IS_UV() macro. All code should be using 
> is_uv_system() and IS_UV() should be removed.

Agree & I plan to do that. I need to add a arch/ia64/include/asm/uv/uv.h
file and hide the uglyness there. IA64 does not used the same method
of determining the platform type. IA64 historically uses:

	ia64_platform_is("uv")

The GRU driver must be supported on both IA64 & x86. I've tried to hide the
platform differences but some are difficult (especially regarding irqs &
vectors).


--- jack
