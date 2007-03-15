Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXCOIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXCOIEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXCOIEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 04:04:37 -0400
Received: from koto.vergenet.net ([210.128.90.7]:42868 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXCOIEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 04:04:35 -0400
Date: Thu, 15 Mar 2007 17:00:24 +0900
From: Horms <horms@verge.net.au>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Ian Campbell <Ian.Campbell@XenSource.com>, hbabu@us.ibm.com,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070315080023.GA4366@verge.net.au>
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com> <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315054726.GC6766@in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:17:26AM +0530, Vivek Goyal wrote:
> On Thu, Mar 15, 2007 at 02:07:56PM +0900, Horms wrote:
> > On Thu, Mar 15, 2007 at 10:25:36AM +0530, Vivek Goyal wrote:
> > > On Thu, Mar 15, 2007 at 10:46:38AM +0900, Horms wrote:
> > > > On Wed, Mar 14, 2007 at 05:00:09PM +0000, Ian Campbell wrote:
> > > > > The specific case I am encountering is kdump under Xen with a 64 bit
> > > > > hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit due
> > > > > to the hypervisor but the dump kernel is 32 bit to match the domain 0
> > > > > kernel.
> > > > > 
> > > > > It's possibly less likely to be useful in a purely native scenario but I
> > > > > see no reason to disallow it.
> > > > 
> > > > For native Linux, would this cover the case where the pre-crash kernel
> > > > is 64bit and the crashdump (post-crash) kernel is 32bit?
> > > > 
> > > 
> > > I think so. Though I have never tried this.
> > > 
> > > > > Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> > > > > 
> > > > > --- pristine-linux-2.6.18/include/asm-i386/elf.h	2006-09-20 04:42:06.000000000 +0100
> > > > > +++ linux-2.6.18-xen/include/asm-i386/elf.h	2007-03-14 16:42:30.000000000 +0000
> > > > > @@ -36,7 +36,7 @@
> > > > >   * This is used to ensure we don't load something for the wrong architecture.
> > > > >   */
> > > > >  #define elf_check_arch(x) \
> > > > > -	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
> > > > > +	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486) || ((x)->e_machine == EM_X86_64))
> > > 
> > > But I think changing this macro might run into issues. It is being used at
> > > few places in kernel, for example while loading module. This will essentially
> > > mean that we allow loading 64bit x86_64 modules on 32bit i386 systems?
> > > 
> > > Similarly, load_elf_interp() is using it, again will we allow loading a 
> > > interp written for X86_64 on a 32bit i386 machine?
> > > 
> > > Should we create a separate macro something like elf_check_allowed_arch(),
> > > to take care of such corner cases?
> > 
> > That sounds reasonable to me. Though perhaps it could just be
> > kexec_elf_check_arch() for now, as I don't think there are any
> > other consumers of it.
> 
> Kexec will also not allow loading an x86_64 kernel on a 32bit machine.
> So how about something like vmcore_elf_allowed_cross_arch()? Vmcore code
> can continue to check elf_check_arch() and if that fails it can invoke
> vmcore_elf_allowed_cross_arch() to find out what cross arch are allowed
> for vmcore.

That sounds a little messy, though perhaps it is a good solution anyway.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

