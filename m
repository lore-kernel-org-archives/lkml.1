Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZFDMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZFDMoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZFDMoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:44:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34765 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbZFDMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:44:08 -0400
Date: Thu, 4 Jun 2009 14:51:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/2] KVM: Add VT-x machine check support
Message-ID: <20090604125123.GY1065@one.firstfloor.org>
References: <20090604112.650907584@firstfloor.org> <20090604111205.C47C31D0282@basil.firstfloor.org> <4A27B481.5020003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27B481.5020003@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:48:17PM +0300, Avi Kivity wrote:
> Andi Kleen wrote:
> >[Avi could you please still consider this patch for your 2.6.31 patchqueue?
> >It's fairly simple, but important to handle memory errors in guests]
> >  
> 
> Oh yes, and it'll be needed for -stable.  IIUC, right now a machine 
> check is trapped by the guest, so the guest is killed instead of the host?

Yes the guest will receive int 18.

But it will not kill itmelf because the guest cannot access the machine check
MSRs, so it will not see any machine check. So it's kind of ignored,
which is pretty bad.

> 
> >+/*
> >+ * Trigger machine check on the host. We assume all the MSRs are already 
> >set up
> >+ * by the CPU and that we still run on the same CPU as the MCE occurred 
> >on.
> >+ * We pass a fake environment to the machine check handler because we want
> >+ * the guest to be always treated like user space, no matter what context
> >+ * it used internally.
> >+ */
> >  
> 
> This assumption is incorrect.  This code is executed after preemption 
> has been enabled, and we may have even slept before reaching it.

The only thing that counts here is the context before the machine
check event. If there was a vmexit we know it was in guest context.

The only requirement we have is that we're running still on the same
CPU. I assume that's true, otherwise the vmcb accesses wouldn't work?

> > 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
> >+	[EXIT_REASON_MACHINE_CHECK]	      = handle_machine_check,
> > };
> > 
> > static const int kvm_vmx_max_exit_handlers =
> >  
> 
> We get both an explicit EXIT_REASON and an exception?

These are different cases. The exception is #MC in guest context,
the EXIT_REASON is when a #MC happens while the CPU is executing
the VM entry microcode.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
