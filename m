Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYKTXmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYKTXmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYKTXmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:42:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:21868 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYKTXmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:42:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="641758755"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Thu, 20 Nov 2008 15:42:32 -0800
Subject: RE: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Thread-Topic: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Thread-Index: AclJxfrIQxep9e0+TrGnqa9+M8T4nwBo0gWg
Message-ID: <7E82351C108FA840AB1866AC776AEC4642A9C879@orsmsx505.amr.corp.intel.com>
References: <20081112212647.259698000@intel.com>
 <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de>
 <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com>
 <20081113034425.GA23434@wotan.suse.de>
 <7E82351C108FA840AB1866AC776AEC4642775AF2@orsmsx505.amr.corp.intel.com>
 <20081114020547.GA24414@wotan.suse.de>
 <7E82351C108FA840AB1866AC776AEC46427EC16C@orsmsx505.amr.corp.intel.com>
 <20081117023019.GB1943@wotan.suse.de> <20081118213735.GB28825@elte.hu>
In-Reply-To: <20081118213735.GB28825@elte.hu>
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
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ingo Molnar
>Sent: Tuesday, November 18, 2008 1:38 PM
>To: Nick Piggin
>Cc: Pallipadi, Venkatesh; Thomas Gleixner; H Peter Anvin; Hugh 
>Dickins; Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; 
>Arjan van de Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
>
>
>* Nick Piggin <npiggin@suse.de> wrote:
>
>> On Fri, Nov 14, 2008 at 01:35:38PM -0800, Pallipadi, Venkatesh wrote:
>> > 
>> > 
>> > >-----Original Message-----
>> > >From: Nick Piggin [mailto:npiggin@suse.de]
>> > >Sent: Thursday, November 13, 2008 6:06 PM
>> > >To: Pallipadi, Venkatesh
>> > >Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Hugh Dickins;
>> > >Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de
>> > >Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
>> > >Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in 
>vm_insert_pfn
>> > >
>> > >On Thu, Nov 13, 2008 at 10:47:23AM -0800, Pallipadi, 
>Venkatesh wrote:
>> > >>
>> > >> Yes. It does. But, it calls a lower level insert_pfn()
>> > >function. The lower
>> > >> level insert_pfn() does not have any bug checks. But 
>the higher level
>> > >> vm_insert_pfn() checks for PFNMAP or MIXEDMAP.
>> > >
>> > >Yes, but is there anything extra you need to check for 
>cache aliases in
>> > >MIXEDMAP mappings?
>> > >
>> > 
>> > Yes. We need additional things to track MIXEDMAP and we 
>are looking at that.
>> > But, that is slightly more trickier than the general 
>PFNMAP case. And
>> > only in-tree user of MIXEDMAP is xip and that too it only 
>uses it for
>> > regular WB mapping. So, we thought we should fix the more 
>common case
>> > first here.
>> > 
>> > With MIXEDMAP there is no way whether to distinguish 
>whether insert_pfn
>> > Or insert_page was used while looking at VMA. We can 
>probably use PFNMAP
>> > in addition to MIXEDMAP to indicate that, which will make 
>things easier.
>> 
>> It's difficult because it can have either method for a 
>single VMA, and
>> a given address in the vma may even change over time (not 
>with current
>> code in kernel AFAIKS, but AXFS eventually might get to that point).
>> 
>> 
>> > But, we are still looking at that and trying to understand 
>the change
>> > implication.
>> 
>> OK: now I understand correctly. Getting PFNMAP working is an 
>important
>> first step. I agree.
>
>Venki, a patch logistics sidenote: the final mm/* bits of this 
>patchset need acks from MM folks - Andrew, Nick or Hugh - we cannot 
>just queue them up in the x86/pat tree without agreement from MM 
>maintainers.
>

OK. Feedback based on the discussions on this patchset, this particular patch
set VM_PFNMAP flag in vm_insert_pfn
is not really needed and we should rather BUG_ON on that not being set. 
And there were few more comments on one other generic vm patch from Nick.

I will resend the entire patchset with changes soon and then we can work
out the logistics.

Thanks,
Venki