Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbYBMQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbYBMQG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYBMQGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:06:51 -0500
Received: from kanga.kvack.org ([66.96.29.28]:53046 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbYBMQGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:06:50 -0500
Date: Wed, 13 Feb 2008 14:09:05 -0200
From: Marcelo Tosatti <marcelo@kvack.org>
To: Jiri Kosina <jkosina@suse.cz>, Avi Kivity <avi@qumranet.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Qemu & KVM bug
Message-ID: <20080213160905.GA8559@dmt>
References: <c4e36d110802130638i5057b49by280ab0b2c415064a@mail.gmail.com> <Pine.LNX.4.64.0802131621440.7699@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802131621440.7699@twin.jikos.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 04:24:53PM +0100, Jiri Kosina wrote:
> On Wed, 13 Feb 2008, Zdenek Kabelac wrote:
> 
> > I get this bug in my log whenever I start qemu-kvm - I do not use kqemu 
> > module - so it's with plain kernel modules. If more details are needed - 
> > just ask. (Cpu; C2D)
> > BUG: sleeping function called from invalid context at kernel/rwsem.c:48
> > in_atomic():1, irqs_disabled():0
> > INFO: lockdep is turned off.
> > Pid: 26600, comm: qemu-kvm Not tainted 2.6.25-rc1 #29
> 
> This has been obviously caused by Marcelo's (added to CC) commit 
> 10589a4699b, which added down_write(mmap_sem) to alloc_apic_access_page(), 
> which is called with preempt disabled from vmx_create_vcpu().

alloc_apic_access_page() called mutex_lock, so the warning would trigger
before that change.

I think it's fine to allocate the APIC page after put_cpu(), since no vcpu 
state is required.

Avi?


--- linux-2.6.orig/arch/x86/kvm/vmx.c
+++ linux-2.6/arch/x86/kvm/vmx.c
@@ -1601,9 +1601,6 @@ static int vmx_vcpu_setup(struct vcpu_vm
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
 
-	if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))
-		if (alloc_apic_access_page(vmx->vcpu.kvm) != 0)
-			return -ENOMEM;
 
 	return 0;
 }
@@ -2533,6 +2530,9 @@ static struct kvm_vcpu *vmx_create_vcpu(
 	put_cpu();
 	if (err)
 		goto free_vmcs;
+	if (vm_need_virtualize_apic_accesses(kvm))
+		if (alloc_apic_access_page(kvm) != 0)
+			goto free_vmcs;
 
 	return &vmx->vcpu;
 
