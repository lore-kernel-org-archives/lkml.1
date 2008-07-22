Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYGVSnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYGVSnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYGVSnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:43:01 -0400
Received: from il.qumranet.com ([212.179.150.194]:52135 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYGVSnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:43:00 -0400
Message-ID: <48862A30.7050701@qumranet.com>
Date: Tue, 22 Jul 2008 21:42:56 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org
Subject: Re: [patch 0/4] Port KVM-trace to tracepoints
References: <20080717155724.897537670@polymtl.ca>
In-Reply-To: <20080717155724.897537670@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hi,
>
> Here is a port of KVM-trace, currently using macros on top of the Linux Markers,
> to tracepoints. Note that I cleaned up the instrumentation too, so stuff like
>
> KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr,
>   (u32)kvm_register_read(vcpu, reg),
>   (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
>   handler);
>
> Sprinkled all across the KVM C code becomes :
>
> trace_kvm_cr_write(vcpu, cr, reg);
>
> Which looks much nicer, IMHO.
>
> It applies on top of linux-next patch-v2.6.26-next-20080715.
>
>   

It does look nicer; but it means maintaining tracepoints becomes much 
harder, because the information is scattered across many files.

kvm tracepoints are heavily tied into the implementation; and making 
them harder to write means we will have less information.  In fact, I am 
contemplating moving in another direction (when looking at the 
pgprintk()s scattered around arch/x86/kvm/mmu.c:

   kvm_trace("pfentry", "page_fault entry addr %lx error code %x\n", 
cr2, error_code);

Unlike printk()s, no actual formatting would occur during runtime.  
Instead, at initialization time all the strings would be parsed into a 
data structure that describes the data types, and the runtime would 
simply consult this structure and copy the arguments into trace 
records.  User space would also be able to pull this structure and so 
recreate the formatted string.

The advantages I see to this are:

  - easy to add traces; the most important advantage
  - when the code changes, obsolete traces are completely removed
  - good performance
  - no need to have a formats file in userspace (which is tied to the 
kernel version)
  - can also send printk()s along, for synchronization with other kvm 
and kernel events

In fact, why not convert printk() to do this, making it a 
high-performance logging system?  Of course it would retain the dmesg 
interface, but we could say that messages at the KERN_TRACE level bypass 
dmesg and only go to the trace system.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

