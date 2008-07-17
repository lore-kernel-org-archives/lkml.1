Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYGQRKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYGQRKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYGQRJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:09:57 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:45398 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755668AbYGQRJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:09:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFACQYf0hMRKxB/2dsb2JhbACBWq5h
Date: Thu, 17 Jul 2008 13:04:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
Message-ID: <20080717170453.GA29855@Krystal>
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca> <487F78DB.2070303@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <487F78DB.2070303@codemonkey.ws>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:58:53 up 42 days, 21:39,  5 users,  load average: 1.31, 0.67,
	0.59
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> Hi Mathieu,
>

Hi Anthony,

> It's difficult to review your patches because they aren't inlined.
>
> At any rate, this patches are unusable with SVM.  They try to execute VT 
> instructions unconditionally.  For instance, you changed:
>>
>> -    KVMTRACE_1D(INTR, vcpu, vmcs_read32(VM_EXIT_INTR_INFO), handler);
>> +    trace_kvm_intr(vcpu);
>
> Which lived in VT-specific code (vmx.c)
>
> To:
>
>> +static void probe_kvm_intr(struct kvm_vcpu *vcpu)
>> +{
>> +    kvm_add_trace(KVM_TRC_INTR, vcpu, 1,
>> +        (u32 []){ vmcs_read32(VM_EXIT_INTR_INFO) });
>> +}
>> +
>
> Which lives in common code (kvm_trace.c).  But vmcs_read32() is VT-specific 
> and should not be used in common code so this motion is wrong.  Why not 
> just pass more arguments to probe_kvm_intr()?  Then your first two patches 
> can be dropped completely.
>

Yes, I just noticed that I made a small mistake : the probe code should
actually go in arch/x86/kvm/kvm_trace_probes.c, which is x86-specific.

The reason why I would try to move the vmcs_read32(VM_EXIT_INTR_INFO) to
the probe code is because, unlike the Markers, when a function call with
potential side-effects is put within the arguments, it's really an
argument to a static inline function. In the markers, since it was a
parameter passed to a macro, I could shuffle it into the branch and it
would not be executed when markers were disabled.

However, we don't have this with tracepoints.

kvm-move-register-read-write-to-system-headers.patch becomes
obsolete since I put the probe code in arch/x86/kvm/.

But it would still be required to move vmcs read and encodings to
headers, either to include/asm-x86 or arch/x86/kvm.

Mathieu

> Regards,
>
> Anthony Liguori
>
> Mathieu Desnoyers wrote:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
