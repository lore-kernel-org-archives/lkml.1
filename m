Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYCUTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYCUTb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYCUTbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:31:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:35973 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYCUTbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,536,1199692800"; 
   d="scan'208";a="537831029"
Date: Fri, 21 Mar 2008 12:26:46 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 00/13] x86: PAT support updated - v3
Message-ID: <20080321192646.GB23347@linux-os.sc.intel.com>
References: <20080319000012.439150000@intel.com> <20080321132417.GJ27245@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321132417.GJ27245@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 02:24:17PM +0100, Ingo Molnar wrote:
> 
> * venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:
> 
> > Follow up on earlier PAT patch series here: 
> > http://lkml.org/lkml/2008/1/10/312
> > 
> > This patch series adds Page Attribute Table (PAT) support on x86. 
> > There have been few changes based on comments for earlier patches and 
> > also issues that was seen while the earlier patchset was in mm. The 
> > main changes include:
> > 
> > * Unlike earlier patchset, there are no changes to identity mapping of
> >   reserved regions.
> > * Unlike earlier patches, there are no chanegs to early ioremap.
> > * We look at MTRR setting and PAT request and track the resultant type
> >   to avoid aliasing.
> > * UC_MINUS in PAT to provide backward compatibility to /dem/mem mmap users.
> > 
> > In general, we have tried to make patches more simpler and cleaner. 
> > Hope is to cause less disruption along the way. The changes/cleaups 
> > that went into x86/mm (specifically pageattr.c) has helped us along 
> > the way.
> > 
> > The patchset is against x86 testing from couple of days back.
> 
> thanks Venki, i've queued this up so that we can see how well it goes. 
> It now looks a lot less dangerous and more compatible than it did before 
> - but i'm sure there'll be issues nevertheless :-/

I am keeping my fingers crossed. :-)

> > There are two issues that we are leaving out at the moment to make the patch
> > simple. We will be addressing them with incremental patches soon:
> > * FB/DRM drivers using pgprot_val and changing protection on their own
> >   without using any proper APIs like ioremap. There are few such usages and
> >   each one will be addressed separately.
> > * To change attributes from WC to WB in a "perfect way", one has to follow
> >   certain sequence like make page non-present etc.
> 
> hm, until this is done correctly i guess we should disallow WC to WB 
> transitions? A good number of erratas apply i suspect :-/
> 

I think we can support WC in the mean time. Currently we follow the TLB and
cache flushing logic that is there which is a OK solution. I mean, I dont think
there will be nasty hangs etc because of this. We do keep track of the usage
of these mappings and there should not be any thing other than speculative
accesses from other CPUs at the time we change the attribute. So, we are trying
to double check whether the SDM approach is really needed for our usage model.

BTW, suggested solution in SDM says we should make the page "Not Present" first
flush the TLBs and then change the attribute and make it present. This will
potentially involve some changes in page fault handler as well.

Thanks,
Venki
