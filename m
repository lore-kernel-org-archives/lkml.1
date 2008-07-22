Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYGVQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYGVQF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYGVQFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:05:13 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:21033 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYGVQFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:05:11 -0400
Message-ID: <488604F8.1040008@siemens.com>
Date: Tue, 22 Jul 2008 18:04:08 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal>
In-Reply-To: <20080717172853.GB29855@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jan Kiszka (jan.kiszka@siemens.com) wrote:
>> Mathieu Desnoyers wrote:
>>> Port/cleanup of KVM-trace to tracepoints.
>>>
>>> Tracepoints allow dormat instrumentation, like the kernel markers, but also
>>> allows to describe the trace points in global headers so they can be easily
>>> managed. They also do not use format strings.
>>>
>>> Anything that would involve an action (dereference a pointer, vmcs read, ...)
>>> only required when tracing is placed in the probes created in kvm_trace.c
>>>
>>> This patch depends on the "Tracepoints" patch.
>>>
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>>> CC: 'Peter Zijlstra' <peterz@infradead.org>
>>> CC: 'Feng(Eric) Liu' <eric.e.liu@intel.com>
>>> CC: Avi Kivity <avi@qumranet.com>
>>> CC: kvm@vger.kernel.org
>>> ---
>>>  arch/x86/kvm/vmx.c   |   38 ++---
>>>  arch/x86/kvm/x86.c   |   43 ++----
>>>  include/trace/kvm.h  |   83 ++++++++++++
>>>  virt/kvm/kvm_trace.c |  336 +++++++++++++++++++++++++++++++++++++++++++--------
>>>  4 files changed, 398 insertions(+), 102 deletions(-)
>> Is it a specific property of KVM-trace that causes this LOC blow-up? Or
>> is this a generic side-effect of tracepoints?
>>
>> [ Hmm, hope I didn't missed too much of the tracepoint discussion... ]
>>
> 
> This LOC blow-up is caused by the creation of one probe per
> instrumentation site. So instead of placing the argument setup of
> everything that goes in the trace (0 to 5 u32 arguments) in the kvm
> code, it can be placed separately in a probe object, which could
> eventually be a dynamically loadable module.
> 
> The primary objective of tracepoints is to make sure the kernel code
> does not become harder to read because of added instrumentation and to
> provide type-checking at compile-time without needing to put format
> strings into the kernel code, which, to some, looks like debugging code.
> The other aspect it try to address is maintainability of trace points :
> it's much easier to look at all the prototype definitions in
> include/trace/*.h and to manage them (and external tracers which would
> like to connect on those points) than to try to figure out in which C
> files tracing statements has been hidden. We can think of it as a
> standard tracing API providing a more or less stable list of kernel
> tracepoints.
> 
> So, while KVMTRACE_?D() statements suits closely kvm-trace
> specificities, it's useless to impose constraints such as splitting
> unsigned longs into two u32 for tracers which can support a wider
> variety of data types.
> 
> After refactoring the patch to put the probes in arch/x86/kvm, the
> result is :
> 
>  arch/x86/kvm/Makefile           |    1
>  arch/x86/kvm/kvm_trace_probes.c |  251 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx.c              |   38 ++----
>  arch/x86/kvm/x86.c              |   43 ++----
>  include/asm-x86/kvm_host.h      |    8 +
>  include/trace/kvm.h             |   83 +++++++++++++
>  virt/kvm/kvm_trace.c            |   93 ++++++--------
>  7 files changed, 414 insertions(+), 103 deletions(-)
> 
> So actually, is it better to have less LOC which looks like this :
> 
>         KVMTRACE_5D(CPUID, vcpu, function,
>                     (u32)kvm_register_read(vcpu, VCPU_REGS_RAX),
>                     (u32)kvm_register_read(vcpu, VCPU_REGS_RBX),
>                     (u32)kvm_register_read(vcpu, VCPU_REGS_RCX),
>                     (u32)kvm_register_read(vcpu, VCPU_REGS_RDX), handler);
> 
> 
> or more LOC looking like this :
> 
> include/trace/kvm.h:
> DEFINE_TRACE(kvm_cpuid,
>         TPPROTO(struct kvm_vcpu *vcpu, u32 function),
>         TPARGS(vcpu, function));
> 
> arch/x86/kvm/x86.c:
>         trace_kvm_cpuid(vcpu, function);
> 
> arch/x86/kvm/kvm_trace_probes.c:
> static void probe_kvm_cpuid(struct kvm_vcpu *vcpu, u32 function)
> {
>         kvm_add_trace(KVM_TRC_CPUID, vcpu, 5,
>                 (u32 []){ function,
>                         (u32)kvm_register_read(vcpu, VCPU_REGS_RAX),
>                         (u32)kvm_register_read(vcpu, VCPU_REGS_RBX),
>                         (u32)kvm_register_read(vcpu, VCPU_REGS_RCX),
>                         (u32)kvm_register_read(vcpu, VCPU_REGS_RDX) });
> }
> 
> int register_kvm_tracepoints(void)
> {
>    ...
>    ret = register_trace_kvm_cpuid(probe_kvm_cpuid);
>    WARN_ON(ret);
>    ...
> }
> 
> void unregister_kvm_tracepoints(void)
> {
>    ...
>    unregister_trace_kvm_cpuid(probe_kvm_cpuid);
>    ...
> }
> 
> ?
> 
> Notice that only a single line of code is inserted to the kernel code,
> while all the rest sits outsite in a separated probe module. So I think
> it's very important to distinguish between LOC which impair kernel code
> readability and LOC which sit in their own sandbox.

That's true - as long as you don't have to add/remove/modify
tracepoints. I had to do this job in the past (not for KVM). Having 1
spot in 1 file (based on generic probes) would be handier in that case
than 5 spots in 3 files. But if the KVM tracepoints are considered
stable in their number and structure, that shouldn't be an issue here.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
