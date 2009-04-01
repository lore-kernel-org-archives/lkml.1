Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZDAA1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZDAA1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbZDAA1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:27:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:11931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929AbZDAA1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:27:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,304,1235980800"; 
   d="scan'208";a="677658498"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
CC: lkml <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Tue, 31 Mar 2009 17:29:02 -0700
Subject: RE: PAGE_CACHE_WC strikes again
Thread-Topic: PAGE_CACHE_WC strikes again
Thread-Index: AcmyXtbMBMBqd0rfQMivcGihifLNrwAAPTQA
Message-ID: <7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
 <20090331171431.69ad044f@hobbes>
In-Reply-To: <20090331171431.69ad044f@hobbes>
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
>Sent: Tuesday, March 31, 2009 5:15 PM
>To: Eric Anholt
>Cc: lkml; Pallipadi, Venkatesh
>Subject: Re: PAGE_CACHE_WC strikes again
>
>On Tue, 31 Mar 2009 17:10:47 -0700
>Eric Anholt <eric@anholt.net> wrote:
>
>> I just tracked down what was cutting performance 10x on one of my
>> systems on a microbenchmark I'd just written:
>> 
>> --- a/drivers/gpu/drm/drm_gem.c
>> +++ b/drivers/gpu/drm/drm_gem.c
>> @@ -540,7 +540,7 @@ int drm_gem_mmap(struct file *filp, struct
>> vm_area_struct *vma)
>>  	/* FIXME: use pgprot_writecombine when available */
>>  	prot = pgprot_val(vma->vm_page_prot);
>>  #ifdef CONFIG_X86
>> -	prot |= _PAGE_CACHE_WC;
>> +	/*prot |= _PAGE_CACHE_WC;*/
>>  #endif
>>  	vma->vm_page_prot = __pgprot(prot);
>>  
>> Turns out that setting PAGE_CACHE_WC disables the WC effect of the
>> MTRR on my non-PAT (disabled due to CPU errata) 945GM 
>system, and this
>> workaround took GTT-mapped writes from 120MB/s to 1180MB/s.
>
>What the...  There's a pgprot_writecombine now, but it basically does
>the same thing.  Why is WC so broken?  Venki is the fix for this
>covered in your last patchset?
>

The key point here is 

> setting PAGE_CACHE_WC disables the WC effect of the
> MTRR on my non-PAT (disabled due to CPU errata)

When PAT is disabled, the default setting in PAT MSR is
00 - WB
01 - WT
10 - UC_MINUS
11 - UC

There is no way to set WC with PAT. By hardcoding _PAGE_CACHE_WC
(which is 01) the driver is basically selecting write-through!

And when MTRR says WC and PAT says WT, effective type is UC.

Basically, no one should be hard-coding the memory type. Please use
pgprot_writecombine() which does the right thing by using WC
(when PAT is enabled) or UC_MINUS (when PAT is disabled).

Thanks,
Venki