Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbYG2WjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbYG2WjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYG2WjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:39:05 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51612 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbYG2WjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:39:04 -0400
Date: Wed, 30 Jul 2008 08:39:00 +1000
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-ia64@vger.kernel.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] kdump: add is_vmcore_usable() and vmcore_unusable()
Message-ID: <20080729223859.GD6370@verge.net.au>
References: <20080729081235.293361145@vergenet.net> <20080729081629.522008269@vergenet.net> <20080729151533.GP25975@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729151533.GP25975@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 11:15:33AM -0400, Vivek Goyal wrote:
> On Tue, Jul 29, 2008 at 06:12:37PM +1000, Simon Horman wrote:
> > The usage of elfcorehdr_addr has changed recently
> > such that being set to ELFCORE_ADDR_MAX is used by
> > is_kdump_kernel() to indicate if the code is executing
> > in a kernel executed as a crash kernel.
> > 
> > However, arch/ia64/kernel/setup.c:reserve_elfcorehdr will
> > rest elfcorehdr_addr to ELFCORE_ADDR_MAX on error,
> > which means any subsequent calls to is_kdump_kernel()
> > will return 0, even though they should return 1.
> > 
> > Ok, at this point in time there are no subsequent calls,
> > but I think its fair to say that there is ample scope for error
> > or at the very least confusion.
> > 
> > This patch add an extra state, ELFCORE_ADDR_ERR, which
> > indicates that elfcorehdr_addr was passed on the command line,
> > and thus execution is taking place in a crashdump kernel,
> > but vmcore can't be used for some reason. This is tested
> > for using is_vmcore_usable() and set using vmcore_unusable().
> > A subsequent patch makes use of this new code.
> > 
> > To summarise, the states that elfcorehdr_addr can now be in are as follows:
> > 
> > ELFCORE_ADDR_MAX: not a crashdump kernel
> > ELFCORE_ADDR_ERR: crashdump kernel but vmcore is unusable
> > any other value:  crash dump kernel and vmcore is usable
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > 
> > Index: linux-2.6/include/linux/crash_dump.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/crash_dump.h	2008-07-29 17:27:43.000000000 +1000
> > +++ linux-2.6/include/linux/crash_dump.h	2008-07-29 17:53:13.000000000 +1000
> > @@ -8,6 +8,7 @@
> >  #include <linux/proc_fs.h>
> >  
> >  #define ELFCORE_ADDR_MAX	(-1ULL)
> > +#define ELFCORE_ADDR_ERR	(-2ULL)
> >  
> >  #ifdef CONFIG_PROC_VMCORE
> >  extern unsigned long long elfcorehdr_addr;
> > @@ -36,5 +37,30 @@ static inline int is_kdump_kernel(void)
> >  static inline int is_kdump_kernel(void) { return 0; }
> >  #endif /* CONFIG_CRASH_DUMP */
> >  
> > +#ifdef CONFIG_PROC_VMCORE
> > +/* is_vmcore_usable() checks if the kernel is booting after a panic and
> > + * the vmcore region is usable.
> > + *
> > + * This makes use of the fact that due to alignment 1 is not
> > + * a valid pointer, much in the vain of IS_ERR(), except
> > + * dealing directly with an unsigned long long rather than a pointer.
> > + */
> > +
> > +static inline int is_vmcore_usable(void)
> > +{
> > +	return is_kdump_kernel() && elfcorehdr_addr != ELFCORE_ADDR_ERR ? 1 : 0;
> > +}
> > +
> > +/* vmcore_unusable() marks the vmcore as unusable, without disturbing
> > + * the logic of is_kdump_kernel()
> > + */
> > +
> > +static inline void vmcore_unusable(void)
> > +{
> > +	if (!is_kdump_kernel())
> > +		elfcorehdr_addr = ELFCORE_ADDR_ERR;
> > +}
> 
> Hi Simon,
> 
> Should above condition be "if(is_kdump_kernel())" instead of
> "if(!is_kdump_kernel())?
> 
> I would think that you would like to mark a vmcore unusable only if, to 
> begin with you were booting after a panic.
> 
> If we being marking vmcore_unusable in case of normal kernel
> (!is_kdump_kernel()), then is_kdump_kernel() will start reporting
> normal kernel as kdump kernel?

Yes, you are correct. Sorry for the silly mistake. I'll repost with

if (!is_kdump_kernel())
	...

-- 
Horms

