Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbYCUSwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbYCUSwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbYCUSwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:52:42 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:42318 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbYCUSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:52:42 -0400
Date: Fri, 21 Mar 2008 11:52:25 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, shai@scalex86.org
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched TSC's on multiboard vSMP systems
Message-ID: <20080321185225.GA23139@localdomain>
References: <20080320073740.GA9414@localdomain> <20080320074508.GE9414@localdomain> <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com> <20080320190240.GB6085@localdomain> <20080321091542.GE20420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321091542.GE20420@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 10:15:42AM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> >>  -       if (!is_vsmp_box() && (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
>> >>  +       if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
>> >>                 return 0;
>
>> Yes.  The first call is to state that TSC's are synced if it is an AMD 
>> box and if it is _not_ a vSMPowered box (for the apic id lifting case 
>> on Sun boxes), the second call is for _any_ vSMPowered system with 
>> more than one board -- TSC's are not guaranteed to be synched in that 
>> case.  Both these calls are needed.
>
>i suspect there are two questions here: firstly, your change only flips 
>the condition around which should not have any effect _normally_. But 
>the thing is that is_vsmp_box() has side-effects: it reads the PCI 
>config space and sets a flag. It would be cleaner if there was a 
>separate, explicit detect_vsmp_box() call early during bootup which did 
>the PCI config space access, and is_vsmp_box() would only return the 
>current state of the vsmp flag. Then your above change would be 
>unnecessary.

The above change -- the flipping of conditions -- is not _really_ necessary.
The condition and call is needed however.  The flip was done while
experimenting with the patch, since most vSMPowered machines today are mostly
intel, the call to is_vsmp_box() could be avoided here on intel boxes.
However this is only a trivial micro-optimization, as, we call
is_vsmp_box() again even for intel boxes now.

As for the observation about probing the pci space early during the bootup,
we call vsmp_init() much earlier during the bootup, which calls is_vsmp_box(),
does the pci probing and caches the result in the flag,  as you suggest.
So the call in the above diff context does not access the pci config space
as is.

Thanks,
Kiran
