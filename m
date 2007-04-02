Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbXDBMKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbXDBMKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbXDBMKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:10:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:32962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933984AbXDBMKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:10:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH 1/3] Introduce cpuid_on_cpu() and cpuid_eax_on_cpu()
Date: Mon, 2 Apr 2007 14:10:29 +0200
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       cpufreq@lists.linux.org.uk, hpa@zytor.com, davej@codemonkey.org.uk
References: <20070402113831.GA6785@localhost.sw.ru>
In-Reply-To: <20070402113831.GA6785@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021410.29623.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 13:38, Alexey Dobriyan wrote:
> They will be used by cpuid driver and powernow-k8 cpufreq driver.
> 
> With these changes powernow-k8 driver could run correctly on OpenVZ kernels
> with virtual cpus enabled (SCHED_VCPU).

This means openvz has multiple virtual CPU levels? One for cpuid/rdmsr and one
for the rest of the kernel? Both powernow-k8 and cpuid attempt to schedule
to the target CPU so they should already run there. But it is some other CPU,
but when they ask your _on_cpu() functions they suddenly get a "real" CPU?
Where is the difference between these levels of virtualness? 

That sounds quite fragile and will likely break often.  I just rejected a similar 
concept -- virtual nodes and "physical nodes" for similar reasons.

Also it has weird semantics. For example if you have multiple
virtual CPUs mapping to a single CPU then would the powernow-k8 driver
try to set the frequency multiple times on the same physical CPU? That might
go wrong actually because the CPU might not be happy to be poked again
while it is already in a frequency change. Also there is no locking
so in theory two vcpus might try to change frequency in parallel with
probably quite bad effects. 

I'm sure there are other scenarios with similar problems. e.g. what
happens with microcode updates etc.? 

Before adding any hacks like this I think your vcpu concept
needs to be discussed properly on l-k. For me it doesn't look like it is 
something good right now though.

-Andi
