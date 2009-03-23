Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZCWTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZCWTuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZCWTuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:50:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57091 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZCWTuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:50:02 -0400
Date: Mon, 23 Mar 2009 20:48:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error: freeing invalid memtype
Message-ID: <20090323194828.GC29478@elte.hu>
References: <49C03208.6050603@gmail.com> <1237399938.4529.208.camel@localhost.localdomain> <49C572CC.6090704@gmail.com> <20090323190720.GA16831@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323190720.GA16831@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> On Sat, Mar 21, 2009 at 04:05:48PM -0700, Kevin Winchester wrote:
> > Pallipadi, Venkatesh wrote:
> > > Kevin,
> > > 
> > > Can you please send me the output of
> > > # cat /debug/x86/pat_memtype_list
> > > 
> > > (with debugfs mounted at /debug) as soon as you login into X and also
> > > when you start seeing these errors with etracer and glxinfo.
> > > 
> > 
> > Here is the output before attempting to run glxinfo:
> > : :
> > : :
> > 
> > Does that help track down the problem?  I am about to try disabling PAT
> > in my config to see if that fixes things.
> > 
> 
> Can you please try the patch below and let me whether it helps.
> 
> Thanks,
> Venki
> 
> x86, PAT: Change vma prot in pci_mmap to reflect inherited prot
>     
> While looking at the issue in the thread
> http://marc.info/?l=dri-devel&m=123606627824556&w=2
> noticed a bug in pci PAT code and memory type setting.
>     
> pci mmap code did not set the proper protection in vma, when it
> inherited protection in reserve_memtype. This bug only affects
> the case where there exists a WC mapping before X does an mmap
> with /proc or /sys pci interface. This will cause X userlevel
> mmap from /proc or /sysfs to fail on fork.
>     
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 5ead808..f234a37 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
>  			return -EINVAL;
>  		}
>  		flags = new_flags;
> +		vma->vm_page_prot = __pgprot(
> +			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
> +			flags);

If it solves the problem it will be for -stable too, right?

It could be done a bit cleaner i think: is the ~_PAGE_CACHE_MASK 
really needed? Does ->vm_page_prot ever have page frame bits set?

	Ingo
