Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXAaIwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXAaIwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbXAaIwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:52:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43984 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbXAaIwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:52:39 -0500
Date: Wed, 31 Jan 2007 09:50:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: cpu hotplug support
Message-ID: <20070131085039.GA17141@elte.hu>
References: <45BF5B96.1070007@qumranet.com> <20070130145616.EFD52A0014@il.qumranet.com> <20070130164829.ce7f2f90.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130164829.ce7f2f90.akpm@osdl.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0028]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@osdl.org> wrote:

> On Tue, 30 Jan 2007 14:56:16 -0000
> Avi Kivity <avi@qumranet.com> wrote:
> 
> > +static void decache_vcpus_on_cpu(int cpu)
> > +{
> > +	struct kvm *vm;
> > +	struct kvm_vcpu *vcpu;
> > +	int i;
> > +
> > +	spin_lock(&kvm_lock);
> > +	list_for_each_entry(vm, &vm_list, vm_list)
> > +		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> > +			vcpu = &vm->vcpus[i];
> > +			/*
> > +			 * If the vcpu is locked, then it is running on some
> > +			 * other cpu and therefore it is not cached on the
> > +			 * cpu in question.
> > +			 *
> > +			 * If it's not locked, check the last cpu it executed
> > +			 * on.
> > +			 */
> > +			if (mutex_trylock(&vcpu->mutex)) {
> > +				if (vcpu->cpu == cpu) {
> > +					kvm_arch_ops->vcpu_decache(vcpu);
> > +					vcpu->cpu = -1;
> > +				}
> > +				mutex_unlock(&vcpu->mutex);
> > +			}
> > +		}
> > +	spin_unlock(&kvm_lock);
> > +}
> 
> The trylock is unpleasing.  Perhaps kvm_lock should be a mutex or 
> something?

this is a special case. The vcpu->mutex acts as a 'this vcpu is running 
right now' flag as well - hence the trylock signals: is it running right 
now or not - if it's not running we do not have to 'decache' it. But i 
agree and i already suggested to Avi to change kvm_lock to be a mutex - 
but this wont change the trylock.

	Ingo
