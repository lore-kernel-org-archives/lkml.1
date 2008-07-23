Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYGWRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYGWRSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYGWRSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:18:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbYGWRSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:18:43 -0400
Message-Id: <20080723171841.815234000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 23 Jul 2008 10:18:41 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is submitted to resolve this problem...

(Based on tip/master.  I will generate a linux-next version if requested
since it now has generic code that will be executed for non-x86 arch's.)

> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> >> > > I wouldn't mind it at all, and since it's almost always calling a 
> >> > > function that requires a cpumask_t pointer (like the cpu_* ops or 
> >> > > set_cpus_allowed_ptr) then there shouldn't be too many "pointer 
> >> > > dereference" penalties.  I'm just always a bit hesitant to make too 
> >> > > many generic changes since I have only x86 and ia64 machines to test 
> >> > > with.
> > > 
> > > The simple version is just a static array of [NR_CPUS] cpumask_t's.  
> > > Do that, with an override for smarter archs?
> > > 
> > > I really REALLY prefer that over the fairly tortuous macros.
> 
> a fresh commit in -git has exposed the topology.h mess - see the hack 
> below. We now have diverging versions of topology_core_siblings() 
> semantics - that sure cannot be right. Mike?
> 
> 	Ingo
> 
> ------->
> commit 695a6b456307455a10059512208e8ed0d376ecd3
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jul 23 13:19:44 2008 +0200
> 
>     topology: work around topology_core_siblings() breakage
>     
>     work around:
>     
>     drivers/net/sfc/efx.c: In function â??efx_probe_interrupts':
>     drivers/net/sfc/efx.c:845: error: lvalue required as unary â??&' operand
>     
>     the topology API is a mess right now ...
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---

Signed-off-by: Mike Travis <travis@sgi.com>

---
The following cross built successfully:

    x86_64-default
    x86_64-single
    x86_64-8psmp
    x86_64-debug
    x86_64-numa
    i386-default
    i386-single
    i386-smp
    ia64-sn2
    ia64-default
    ia64-nosmp
    ia64-zx1
    s390-default
    arm-default
    sparc-default
    sparc64-default
    sparc64-smp
    mips-default
    ppc-pmac32

These had problems:

    ppc-iseries
	 Build failed Wed Jul 23 10:10:10 PDT 2008
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
    ppc64
	 Build failed Wed Jul 23 10:10:19 PDT 2008
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
    ppc-pseries
	 Build failed Wed Jul 23 10:10:29 PDT 2008
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
    ppc-smp
	 Build failed Wed Jul 23 10:12:03 PDT 2008
	  CC      drivers/scsi/scsi_error.o
	  BOOTCC  arch/powerpc/boot/libfdt/fdt_strerror.o
	make[1]: *** [arch/powerpc/boot/uImage] Error 127
    ps3_defconfig
	 Build failed Wed Jul 23 10:12:18 PDT 2008
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
    powerpc-allmodconfig
	 Build failed Wed Jul 23 10:12:31 PDT 2008
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration
	:0: error: -m64 not supported in this configuration

-- 
