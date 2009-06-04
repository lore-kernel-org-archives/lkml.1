Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZFDLsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZFDLsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZFDLsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:48:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33097 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZFDLsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:48:23 -0400
Message-ID: <4A27B481.5020003@redhat.com>
Date: Thu, 04 Jun 2009 14:48:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] KVM: Add VT-x machine check support
References: <20090604112.650907584@firstfloor.org> <20090604111205.C47C31D0282@basil.firstfloor.org>
In-Reply-To: <20090604111205.C47C31D0282@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> [Avi could you please still consider this patch for your 2.6.31 patchqueue?
> It's fairly simple, but important to handle memory errors in guests]
>   

Oh yes, and it'll be needed for -stable.  IIUC, right now a machine 
check is trapped by the guest, so the guest is killed instead of the host?

> +/*
> + * Trigger machine check on the host. We assume all the MSRs are already set up
> + * by the CPU and that we still run on the same CPU as the MCE occurred on.
> + * We pass a fake environment to the machine check handler because we want
> + * the guest to be always treated like user space, no matter what context
> + * it used internally.
> + */
>   

This assumption is incorrect.  This code is executed after preemption 
has been enabled, and we may have even slept before reaching it.

NMI suffers from the same issue, see vmx_complete_interrupts().  You 
could handle it the same way.

> @@ -3150,6 +3171,7 @@
>  	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
>  	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
>  	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
> +	[EXIT_REASON_MACHINE_CHECK]	      = handle_machine_check,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =
>   

We get both an explicit EXIT_REASON and an exception?

-- 
error compiling committee.c: too many arguments to function

