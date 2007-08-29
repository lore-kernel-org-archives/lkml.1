Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXH2Fv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXH2Fv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXH2FvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:51:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:33298 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXH2FvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:51:16 -0400
Subject: Re: [kvm-devel] [PATCH 2/3] Refactor hypercall infrastructure
From: Anthony Liguori <anthony@codemonkey.ws>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1188324777.5531.73.camel@localhost.localdomain>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <11882278082826-git-send-email-aliguori@us.ibm.com>
	 <1188324777.5531.73.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 00:51:10 -0500
Message-Id: <1188366670.6337.5.camel@squirrel>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 04:12 +1000, Rusty Russell wrote:
> On Mon, 2007-08-27 at 10:16 -0500, Anthony Liguori wrote:
> > This patch refactors the current hypercall infrastructure to better support live
> > migration and SMP.  It eliminates the hypercall page by trapping the UD
> > exception that would occur if you used the wrong hypercall instruction for the
> > underlying architecture and replacing it with the right one lazily.
> 
> It also reduces the number of hypercall args, which you don't mention
> here.

Oh yes, sorry.
	
> > +	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
> > +
> > +	/* we should only succeed here in the case of hypercalls which
> > +	   cannot generate an MMIO event.  MMIO means that the emulator
> > +	   is mistakenly allowing an instruction that should generate
> > +	   a UD fault so it's a bug. */
> > +	BUG_ON(er == EMULATE_DO_MMIO);
> 
> This seems... unwise.  Firstly we know our emulator is incomplete.
> Secondly an SMP guest can exploit this to crash the host.

This code is gone in v2.

> (Code is in two places).
> 
> > +#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"

Good point.

> A nice big comment would be nice here, I think.  Note that this is big
> enough for both "int $0x1f" and "sysenter", so I'm happy.

I need to add a comment somewhere mentioning that if you patch with
something less than 3 bytes, then you should pad with nop but the
hypervisor must treat the whole instruction (including the padding) as
atomic (that is, regardless of hypercall size, eip += 3) or you run the
risk of breakage during migration.

Regards,

Anthony Liguori

> Cheers,
> Rusty.
> 
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel

