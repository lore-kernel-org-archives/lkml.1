Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbXFLMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbXFLMJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXFLMJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:09:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:26568 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbXFLMJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ErjzkjpQT7XD8ZxkpXW32nMGnMEresuhf4Je1GXlP5ZH1GqgBadiy2TJ/3m4onmP3ilurnwuuPaZxrnIMj3TuE8mRpa9hquqch8/Zzfmd4u2whD8w6opzmwAajENihWVqHL4Q09kLGXsMwtI2dDCZ9QAVnFhnFd04GnjS79M+r8=
Message-ID: <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
Date: Tue, 12 Jun 2007 17:39:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix improper .init-type section references
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, "Sam Ravnborg" <sam@ravnborg.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E6BDF.76E4.0078.0@novell.com>
	 <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 6/12/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> > [...]
> > @@ -448,7 +448,7 @@ static void __cpuinit cache_shared_cpu_m
> > -static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
> > +static void __cpuexit cache_remove_shared_cpu_map(unsigned int cpu, int index)
>
> You might've done this because the caller of
> cache_remove_shared_cpu_map() is cache_remove_dev()
> which is __cpuexit. However, cache_remove_dev() itself is called
> from cacheinfo_cpu_callback() which is ... __cpuinit, because it's
> caller cache_sysfs_init() is *definitely* __cpuinit. What a mess ...
>
> device_initcall(cache_sysfs_init):
>
> __cpuinit cache_sysfs_init
>   -> __cpuinit cacheinfo_cpu_callback  <======== PROBLEM
>     -> __cpuexit cache_remove_dev  <======== PROBLEM
>       -> __cpuinit cache_remove_shared_cpu_map
>
> Where cacheinfo_cpu_callback() itself is the callback for the
> cacheinfo_cpu_notifier notifier, which is itself marked __cpuinitdata.
>
> I suspect the __cpuexit-marking of cache_remove_dev() here is totally
> bogus. When !CONFIG_HOTPLUG_CPU, __cpuexit == __exit, and
> __exit simply means that the function can be discarded and ignored
> from being linked in for non-modular (built-in) build of that particular
> module. I'm not sure how the code in question here can ever be built
> as a module, so cache_remove_dev shouldn't be a __cpuexit in the
> first place. But not marking it anything would take us back to the
> modpost warnings. So ... something needs to be done about the
> logic in this whole place ...
>
> I did some more code inspection and found:
>
> The cacheinfo_cpu_notifier itself is called out from _cpu_down() which
> is ... yep, *not* __cpuinit (and obviously *cannot* be so). _cpu_down()
> is called from cpu_down() which is (thankfully!) protected inside
> #ifdef CONFIG_HOTPLUG_CPU, so we've /just about/ escaped trouble
> so far, but another of it's callers is disable_nonboot_cpus() which does
> *not* depend on HOTPLUG_CPU, but is #ifdef'ed inside SUSPEND_SMP
> (gargh!) instead, and ... is _not_ __cpuinit either (obviously, again).

Wait, SUSPEND_SMP again depends on HOTPLUG_CPU, so there
are no issues here in marking cache_remove_dev() __cpuexit
(which effectively simply becomes #ifdef HOTPLUG_CPU) as all
callsites that call out the notifier with CPU_DEAD/FROZEN are also
going to be disabled. [ Ok, looks like using __cpuexit as this kind of
pseudo-#ifdef HOTPLUG_CPU is a standard practice? ]

But modpost will still complain (bogus warning) about calling __exit
from __init (when HOTPLUG_CPU=n) for cacheinfo_cpu_callback()
calling cache_remove_dev(), no?

So I'd guess all the various notifier callback functions in your patch
need to be whitelisted by modpost, as those are __init functions
who can legally reference __exit (when HOTPLUG_CPU=n).
__init_refok can't be used here, so some special whitelisting might
be required, I presume.

Satyam
