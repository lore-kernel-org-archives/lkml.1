Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYHMDFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYHMDFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYHMDFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:05:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:42257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYHMDFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,199,1217833200"; 
   d="scan'208";a="325749189"
Subject: Re: [PATCH] kexec jump: fix code size checking
From: Huang Ying <ying.huang@intel.com>
To: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080813024701.GA19201@verge.net.au>
References: <1218589475.24951.59.camel@caritas-dev.intel.com>
	 <20080813024701.GA19201@verge.net.au>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 11:05:15 +0800
Message-Id: <1218596715.24951.69.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 12:47 +1000, Simon Horman wrote:
> On Wed, Aug 13, 2008 at 09:04:35AM +0800, Huang Ying wrote:
> > Fix building issue when CONFIG_KEXEC=n. Thanks to Vivek Goyal for his
> > reminding.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > ---
> >  include/asm-x86/kexec.h |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/include/asm-x86/kexec.h
> > +++ b/include/asm-x86/kexec.h
> > @@ -43,6 +43,9 @@
> >  
> >  #ifdef CONFIG_X86_32
> >  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
> > +# ifndef CONFIG_KEXEC
> > +#  define kexec_control_code_size	0
> > +# endif
> >  #endif
> >  
> >  #ifndef __ASSEMBLY__
> 
> Is it impossible to skip the linker check in the !CONFIG_KEXEC case?

It is possible. I think there are several ways to do that.

1) use #ifdef in vmlinux_32.lds.S, such as:

#ifdef CONFIG_KEXEC
ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
       "kexec control code size is too big")
#endif

2) #define a macro for kexec check ld script in asm/kexec.h, such as:

#define LD_CHECK_KEXEC()	ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE, \
				       "kexec control code size is too big")

and use that in vmlinux_32.lds.S.

3) #define kexec_control_code_size 0. So that the check can be passed
always. And, code size = 0 is reasonable for no code (CONFIG_KEXEC=n).


I think 3) is better. What do you think about?

Best Regards,
Huang Ying


