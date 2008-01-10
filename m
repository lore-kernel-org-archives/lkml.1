Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYAJV5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYAJV5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAJV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:57:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:42168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYAJV5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:57:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,268,1196668800"; 
   d="scan'208";a="320836124"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Thu, 10 Jan 2008 13:57:42 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A2958@orsmsx423.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.1.00.0801101303570.3148@woody.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Thread-Index: AchTzQQM9ET4C+YSSV23SvMrn07XeQABfJFw
References: <20080110184840.927409000@intel.com> <20080110184854.787474000@intel.com> <alpine.LFD.1.00.0801101303570.3148@woody.linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <ak@muc.de>, <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <gregkh@suse.de>, <airlied@skynet.ie>, <davej@redhat.com>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       <arjan@infradead.org>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 21:56:51.0455 (UTC) FILETIME=[B4ADC0F0:01C853D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Linus Torvalds [mailto:torvalds@linux-foundation.org] 
>Sent: Thursday, January 10, 2008 1:05 PM
>To: Pallipadi, Venkatesh
>Cc: ak@muc.de; ebiederm@xmission.com; rdreier@cisco.com; 
>gregkh@suse.de; airlied@skynet.ie; davej@redhat.com; 
>mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
>akpm@linux-foundation.org; arjan@infradead.org; Barnes, Jesse; 
>davem@davemloft.net; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 02/11] PAT x86: Map only usable memory in 
>x86_64 identity map and kernel text
>
>
>
>On Thu, 10 Jan 2008, venkatesh.pallipadi@intel.com wrote:
>>
>> x86_64: Map only usable memory in identity map. All reserved 
>memory maps to a
>> zero page.
>
>I don't mind this horribly per se, but why a zero page?
>
>Accessing that page without mapping it explicitly would be a bug with 
>your change - if only because you'd get the wrong value!
>
>So why map it at all? The only thing mapping it can do is to hide bugs.
>

Yes. I had those pages not mapped at all earlier. The reason I switched
to zero page is to continue support cases like:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)

In this case if some one does a dd of /dev/mem before they can read the
contents of usable memory in 0x100000-0xcff60000 range. But, if I not
map reserved regions, dd will stop after fist such hole. Even though
this may not be a good usage model, I thought there may be apps
depending on such things. Having said that, I do not like having dummy
zero page there very much. So, if we do not see any regressions due to
usages like above, I will be happy to remove mapping reserved regions
altogether.

Thanks,
Venki
