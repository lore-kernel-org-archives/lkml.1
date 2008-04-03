Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYDCFtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYDCFtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYDCFtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:49:15 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26468 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755181AbYDCFtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:49:14 -0400
Date: Thu, 3 Apr 2008 14:48:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HugeTLB vs. SH3 cpu
Message-ID: <20080403054849.GB4171@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Nishanth Aravamudan <nacc@us.ibm.com>,
	Nish Aravamudan <nish.aravamudan@gmail.com>,
	Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080401225809.GC32269@cs181133002.pp.htv.fi> <29495f1d0804011626n2399d69aj7566df7f78953458@mail.gmail.com> <20080402080448.GA4171@linux-sh.org> <20080402225556.GI21524@us.ibm.com> <1207181169.23710.84.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207181169.23710.84.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 05:06:09PM -0700, Dave Hansen wrote:
> On Wed, 2008-04-02 at 15:55 -0700, Nishanth Aravamudan wrote:
> > On 02.04.2008 [17:04:48 +0900], Paul Mundt wrote:
> > > On Tue, Apr 01, 2008 at 04:26:14PM -0700, Nish Aravamudan wrote:
> > > Sorting out the mess noted by Adrian is pretty trivial with a
> > > HAVE_HUGETLB_PAGE. How about this?
> > 
> > I'm confused, isn't the following simpler fix equivalent?
> > 
> > Fix sh3 build with HUGETLBFS=y. Only SH4 and SH5 actually support
> > HUGETLB_PAGE (which HUGETLBFS depends on).
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > 
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index d731282..1981f8e 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -978,7 +978,7 @@ config TMPFS_POSIX_ACL
> >  
> >  config HUGETLBFS
> >  	bool "HugeTLB file system support"
> > -	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> > +	depends on X86 || IA64 || PPC64 || SPARC64 || ((CPU_SH4 || CPU_SH5) && MMU) || BROKEN
> 
> Yeah, that's equivalent.  But, you have to draw the line at some point
> on how complex that "depends on" is going to get.  I think you each have
> unique pain tolerances. :)
> 
> Personally, I kinda prefer to break it out per-arch, because that SUPERH
> logic is getting a bit screwy.
> 
> You could also do something like this:
> 
> >  config HUGETLBFS
> >  	bool "HugeTLB file system support"
> > -	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> > +	depends on X86 || IA64 || PPC64 || SPARC64 || SUPERH_HUGETLBFS || BROKEN
> 
> And then:
> 
> config SUPERH_HUGETLBFS
> 	def_bool y
> 	depends on (CPU_SH4 || CPU_SH5) && MMU
> 
> on the arch-specific side.  
> 
SUPERH has the MMU dependence because it's the only one out of that list
of architectures that supports both CONFIG_MMU=y and CONFIG_MMU=n
configurations. The dependence on CONFIG_MMU should be tied in to the
HUGETLBFS dependency directly, which is what my patch did.

The other issue is that the dependencies here are just totally backwards.
the file system has the architecture dependence which enables support for
the hugetlb page feature, while the architectures should simply select
whether they can support the hugetlb pages or not and have the file
system conditionalized on that. A bit more work is needed to have
HUGETLBFS and HUGETLB_PAGE toggling independently of each other without
breaking, but that's certainly the next logical step.
