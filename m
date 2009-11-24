Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbZKXDhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbZKXDhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbZKXDhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:37:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:37278 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbZKXDhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:37:35 -0500
Subject: Re: [PATCH v5 0/4] pseries: Add cede support for cpu-offline
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
References: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 14:35:09 +1100
Message-ID: <1259033709.16367.110.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 10:52 +0530, Gautham R Shenoy wrote:
> Hi,
> 
> This is version 5 of patch series that provides a framework to choose the
> state a pseries CPU must be put to when it is offlined.
> 
> Previous versions can be found here:
> Version 4: http://lkml.org/lkml/2009/10/9/59
> Version 3: http://lkml.org/lkml/2009/9/15/164
> Version 2: http://lkml.org/lkml/2009/8/28/102
> Version 1: http://lkml.org/lkml/2009/8/6/236
> 
> Changes from the previous version include:
> - Rebased against Nathan Fontenot's latest "pseries kernel handling of dynamic
>   logical paritioning v4" patches found here:
>   http://lkml.org/lkml/2009/10/21/98

I can't merge them right now because afaik, Nathan patches are still not
quite ready. So we need to either get a final version of Nathan patches
something like tomorrow or you need to rebase your series on current
-next by the end of the week, or I'm afraid it's going to miss the next
merge window.

Cheers,
Ben.

> - Added boot-time option to disable putting the offlined vcpus into an
>   extended H_CEDE state.
> 
> - Addressed Ben's comments regarding the if-else sequencing in
>   pseries_mach_cpu_die().
> 
> - Addition of comments for pseries_cpu_die() to distinguish it from
>   pseries_mach_cpu_die()
> 
> Also,
> 
> - This approach addresses Peter Z's objections regarding layering
>   violations. The user simply offlines the cpu and doesn't worry about what
>   state the CPU should be put into. That part is automatically handled by the
>   kernel.
> 
> - It does not add any additional sysfs interface instead uses the existing
>   sysfs interface to offline CPUs.
> 
> - On platforms which do not have support for ceding the vcpu with a
>   latency specifier value, the offlining mechanism defaults to the current
>   method of calling rtas_stop_self().
> 
> The patchset has been tested on the available pseries platforms and it works
> as per the expectations. I believe that the patch set is ready for inclusion.
> ---
> 
> Gautham R Shenoy (4):
>       pseries: Serialize cpu hotplug operations during deactivate Vs deallocate
>       pseries: Add code to online/offline CPUs of a DLPAR node.
>       pSeries: Add hooks to put the CPU into an appropriate offline state
>       pSeries: extended_cede_processor() helper function.
> 
> 
>  Documentation/cpu-hotplug.txt                   |    6 +
>  arch/powerpc/include/asm/lppaca.h               |    9 +
>  arch/powerpc/platforms/pseries/dlpar.c          |  129 ++++++++++++++++
>  arch/powerpc/platforms/pseries/hotplug-cpu.c    |  182 ++++++++++++++++++++++-
>  arch/powerpc/platforms/pseries/offline_states.h |   18 ++
>  arch/powerpc/platforms/pseries/plpar_wrappers.h |   22 +++
>  arch/powerpc/platforms/pseries/smp.c            |   19 ++
>  arch/powerpc/xmon/xmon.c                        |    3 
>  drivers/base/cpu.c                              |    2 
>  include/linux/cpu.h                             |   13 ++
>  10 files changed, 387 insertions(+), 16 deletions(-)
>  create mode 100644 arch/powerpc/platforms/pseries/offline_states.h
> 


