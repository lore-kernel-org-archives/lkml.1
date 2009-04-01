Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZDADQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZDADQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 23:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZDADQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 23:16:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:23588 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbZDADQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 23:16:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,305,1235980800"; 
   d="scan'208";a="443840512"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>
Date: Tue, 31 Mar 2009 20:17:43 -0700
Subject: RE: PAGE_CACHE_WC strikes again
Thread-Topic: PAGE_CACHE_WC strikes again
Thread-Index: AcmyZwIvLQXRHymnTkun15gZMLXhKwAEIyZQ
Message-ID: <7E82351C108FA840AB1866AC776AEC4657F48CB6@orsmsx505.amr.corp.intel.com>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	<20090331171431.69ad044f@hobbes>
	<7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
	<1238547790.27006.7743.camel@localhost.localdomain>
 <20090331181251.46cf95b1@hobbes>
In-Reply-To: <20090331181251.46cf95b1@hobbes>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 
>Sent: Tuesday, March 31, 2009 6:13 PM
>To: Siddha, Suresh B
>Cc: Pallipadi, Venkatesh; Eric Anholt; lkml
>Subject: Re: PAGE_CACHE_WC strikes again
>
>On Tue, 31 Mar 2009 17:03:10 -0800
>Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>> On Tue, 2009-03-31 at 17:29 -0700, Pallipadi, Venkatesh wrote:
>> > The key point here is 
>> > 
>> > > setting PAGE_CACHE_WC disables the WC effect of the
>> > > MTRR on my non-PAT (disabled due to CPU errata)
>> > 
>> > When PAT is disabled, the default setting in PAT MSR is
>> > 00 - WB
>> > 01 - WT
>> > 10 - UC_MINUS
>> > 11 - UC
>> > 
>> > There is no way to set WC with PAT. By hardcoding _PAGE_CACHE_WC
>> > (which is 01) the driver is basically selecting write-through!
>> > 
>> > And when MTRR says WC and PAT says WT, effective type is UC.
>> > 
>> > Basically, no one should be hard-coding the memory type. Please use
>> > pgprot_writecombine() which does the right thing by using WC
>> > (when PAT is enabled) or UC_MINUS (when PAT is disabled).
>> 
>> And the driver should use right API to track the underlying 
>page frame
>> thats getting mapped by this vma, with the corresponding attribute.
>> API's like remap_pfn_range(), vm_insert_pfn() will setup the PTE's
>> aswell as track the pfn's attributes.
>> 
>> API's like set_memory_uc/wc() will explicitly setup the page
>> attributes.
>> 
>> Jesse, As far as I see, the drm GEM fault handler routines don't seem
>> to do any of this. Am I missing something? We need to fix this so
>> that we can avoid potential aliasing issues.
>
>Right, the drm driver code went in before we had pgprot_writecombine.
>Now that it's available we should definitely use it.  I'm not sure
>about the set_memory_* routines though; we create io mappings in
>i915_dma.c at init time, and I thought we took care of things in
>i915_gem.c but we may need updates there.
>

There is one problem of too many single page mappings, most likely
coming from gem vm_insert_pfn. As in this mail
http://marc.info/?l=linux-kernel&m=123845244713183&w=2

The actual 'freeing invalid memtype' is a bug that I still trying
to zero in on. Regardless of that, having so many small WC
mappings in IO region will result it pretty slow vm_insert_pfn.
I think we should switch to io_mapping_create_wc kind of API
where we do bulk reserve and have a vm_insert_pfn_quick().

Thanks,
Venki