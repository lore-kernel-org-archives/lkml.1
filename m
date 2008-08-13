Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYHMDtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYHMDtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYHMDtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:49:04 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41017 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbYHMDtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:49:02 -0400
Date: Wed, 13 Aug 2008 13:48:59 +1000
From: Simon Horman <horms@verge.net.au>
To: Huang Ying <ying.huang@intel.com>
Cc: nigel@nigel.suspend2.net, Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kexec jump: fix code size checking
Message-ID: <20080813034857.GA14269@verge.net.au>
References: <1218589475.24951.59.camel@caritas-dev.intel.com> <20080813024701.GA19201@verge.net.au> <1218596715.24951.69.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218596715.24951.69.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 11:05:15AM +0800, Huang Ying wrote:
> On Wed, 2008-08-13 at 12:47 +1000, Simon Horman wrote:
> > On Wed, Aug 13, 2008 at 09:04:35AM +0800, Huang Ying wrote:
> > > Fix building issue when CONFIG_KEXEC=n. Thanks to Vivek Goyal for his
> > > reminding.
> > > 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > 
> > > ---
> > >  include/asm-x86/kexec.h |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > --- a/include/asm-x86/kexec.h
> > > +++ b/include/asm-x86/kexec.h
> > > @@ -43,6 +43,9 @@
> > >  
> > >  #ifdef CONFIG_X86_32
> > >  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
> > > +# ifndef CONFIG_KEXEC
> > > +#  define kexec_control_code_size	0
> > > +# endif
> > >  #endif
> > >  
> > >  #ifndef __ASSEMBLY__
> > 
> > Is it impossible to skip the linker check in the !CONFIG_KEXEC case?
> 
> It is possible. I think there are several ways to do that.
> 
> 1) use #ifdef in vmlinux_32.lds.S, such as:
> 
> #ifdef CONFIG_KEXEC
> ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
>        "kexec control code size is too big")
> #endif
> 
> 2) #define a macro for kexec check ld script in asm/kexec.h, such as:
> 
> #define LD_CHECK_KEXEC()	ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE, \
> 				       "kexec control code size is too big")
> 
> and use that in vmlinux_32.lds.S.
> 
> 3) #define kexec_control_code_size 0. So that the check can be passed
> always. And, code size = 0 is reasonable for no code (CONFIG_KEXEC=n).
> 
> 
> I think 3) is better. What do you think about?

Hi Huang,

I think that 1) with possibly the slight variation of moving
#include <asm/kexec.h> inside #ifdef CONFIG_KEXEC is better
because it avoids introducing kexec_control_code_size,
which is currently only used in arch/x86/kernel/relocate_kernel_32.S
and arch/x86/kernel/vmlinux_32.lds.S, into kexec.h.

/* Link time checks */

#ifdef CONFIG_KEXEC
#include <asm/kexec.h>

ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
       "kexec control code size is too big")
#endif


My second preference would be 3) as it seems simpler than 2).

