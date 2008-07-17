Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYGQQxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYGQQxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYGQQxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:53:16 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:33836 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbYGQQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:53:14 -0400
Message-ID: <487F78DB.2070303@codemonkey.ws>
Date: Thu, 17 Jul 2008 11:52:43 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca>
In-Reply-To: <20080717160003.359557938@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

It's difficult to review your patches because they aren't inlined.

At any rate, this patches are unusable with SVM.  They try to execute VT 
instructions unconditionally.  For instance, you changed:
>
> -    KVMTRACE_1D(INTR, vcpu, vmcs_read32(VM_EXIT_INTR_INFO), handler);
> +    trace_kvm_intr(vcpu);

Which lived in VT-specific code (vmx.c)

To:

> +static void probe_kvm_intr(struct kvm_vcpu *vcpu)
> +{
> +    kvm_add_trace(KVM_TRC_INTR, vcpu, 1,
> +        (u32 []){ vmcs_read32(VM_EXIT_INTR_INFO) });
> +}
> +

Which lives in common code (kvm_trace.c).  But vmcs_read32() is 
VT-specific and should not be used in common code so this motion is 
wrong.  Why not just pass more arguments to probe_kvm_intr()?  Then your 
first two patches can be dropped completely.

Regards,

Anthony Liguori

Mathieu Desnoyers wrote:
