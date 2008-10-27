Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbYJ0WmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbYJ0WmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYJ0WmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:42:14 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24234 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0WmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:42:13 -0400
Subject: Re: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20081015234842.GA10999@elte.hu>
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu>
Content-Type: text/plain
Organization: Contractor at HP
Date: Mon, 27 Oct 2008 16:42:21 -0600
Message-Id: <1225147341.2215.401.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 23:48 +0000, Ingo Molnar wrote:
> (Cc:-ed the GART folks.)

Are there any objections to this patch?  The problem has been reproduced
in 2.6.18 and 2.6.27, so existing changes in the gart code have not
addressed it. 

The patch disarms a landmine left behind for the kdump kernel.  You
could leave it there and warn people not to step there, or you can
disarm it so it isn't a danger.

Thank you,
Bob Montgomery
    
> 
> * Bob Montgomery <bob.montgomery@hp.com> wrote:
> 
> > This patch prevents improper access of the GART aperture from kdump
> > kernels running on AMD systems.
> >
> > Symptoms of the problem include hangs, spurious restarts, and MCE
> > (Machine Check Exception) panics in some AMD Opteron systems that
> > enable the GART IOMMU and access /proc/vmcore or /dev/oldmem from a
> > kdump kernel.  Note that the GART IOMMU will not be enabled on systems
> > with less than 4 GB of RAM, so symptoms will not appear.  This problem
> > has been reproduced on Family 10H Quad-Core AMD Opteron systems.
> >
> > This patch changes the initialization of the GART to set the
> > DISGARTCPU bit in the GART Aperture Control Register
> > (AMD64_GARTAPERTURECTL). Setting the bit prevents requests from the
> > CPUs from accessing the GART.  In other words, CPU memory accesses to
> > the aperture address range will not cause the GART to perform an
> > address translation. The aperture area is currently being unmapped at
> > the kernel level with set_memory_np() in gart_iommu_init to prevent
> > accesses from the CPU, but that kernel level unmapping is not in
> > effect in the kexec'd kdump kernel.  By disabling the CPU-side
> > accesses within the GART, which does persist through the kexec of the
> > kdump kernel, the kdump kernel is prevented from interacting with the
> > GART during accesses to the dump memory areas which include the
> > address range of the GART aperture.  Although the patch can be applied
> > to the kdump kernel, it is not exercised there because the kdump
> > kernel doesn't attempt to initialize the GART, since it typically runs
> > in less than 4 GB of memory.
> >
> > Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
> >
> >
> > --- linux-2.6.27/include/asm-x86/gart.h       2008-10-13 16:36:34.000000000 -0600
> > +++ linux-2.6.27-fix/include/asm-x86/gart.h   2008-10-14 10:37:32.000000000 -0600
> > @@ -44,7 +44,8 @@ static inline void enable_gart_translati
> >          /* Enable GART translation for this hammer. */
> >          pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
> >          ctl |= GARTEN;
> > -        ctl &= ~(DISGARTCPU | DISGARTIO);
> > +        ctl |= DISGARTCPU;
> > +        ctl &= ~(DISGARTIO);
> >          pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
> >  }
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

