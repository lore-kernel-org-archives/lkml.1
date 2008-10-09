Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYJIHI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYJIHI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbYJIHIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:08:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:15838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbYJIHIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,382,1220252400"; 
   d="scan'208";a="625067454"
Date: Thu, 9 Oct 2008 15:06:34 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch]x86: arch_add_memory round up address
Message-ID: <20081009070634.GA12715@sli10-desk.sh.intel.com>
References: <1223530290.30941.9.camel@sli10-desk.sh.intel.com> <86802c440810082304j3274555etb7eca011f7459253@mail.gmail.com> <1223532485.7312.0.camel@sli10-desk.sh.intel.com> <86802c440810082322s4eb7e7e6ib60f68de316b06bc@mail.gmail.com> <20081009062831.GA9024@sli10-desk.sh.intel.com> <86802c440810082340r101f99aem3839d55360451851@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810082340r101f99aem3839d55360451851@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 02:40:34PM +0800, Yinghai Lu wrote:
> On Wed, Oct 8, 2008 at 11:28 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Thu, Oct 09, 2008 at 02:22:50PM +0800, Yinghai Lu wrote:
> >> On Wed, Oct 8, 2008 at 11:08 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> > On Thu, 2008-10-09 at 14:04 +0800, Yinghai Lu wrote:
> >> >> On Wed, Oct 8, 2008 at 10:31 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> >> > Round up address to a page, otherwise the last page isn't mapped.
> >> >> >
> >> >> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> >> >> > ---
> >> >> >  arch/x86/mm/init_64.c |    3 ++-
> >> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >> >
> >> >> > Index: linux/arch/x86/mm/init_64.c
> >> >> > ===================================================================
> >> >> > --- linux.orig/arch/x86/mm/init_64.c    2008-10-09 11:42:33.000000000 +0800
> >> >> > +++ linux/arch/x86/mm/init_64.c 2008-10-09 11:43:22.000000000 +0800
> >> >> > @@ -721,7 +721,8 @@ int arch_add_memory(int nid, u64 start,
> >> >> >        unsigned long nr_pages = size >> PAGE_SHIFT;
> >> >> >        int ret;
> >> >> >
> >> >> > -       last_mapped_pfn = init_memory_mapping(start, start + size-1);
> >> >> > +       last_mapped_pfn = init_memory_mapping(start,
> >> >> > +               round_up(start + size-1, PAGE_SIZE));
> >> >> >        if (last_mapped_pfn > max_pfn_mapped)
> >> >> >                max_pfn_mapped = last_mapped_pfn;
> >> >>
> >> >> should use
> >> >>
> >> >> last_mapped_pfn = init_memory_mapping(start, start + size);
> >> > No, this still can't guarantee page aligned, though this works in my
> >> > test
> >>
> >> who will call arch_add_memory? that should be start and size already
> >> be page aligned.
> > It's memory hotplug. Doing a round up is always ok and safe even it might be already aligned.
> >
> 
> it seems rounding up in that case is wrong...
> 
> if the caller call that funtion with extra half page, you don't need
> map that half page, because you can not use it.
shouldn't we mark such page as reserved and so it will not be used? This is the way we handle hole.
