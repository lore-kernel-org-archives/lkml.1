Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXCOE6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXCOE6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 00:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965172AbXCOE6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 00:58:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35392 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbXCOE57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 00:57:59 -0400
Date: Thu, 15 Mar 2007 10:25:36 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Horms <horms@verge.net.au>
Cc: Ian Campbell <Ian.Campbell@XenSource.com>, hbabu@us.ibm.com,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070315045536.GA6766@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315014635.GC28396@verge.net.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 10:46:38AM +0900, Horms wrote:
> On Wed, Mar 14, 2007 at 05:00:09PM +0000, Ian Campbell wrote:
> > The specific case I am encountering is kdump under Xen with a 64 bit
> > hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit due
> > to the hypervisor but the dump kernel is 32 bit to match the domain 0
> > kernel.
> > 
> > It's possibly less likely to be useful in a purely native scenario but I
> > see no reason to disallow it.
> 
> For native Linux, would this cover the case where the pre-crash kernel
> is 64bit and the crashdump (post-crash) kernel is 32bit?
> 

I think so. Though I have never tried this.

> > Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> > 
> > --- pristine-linux-2.6.18/include/asm-i386/elf.h	2006-09-20 04:42:06.000000000 +0100
> > +++ linux-2.6.18-xen/include/asm-i386/elf.h	2007-03-14 16:42:30.000000000 +0000
> > @@ -36,7 +36,7 @@
> >   * This is used to ensure we don't load something for the wrong architecture.
> >   */
> >  #define elf_check_arch(x) \
> > -	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
> > +	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486) || ((x)->e_machine == EM_X86_64))

But I think changing this macro might run into issues. It is being used at
few places in kernel, for example while loading module. This will essentially
mean that we allow loading 64bit x86_64 modules on 32bit i386 systems?

Similarly, load_elf_interp() is using it, again will we allow loading a 
interp written for X86_64 on a 32bit i386 machine?

Should we create a separate macro something like elf_check_allowed_arch(),
to take care of such corner cases?

Thanks
Vivek
