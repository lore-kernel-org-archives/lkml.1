Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYF0Nmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYF0Nmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYF0Nml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:42:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbYF0Nmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:42:40 -0400
Date: Fri, 27 Jun 2008 09:42:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
	automatically
Message-ID: <20080627134212.GC5801@redhat.com>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de> <20080627133256.GB5801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627133256.GB5801@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 09:32:56AM -0400, Vivek Goyal wrote:
> On Thu, Jun 26, 2008 at 09:54:08PM +0200, Bernhard Walle wrote:
> > This patch removes the need of the crashkernel=...@offset parameter to define
> > a fixed offset for crashkernel reservation. That feature can be used together
> > with a relocatable kernel where the kexec-tools relocate the kernel and
> > get the actual offset from /proc/iomem.
> > 
> > The use case is a kernel where the .text+.data+.bss is after 16M physical
> > memory (debug kernel with lockdep on x86_64 can cause that) which caused a
> > major pain in autoconfiguration in our distribution.
> > 
> > Also, that patch unifies crashdump architectures a bit since IA64 has
> > that semantics from the very beginning of the kdump port.
> > 
> > Please provide feedback!
> > 
> 
> Hi Bernhard,
> 
> This looks like a good idea. That means distributions don't have to
> hardcode the crashbase at 16MB and the decision to find a free memory
> can be left on kernel. Users will also find it easy that way.
> 
> > 
> > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> > ---
> >  arch/x86/kernel/setup.c |   70 +++++++++++++++++++++++++++++++++++------------
> >  1 files changed, 52 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index a81d82c..c30bb7b 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -435,6 +435,34 @@ static inline unsigned long long get_total_mem(void)
> >  }
> >  
> >  #ifdef CONFIG_KEXEC
> > +
> > +/**
> > + * Reserve @size bytes of crashkernel memory at any suitable offset.
> > + *
> > + * @size: Size of the crashkernel memory to reserve.
> > + * Returns the base address on success, and -1ULL on failure.
> > + */
> > +unsigned long long find_and_reserve_crashkernel(unsigned long long size)
> > +{
> > +	const unsigned long long alignment = 16<<20; 	/* 16M */
> > +	unsigned long long start = 0LL;
> > +
> > +	while (1) {
> > +		int ret;
> > +
> > +		start = find_e820_area(start, ULONG_MAX, size, alignment);
> > +		if (start == -1ULL)
> > +			return start;
> > +
> > +		/* try to reserve it */
> > +		ret = reserve_bootmem_generic(start, size, BOOTMEM_EXCLUSIVE);
> > +		if (ret >= 0)
> > +			return start;
> > +
> > +		start += alignment;
> > +	}
> 
> I think both i386 and x86_64 relocatable kernels had some upper limits
> where these could be loaded (Eric had mentioned those in the patch. I
> don't remember these). It might be a good idea to capture it here
> making sure "start" does not cross those limits otherwise don't reserve
> the memory.
> 

Thinking more about. Let me step back. I think it is not good idea to
take this kernel take decision about the capability of kernel being
loaded. There is no way we can find out now that if a kernel is capable
of running from this memory location or not. This is highly variable. So,
please ignore above comment.

This patch looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
