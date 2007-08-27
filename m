Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXH0R3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXH0R3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbXH0R3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:29:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39921 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745AbXH0R3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:29:13 -0400
Subject: Re: [PATCH 2/3] Refactor hypercall infrastructure
From: Anthony Liguori <aliguori@us.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Dor Laor <dor.laor@qumranet.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46D2F680.9060100@qumranet.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <11882278082826-git-send-email-aliguori@us.ibm.com>
	 <46D2F680.9060100@qumranet.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 27 Aug 2007 12:29:10 -0500
Message-Id: <1188235750.6364.8.camel@squirrel>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-27 at 19:06 +0300, Avi Kivity wrote:
> Anthony Liguori wrote:
> >  void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
> >  {
> >  	int i;
> > @@ -1632,6 +1575,12 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
> >  	vcpu->regs[VCPU_REGS_RBX] = 0;
> >  	vcpu->regs[VCPU_REGS_RCX] = 0;
> >  	vcpu->regs[VCPU_REGS_RDX] = 0;
> > +
> > +	if ((function & 0xFFFF0000) == 0x40000000) {
> > +		emulate_paravirt_cpuid(vcpu, function);
> > +		goto out;
> > +	}
> > +
> >   
> 
> Hmm.  Suppose we expose kvm capabilities to host userspace instead, and 
> let the host userspace decide which features to expose to the guest via 
> the regular cpuid emulation?  That allows the qemu command line to 
> control the feature set.

That's a little awkward with something like NPT.  Some CPUID features
should be masked by the availability of NPT support in hardware and
whether kernelspace supports NPT.  To set these feature bits in
userspace, you would have to query kernelspace anyway.

It would be nice to be consistent with the other cpuid flags though.
There is somewhat of a similar issue with migration here.  If we have an
initial set of PV features and down the road, add more, it may be
desirable to enable those features depending on what your network looks
like.  Yeah, I think I agree that userspace is the right place to set
these bits.

> >  
> > +static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
> > +{
> > +	int er;
> > +	
> > +	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
> > +
> > +	/* we should only succeed here in the case of hypercalls which
> > +	   cannot generate an MMIO event.  MMIO means that the emulator
> > +	   is mistakenly allowing an instruction that should generate
> > +	   a UD fault so it's a bug. */
> > +	BUG_ON(er == EMULATE_DO_MMIO);
> >   
> 
> It's a guest-triggerable bug; one vcpu can be issuing ud2-in-a-loop 
> while the other replaces the instruction with something that does mmio.

Good catch!  I'll update.

> > +
> > +#define KVM_ENOSYS		ENOSYS
> >   
> 
> A real number (well, an integer, not a real) here please.  I know that 
> ENOSYS isn't going to change soon, but this file defines the kvm abi and 
> I'd like it to be as independent as possible.
> 
> Let's start it at 1000 so that spurious "return 1"s or "return -1"s 
> don't get translated into valid error numbers.

Okay.

> I really like the simplification to the guest/host interface that this 
> patch brings.

Thanks.

Regards,

Anthony Liguori

