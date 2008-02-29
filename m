Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbYB2RPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbYB2RPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbYB2RPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:15:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbYB2RO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:14:59 -0500
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080229114943.GA1909@mailshack.com>
References: <20080224174605.GA21661@mailshack.com>
	 <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
	 <20080229114943.GA1909@mailshack.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 17:14:07 +0000
Message-Id: <1204305247.2037.2.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 12:49 +0100, Alexander van Heukelum wrote:
> This patch adds explicit detection of the EBDA and reservation
> of the rom and adapter address space 0xa0000-0x100000 to the
> i386 kernels. It uses reserve_bootmem instead of reserve_early,
> because reserve_early is not yet available on i386.
> 
> Before this patch, the EBDA size was hardcoded as 4Kb. Also, the 
> reservation of the adapter range was done by modifying the e820
> map which is now not necessary any longer, and the code is removed
> from copy_e820_map.
> 
> The changes in e820_64.c are only a change in the comment above
> copy_e820_map, and some changes of the types of local variables
> in that function such that the 32 and 64 bit versions become equal.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
> 
> On Thu, Feb 28, 2008 at 09:09:56PM +0000, Ian Campbell wrote:
> > On Thu, 2008-02-28 at 14:13 +0100, Alexander van Heukelum wrote:
> > > The 32-bit code still uses reserve_bootmem, so this is not really
> > > a unification with the 64-bit version of the ebda reservation code,
> > > but at least it provides the same detection logic and reserves the
> > > same areas.
> > > 
> > > This does not crash immediately on qemu. No further testing was
> > > done! Otherwise:
> > 
> > I haven't tested extensively either but it does seem to solve the
> > problem for Xen.
> > 
> > Thanks!
> > Ian
> 
> Thank you!
> 
> Ingo,
> 
> I think this is ready for -x86#testing.
> It boots to a small userspace in qemu (i386).
> If I should separate the cleanups, let me know.

	I haven't investigated in any detail, but with 2.6.25-rc3 and your
patch I'm seeing a Xen guest hit this BUG:

void __init smp_alloc_memory(void)
{
        trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
        /*                                                                      
         * Has to be in very low memory so we can execute                       
         * real-mode AP code.                                                   
         */
        if (__pa(trampoline_base) >= 0x9F000)
                BUG();
}

	Stack looks like:

  [<c137ef97>] smp_alloc_memory+0x25  <--
  [<c137ef97>] smp_alloc_memory+0x25 
  [<c137a500>] setup_arch+0x28e 
  [<c13735f7>] start_kernel+0x7a 
  [<c1379240>] xen_start_kernel+0x300 

Cheers,
Mark.

