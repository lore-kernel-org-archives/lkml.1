Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYI1PBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYI1PBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYI1PBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:01:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38441 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbYI1PBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:01:08 -0400
Date: Sun, 28 Sep 2008 10:01:07 -0500
From: Russ Anderson <rja@sgi.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Message-ID: <20080928150106.GA204845@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080926200242.GC138671@sgi.com> <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 09:21:35AM +0800, Huang Ying wrote:
> On Fri, 2008-09-26 at 15:02 -0500, Russ Anderson wrote:
> > Index: linux/include/asm-x86/efi.h
> > ===================================================================
> > --- linux.orig/include/asm-x86/efi.h	2008-09-26 14:13:24.000000000 -0500
> > +++ linux/include/asm-x86/efi.h	2008-09-26 14:13:36.000000000 -0500
> > @@ -49,6 +49,20 @@ extern u64 efi_call5(void *fp, u64 arg1,
> >  extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
> >  		     u64 arg4, u64 arg5, u64 arg6);
> >  
> > +
> > +#ifndef CONFIG_EFI
> > +/*
> > + * IF EFI is not configured, have the EFI calls return -ENOSYS.
> > + */
> > +#define efi_call0(_f)					(-ENOSYS)
> > +#define efi_call1(_f, _a1)				(-ENOSYS)
> > +#define efi_call2(_f, _a1, _a2)				(-ENOSYS)
> > +#define efi_call3(_f, _a1, _a2, _a3)			(-ENOSYS)
> > +#define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
> > +#define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
> > +#define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
> > +#endif /* CONFIG_EFI */
> > +
> >  #define efi_call_phys0(f)			\
> >  	efi_call0((void *)(f))
> >  #define efi_call_phys1(f, a1)			\
> 
> efi_call_virt<n> and efi_call_phys<n> is the API instead of efi_call<n>.

#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)                       \
        efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
                  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))

efi_call_virt6() uses efi.systab->runtime->f.
My call needs to use uv_systab, not efi.systab.

How about something like this?

#define efi_call_uv_virt6(a1, a2, a3, a4, a5, a6)                       \
        efi_call6((void *)(__va(uv_systab.function)), (u64)(a1), (u64)(a2), \
                  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))


> And please put the implementation without CONFIG_EFI defined out of
> 
> #ifdef CONFIG_X86_32
> <...>
> #else
> <...>
> #endif
> 
> Best Regards,
> Huang Ying


-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
