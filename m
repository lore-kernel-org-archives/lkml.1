Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXAaAtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXAaAtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXAaAtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:49:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXAaAtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:49:01 -0500
Date: Tue, 30 Jan 2007 16:48:29 -0800
From: Andrew Morton <akpm@osdl.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 4/5] KVM: cpu hotplug support
Message-Id: <20070130164829.ce7f2f90.akpm@osdl.org>
In-Reply-To: <20070130145616.EFD52A0014@il.qumranet.com>
References: <45BF5B96.1070007@qumranet.com>
	<20070130145616.EFD52A0014@il.qumranet.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 14:56:16 -0000
Avi Kivity <avi@qumranet.com> wrote:

> +static void decache_vcpus_on_cpu(int cpu)
> +{
> +	struct kvm *vm;
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	spin_lock(&kvm_lock);
> +	list_for_each_entry(vm, &vm_list, vm_list)
> +		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +			vcpu = &vm->vcpus[i];
> +			/*
> +			 * If the vcpu is locked, then it is running on some
> +			 * other cpu and therefore it is not cached on the
> +			 * cpu in question.
> +			 *
> +			 * If it's not locked, check the last cpu it executed
> +			 * on.
> +			 */
> +			if (mutex_trylock(&vcpu->mutex)) {
> +				if (vcpu->cpu == cpu) {
> +					kvm_arch_ops->vcpu_decache(vcpu);
> +					vcpu->cpu = -1;
> +				}
> +				mutex_unlock(&vcpu->mutex);
> +			}
> +		}
> +	spin_unlock(&kvm_lock);
> +}


The trylock is unpleasing.  Perhaps kvm_lock should be a mutex or something?

