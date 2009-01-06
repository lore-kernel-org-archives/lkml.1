Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZAFTFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZAFTFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZAFTEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:04:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:41864 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZAFTEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:04:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,340,1228118400"; 
   d="scan'208";a="420136768"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Alexey Fisher <bug-track@fisher-privat.net>
CC: "kernel-testers-owner@vger.kernel.org" 
	<kernel-testers-owner@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 Jan 2009 11:05:51 -0800
Subject: RE: [regression] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
Thread-Topic: [regression] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
Thread-Index: AclwL9S0XUgPfvmcQVie5E083/nEuAAALOTg
Message-ID: <7E82351C108FA840AB1866AC776AEC464399F2D6@orsmsx505.amr.corp.intel.com>
References: <4963A71C.2020107@fisher-privat.net> <4963A859.6030406@zytor.com>
In-Reply-To: <4963A859.6030406@zytor.com>
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
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Tuesday, January 06, 2009 10:52 AM
>To: Alexey Fisher
>Cc: kernel-testers-owner@vger.kernel.org; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B; Pallipadi, Venkatesh
>Subject: Re: [regression] glx performance drop with: "x86: 
>PAT: implement track/untrack of pfnmap regions for x86 - v3"
>
>Alexey Fisher wrote:
>> glx perfomance regression after this patch.
>> goot kernel: glxgears = 1400 fps
>> bad kernel: glxgears = 300 fps ( same speed with disabled 
>drm module )
>> 
>> kernel log:
>> glxgears:5775 map pfn expected mapping type write-back for
>> d1000000-d1c80000, got uncached-minus
>> glxgears:5775 freeing invalid memtype d1000000-d1c80000
>> 
>
>Have we caught a case of actual overlap, i.e. a driver bug here?
>

This error is similar to one reported by Kevin here.
http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00970.html
[  111.775378] X:5010 map pfn expected mapping type write-back for d0000000-d0101000, got write-combining
[  111.775456] X:5010 freeing invalid memtype d0000000-d0101000


The sequence seems to be somewhat like this

- Kernel driver sets the whole graphics region to uc-minus or write-combining
- There is a remap_pfn_range() to map a portion of this region to user with "write-back" mapping.

Now there may be a MTRR for this region or there may be none. It will depend on specific system and
whether there were available MTRRs or MTRR setting was possible at all.If there are no MTRR settings,
then we have caught a valid aliasing here.

I have reproduced this problem on a local system here and looking for a sane solution....

Thanks,
Venki