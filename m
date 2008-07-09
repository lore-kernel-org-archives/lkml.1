Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYGIP4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYGIP4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYGIPz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:55:56 -0400
Received: from gw.goop.org ([64.81.55.164]:36562 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbYGIPzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:55:55 -0400
Message-ID: <4874DF7F.4080204@goop.org>
Date: Wed, 09 Jul 2008 08:55:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch] x86, paravirt-spinlocks: fix boot hang
References: <20080707190749.299430659@goop.org> <20080709122852.GA30579@elte.hu> <20080709133358.GA7005@elte.hu> <20080709134944.GA15190@elte.hu>
In-Reply-To: <20080709134944.GA15190@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> the patches caused a boot hang with this config:
>>
>>  http://redhat.com/~mingo/misc/config-Wed_Jul__9_14_47_04_CEST_2008.bad
>>     
>
> ok, fixed it via the patch below.
>
> 	Ingo
>
> -------------->
> commit 6412367fe22dc54cc727e7bec5bd65c36c1a0754
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jul 9 15:42:09 2008 +0200
>
>     x86, paravirt-spinlocks: fix boot hang
>     
>     the paravirt-spinlock patches caused a boot hang with this config:
>     
>      http://redhat.com/~mingo/misc/config-Wed_Jul__9_14_47_04_CEST_2008.bad
>     
>     i have bisected it down to:
>     
>     |  commit e17b58c2e85bc2ad2afc07fb8d898017c2b75ed1
>     |  Author: Jeremy Fitzhardinge <jeremy@goop.org>
>     |  Date:   Mon Jul 7 12:07:53 2008 -0700
>     |
>     |      xen: implement Xen-specific spinlocks
>     
>     i.e. applying that patch alone causes the hang. The hang happens in the
>     ftrace self-test:
>     
>       initcall utsname_sysctl_init+0x0/0x19 returned 0 after 0 msecs
>       calling  init_sched_switch_trace+0x0/0x4c
>       Testing tracer sched_switch: PASSED
>       initcall init_sched_switch_trace+0x0/0x4c returned 0 after 167 msecs
>       calling  init_function_trace+0x0/0x12
>       Testing tracer ftrace:
>       [hard hang]
>     
>     it should have continued like this:
>     
>       Testing tracer ftrace: PASSED
>       initcall init_function_trace+0x0/0x12 returned 0 after 198 msecs
>       calling  init_irqsoff_tracer+0x0/0x14
>       Testing tracer irqsoff: PASSED
>       initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 3 msecs
>       calling  init_mmio_trace+0x0/0x12
>       initcall init_mmio_trace+0x0/0x12 returned 0 after 0 msecs
>     
>     the problem is that such lowlevel primitives as spinlocks should never
>     be built with -pg (which ftrace does). Marking paravirt.o as non-pg and
>     marking all spinlock ops as always-inline solve the hang.
>    

Thanks Ingo, that would have taken me a while to work out.

Presumably that means that xen/smp.o should also be built without -pg.  
In fact, should I move the spinlock code into its own file, so that 
ftrace can cover as much as it can?

    J
