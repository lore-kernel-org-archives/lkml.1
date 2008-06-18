Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbYFRIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbYFRIme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYFRIm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:42:27 -0400
Received: from stinky.trash.net ([213.144.137.162]:56481 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYFRIm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:42:26 -0400
Message-ID: <4858CA6B.7060109@trash.net>
Date: Wed, 18 Jun 2008 10:42:19 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
       rusty@rustcorp.com.au
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com> <1213611339.2495.11.camel@odie.local> <20080616174948.GB7788@linux-os.sc.intel.com> <1213651283.2495.46.camel@odie.local> <20080617235022.GA23370@linux-os.sc.intel.com>
In-Reply-To: <20080617235022.GA23370@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Simon, Patrick, I am able to reproduce the oops in __switch_to()
> with lguest.  My debug showed that there is atleast one lguest specific
> issue (which should be present in 2.6.25 and before aswell) and it got
> exposed with a kernel oops with the recent fpu dynamic allocation patches.
>
> In addition to the previous possible scenario (with fpu_counter), in the
> presence of lguest, it is possible that the cpu's TS bit it still set and the
> lguest launcher task's thread_info has TS_USEDFPU still set.
>
> This is because of the way the lguest launcher handling the guest's TS bit.
> (look at lguest_set_ts() in lguest_arch_run_guest()). This can result
> in a DNA fault while doing unlazy_fpu() in __switch_to(). This will
> end up causing a DNA fault in the context of new process thats
> getting context switched in (as opossed to handling DNA fault in the context
> of lguest launcher/helper process).
>
> This is wrong in both pre and post 2.6.25 kernels. In the recent
> 2.6.26-rc series, this is showing up as NULL pointer dereferences or
> sleeping function called from atomic context(__switch_to()), as
> we free and dynamically allocate the FPU context for the newly
> created threads. Older kernels might show some FPU corruption for processes
> running inside of lguest.
>
> With the appended patch, my test system is running for more than 50 mins
> now. So atleast some of your oops (hopefully all!) should get fixed.
> Please give it a try. I will spend more time with this fix tomorrow.
>
> Apart from the last hunk(MSR_IA32_SYSENTER_CS changes), I believe
> the below patch is needed for 2.6.25 aswell.
>   

The patch seems to have fixed the problem for me, thanks Suresh.


