Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXCSPpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXCSPpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXCSPpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:45:10 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:57541 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbXCSPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:45:06 -0400
Date: Mon, 19 Mar 2007 16:43:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: Anthony Liguori <aliguori@us.ibm.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
Message-ID: <20070319154311.GB8331@osiris.boeblingen.de.ibm.com>
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FAA39C.9050705@us.ibm.com> <20070316150145.GB8525@osiris.boeblingen.de.ibm.com> <45FD1778.6030602@argo.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FD1778.6030602@argo.co.il>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 12:42:00PM +0200, Avi Kivity wrote:
> Heiko Carstens wrote:
> >In addition, if we would port kvm to s390, then we would need to
> >make sure that each virtual cpu only gets executed from the thread
> >that created it. That is simply because the upper half of our page
> >tables contain information about the guest page states. This is yet
> >another thing that would be strange to do via an ioctl based interface.
> 
> Right.  I agree it's more natural to associate a vcpu with a task
> instead of a vcpu being an independent entry.  We'd still need a
> handle for it, and in Linux that's an fd (pid doesn't cut it as it's
> racy, and probably slower too as it has to go through a global structure).

If you go for: only one VM per thread group and only one vcpu per thread
you don't need any identifier.
All relevant information or a pointer to it would be saved in the
thread_info structure.
That would give you two system calls to add/remove cpus which implicitely
create a VM if none is present. This add_vcpu syscall would also map
a memory range to user space which would be used to communicate between
user/kernel space to avoid frequent copy_to/from_user just like your
latest patches for KVM_RUN do.

We implemented a prototype on s390 based on a system call interface
and which does have full smp support.

This is a simplified version of how a add_cpu system call would look like.
Please note that I left out all error checkings etc. E.g. checking if the
vcpu already exists in the VM.

asmlinkage long sys_kvm_add_cpu(int vcpu, unsigned long addr)
{
	struct kvm *kvm;

	if (current_thread_info()->vcpu != -1)
		return -EINVAL;

	mutex_lock(&kvm_mutex);

	write_lock_bh(&tasklist_lock);
	/*
	 * Check all thread_infos in thread group if a VM context
	 * was already created.
	 */
	kvm = search_threads_for_kvm();
	write_unlock_bh(&tasklist_lock);

	if (!kvm) {
		kvm = create_kvm_context();
		current_thread_info()->kvm = kvm;
	}

	arch_add_cpu(vcpu);
	current_thread_info()->vcpu = vcpu;

	/*
	 * Map vcpu data to userspace at addr.
	 */
	arch_create_kvm_area(addr);

	mutex_unlock(&kvm_mutex);

	return 0;
}

asmlinkage long sys_kvm_remove_cpu(void)
{
	int vcpu;

	vcpu = current_thread_info()->vcpu;
	if (cpu == -1)
		return -EINVAL;

	mutex_lock(&kvm_mutex);
	arch_remove_cpu(vcpu);
	current_thread_info()->vcpu = -1;
	mutex_unlock(&kvm_mutex);
	return 0;
}

The interesting part with this is that you don't need any locking
for a kvm_run system call, simply because only the thread itself can
create/remove the vcpu:

asmlinkage long sys_kvm_run(void)
{
	int vcpu;

	vcpu = current_thread_info()->vcpu;
	if (vcpu == -1)
		return -EINVAL;
	return arch_kvm_run();
}

Of course all this is rather simplified, but should give a good idea
why I think that a syscall based interface should be the way to go.
