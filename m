Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbXCPADQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbXCPADQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXCPADQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:03:16 -0400
Received: from koto.vergenet.net ([210.128.90.7]:44331 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbXCPADP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:03:15 -0400
Date: Fri, 16 Mar 2007 08:48:08 +0900
From: Horms <horms@verge.net.au>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Ian Campbell <Ian.Campbell@xensource.com>, hbabu@us.ibm.com,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070315234807.GB10861@verge.net.au>
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com> <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com> <1173961378.8591.63.camel@localhost.localdomain> <20070315132616.GH6766@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315132616.GH6766@in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 06:56:16PM +0530, Vivek Goyal wrote:
> On Thu, Mar 15, 2007 at 12:22:57PM +0000, Ian Campbell wrote:
> > On Thu, 2007-03-15 at 11:17 +0530, Vivek Goyal wrote:
> > > > > But I think changing this macro might run into issues. It is
> > > > > being used at few places in kernel, for example while loading
> > > > > module. This will essentially mean that we allow loading 64bit
> > > > > x86_64 modules on 32bit i386 systems?
> > 
> > Yes, not sure how I missed that fact...
> > 
> > > Kexec will also not allow loading an x86_64 kernel on a 32bit machine.
> > 
> > For crash kernel only or for regular kexec too?
> > 
> 
> I think for both. One of the possible reasons I think is that one never
> knows is underlying machine has got 64bit extensions or not. So even if
> we load the kernel it will never boot. Secondly, we might not be able to
> handle 64bit address in 32bit kernel/user space?

Perhaps I am miss-understanding what you are saying, but I do
recally kexecing from 32->64 and 64->32 bit kernels on x86_64 hardware.
I can run these checks again if it helps.

> > > So how about something like vmcore_elf_allowed_cross_arch()? Vmcore
> > > code can continue to check elf_check_arch() and if that fails it can
> > > invoke vmcore_elf_allowed_cross_arch() to find out what cross arch are
> > > allowed for vmcore. 
> > 
> > Something like this?
> > 
> > Ian.
> > 
> > ---  
> > 
> > Allow i386 crash kernels to handle x86_64 dumps.
> > 
> > The specific case I am encountering is kdump under Xen with a 64 bit
> > hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit
> > due to the hypervisor but the dump kernel is 32 bit in for maximum
> > compatibility.
> > 
> > It's possibly less likely to be useful in a purely native scenario but
> > I see no reason to disallow it.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> > 
> > diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> > index d960507..523e109 100644
> > --- a/fs/proc/vmcore.c
> > +++ b/fs/proc/vmcore.c
> > @@ -514,7 +514,7 @@ static int __init parse_crash_elf64_headers(void)
> >  	/* Do some basic Verification. */
> >  	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
> >  		(ehdr.e_type != ET_CORE) ||
> > -		!elf_check_arch(&ehdr) ||
> > +		!vmcore_elf_check_arch(&ehdr) ||
> >  		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
> >  		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
> >  		ehdr.e_version != EV_CURRENT ||
> > diff --git a/include/asm-i386/kexec.h b/include/asm-i386/kexec.h
> > index 4dfc9f5..c76737e 100644
> > --- a/include/asm-i386/kexec.h
> > +++ b/include/asm-i386/kexec.h
> > @@ -47,6 +47,9 @@
> >  /* The native architecture */
> >  #define KEXEC_ARCH KEXEC_ARCH_386
> > 
> > +/* We can also handle crash dumps from 64 bit kernel. */
> > +#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
> > +
> 
> Ideal place for this probably should have been arch dependent crash_dump.h
> file. But we don't have one and no point introducing one just for this 
> macro.
> 
> This change looks good to me.

Won't the above change break non i386 archtectures as
vmcore_elf_check_arch_cross isn't defined for them?

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

