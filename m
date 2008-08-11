Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYHKS2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYHKS2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYHKS2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:28:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61900 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbYHKS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:28:24 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5357"; a="5316364"
Message-ID: <48A084C8.6050204@qualcomm.com>
Date: Mon, 11 Aug 2008 11:28:24 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jeff.chua.linux@gmail.com,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com> <20080811181642.GS4524@elte.hu>
In-Reply-To: <20080811181642.GS4524@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Max.Krasnyansky@qualcomm.com <Max.Krasnyansky@qualcomm.com> wrote:
> 
>> From: Max Krasnyansky <maxk@qualcomm.com>
>>
>> For some reason we had redundant parsers registered for maxcpus=. One 
>> in init/main.c and another in arch/x86/smpboot.c So I nuked the one in 
>> arch/x86.
>>
>> Also 64-bit kernels used to handle maxcpus= as documented in 
>> Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are 
>> initialized but not booted. 32-bit version for some reason ignored 
>> them even though all the infrastructure for booting them later is 
>> there.
>>
>> In the current mainline both 64 and 32 bit versions are broken. I'm 
>> too lazy to look through git history but I'm guessing it happened as 
>> part of the i386 and x86_64 unification.
> 
> yes in essence. 32-bit always had maxcpus as a hard restriction in the 
> number of CPUs. This got extended to 64-bit as well, via commit 
> 89b08200ad:
> 
>     x86: make x86_64 accept the max_cpus parameter
> 
> in v2.6.25. Two major kernel releases and nobody noticed - it's a rarely 
> used option.
> 
>> This patch restores the correct behaviour. I've tested x86_64 version 
>> on 4- and 8- way Core2 and 2-way Opteron based machines. Various 
>> config combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG. Booted with 
>> maxcpus=1 and maxcpus=4, etc. Everything is working as expected.
>>
>> I cannot test 32-bit version (no 32-bit machines here).
> 
> This will need some test time on 32-bit as that is where this represents 
> a material change. ( albeit what matters most is the maxcpus=1 
> distinction - and for that nosmp can be used as well to turn off 
> multi-cpu support altogether. So we could do this in v2.6.27 as well. )

So far we got a couple of reports that it works as expected on 32 (both laptop
and server/desktop).

> Also, a quick grep shows that your patch will very likely break the 
> visws build:
> 
>  arch/x86/kernel/visws_quirks.c:extern unsigned int __cpuinitdata maxcpus;
>  arch/x86/kernel/visws_quirks.c:        if (ncpus > maxcpus)
>  arch/x86/kernel/visws_quirks.c:                ncpus = maxcpus;
> 
> could you please fix that?

Oh. I missed that one. Will fix.

Max



