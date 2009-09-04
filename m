Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZIDOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZIDOLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZIDOLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:11:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbZIDOLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:11:18 -0400
Date: Fri, 4 Sep 2009 16:11:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] AMD-IOMMU (AMD-Vi) updates for 2.6.32
Message-ID: <20090904141113.GA21026@elte.hu>
References: <20090904100506.GD30765@amd.com> <20090904130645.GB9490@elte.hu> <20090904135644.GB4906@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904135644.GB4906@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> thanks for your comments.
> 
> On Fri, Sep 04, 2009 at 03:06:45PM +0200, Ingo Molnar wrote:
> > +static void dump_dte_entry(u16 devid)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < 8; ++i)
> > +               pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
> > +                       amd_iommu_dev_table[devid].data[i]);
> > 
> > that 8 is not very obvious - it deserves a comment. (we allocate at 
> > least one page to amd_iommu_dev_table[] so it's safe - but where the 
> > 8 comes from is not very clear.)
> 
> Right. I will add a comment.
> 
> > Also, we tend to write 'i++' not '++i' in loops. (there's other 
> > examples of this too in the iommu files)
> 
> Ok, I use ++i for historic reasons from my old c++ times ;-) Is there a
> specific reason i++ is prefered?
> 
> > This log printing pattern:
> > 
> >         printk(KERN_ERR "AMD-Vi: Event logged [");
> > 
> >         switch (type) {
> >         case EVENT_TYPE_ILL_DEV:
> >                 printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
> >                        "address=0x%016llx flags=0x%04x]\n",
> > 
> > is now broken (produces an unexpected newline) due to:
> > 
> >   5fd29d6: printk: clean up handling of log-levels and newlines
> > 
> > you probably want to convert all printk's to pr_*() calls, and use 
> > pr_cont() in the above place.
> 
> Ok, I will chance this too.
> 
> > Similar comments hold for dump_command() as well.
> > 
> > +++ b/arch/x86/include/asm/amd_iommu_types.h
> > @@ -457,4 +457,7 @@ static inline void amd_iommu_stats_init(void) { 
> > }
> >  
> >  #endif /* CONFIG_AMD_IOMMU_STATS */
> >  
> > +/* some function prototypes */
> > +extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
> > +
> > 
> > function prototypes belong into amd_iommu.h, not amd_iommu_types.h.
> 
> The plan is to do it the other way around. Currently amd_iommu.h 
> contains the driver exported function prototypes and the 
> prototypes of functions only shared between amd_iommu_init.c and 
> amd_iommu.c. So my plan is to move the prototypes of the functions 
> only shared between the two driver source files to 
> amd_iommu_types.h. The prototypes I put into source files should 
> all be forward declarations of static functions only. Should these 
> be in header files too?

Well, generally we only put data type definitions and constants into 
*_types.h files. If you need multiple include files for methods i'd 
suggest to split amd_iomm.h into two or so.

	Ingo
