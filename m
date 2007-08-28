Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbXH1SN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbXH1SN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXH1SNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:13:20 -0400
Received: from ozlabs.org ([203.10.76.45]:44948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbXH1SNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:13:19 -0400
Subject: Re: [PATCH 2/3] Refactor hypercall infrastructure
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Ingo Molnar <mingo@elte.hu>, Dor Laor <dor.laor@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <11882278082826-git-send-email-aliguori@us.ibm.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <11882278082826-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 04:12:57 +1000
Message-Id: <1188324777.5531.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 10:16 -0500, Anthony Liguori wrote:
> This patch refactors the current hypercall infrastructure to better support live
> migration and SMP.  It eliminates the hypercall page by trapping the UD
> exception that would occur if you used the wrong hypercall instruction for the
> underlying architecture and replacing it with the right one lazily.

It also reduces the number of hypercall args, which you don't mention
here.
	
> +	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
> +
> +	/* we should only succeed here in the case of hypercalls which
> +	   cannot generate an MMIO event.  MMIO means that the emulator
> +	   is mistakenly allowing an instruction that should generate
> +	   a UD fault so it's a bug. */
> +	BUG_ON(er == EMULATE_DO_MMIO);

This seems... unwise.  Firstly we know our emulator is incomplete.
Secondly an SMP guest can exploit this to crash the host.

(Code is in two places).

> +#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"

A nice big comment would be nice here, I think.  Note that this is big
enough for both "int $0x1f" and "sysenter", so I'm happy.

Cheers,
Rusty.

