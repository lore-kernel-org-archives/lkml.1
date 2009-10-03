Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZJCUGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZJCUGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 16:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbZJCUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 16:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974AbZJCUGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 16:06:09 -0400
Date: Sat, 3 Oct 2009 17:05:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external
	interaction with guests
Message-ID: <20091003200519.GB6601@amt.cnet>
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002201927.4014.29432.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 04:19:27PM -0400, Gregory Haskins wrote:
> What: xinterface is a mechanism that allows kernel modules external to
> the kvm.ko proper to interface with a running guest.  It accomplishes
> this by creating an abstracted interface which does not expose any
> private details of the guest or its related KVM structures, and provides
> a mechanism to find and bind to this interface at run-time.
> 
> Why: There are various subsystems that would like to interact with a KVM
> guest which are ideally suited to exist outside the domain of the kvm.ko
> core logic. For instance, external pci-passthrough, virtual-bus, and
> virtio-net modules are currently under development.  In order for these
> modules to successfully interact with the guest, they need, at the very
> least, various interfaces for signaling IO events, pointer translation,
> and possibly memory mapping.
> 
> The signaling case is covered by the recent introduction of the
> irqfd/ioeventfd mechanisms.  This patch provides a mechanism to cover the
> other cases.  Note that today we only expose pointer-translation related
> functions, but more could be added at a future date as needs arise.
> 
> Example usage: QEMU instantiates a guest, and an external module "foo"
> that desires the ability to interface with the guest (say via
> open("/dev/foo")).  QEMU may then pass the kvmfd to foo via an
> ioctl, such as: ioctl(foofd, FOO_SET_VMID, &kvmfd).  Upon receipt, the
> foo module can issue kvm_xinterface_bind(kvmfd) to acquire
> the proper context.  Internally, the struct kvm* and associated
> struct module* will remain pinned at least until the foo module calls
> kvm_xinterface_put().

> --- /dev/null
> +++ b/virt/kvm/xinterface.c
> @@ -0,0 +1,409 @@
> +/*
> + * KVM module interface - Allows external modules to interface with a guest
> + *
> + * Copyright 2009 Novell.  All Rights Reserved.
> + *
> + * Author:
> + *      Gregory Haskins <ghaskins@novell.com>
> + *
> + * This file is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/vmalloc.h>
> +#include <linux/highmem.h>
> +#include <linux/module.h>
> +#include <linux/mmu_context.h>
> +#include <linux/kvm_host.h>
> +#include <linux/kvm_xinterface.h>
> +
> +struct _xinterface {
> +	struct kvm             *kvm;
> +	struct task_struct     *task;
> +	struct mm_struct       *mm;
> +	struct kvm_xinterface   intf;
> +	struct kvm_memory_slot *slotcache[NR_CPUS];
> +};
> +
> +struct _xvmap {
> +	struct kvm_memory_slot    *memslot;
> +	unsigned long              npages;
> +	struct kvm_xvmap           vmap;
> +};
> +
> +static struct _xinterface *
> +to_intf(struct kvm_xinterface *intf)
> +{
> +	return container_of(intf, struct _xinterface, intf);
> +}
> +
> +#define _gfn_to_hva(gfn, memslot) \
> +	(memslot->userspace_addr + (gfn - memslot->base_gfn) * PAGE_SIZE)
> +
> +/*
> + * gpa_to_hva() - translate a guest-physical to host-virtual using
> + * a per-cpu cache of the memslot.
> + *
> + * The gfn_to_memslot() call is relatively expensive, and the gpa access
> + * patterns exhibit a high degree of locality.  Therefore, lets cache
> + * the last slot used on a per-cpu basis to optimize the lookup
> + *
> + * assumes slots_lock held for read
> + */
> +static unsigned long
> +gpa_to_hva(struct _xinterface *_intf, unsigned long gpa)
> +{
> +	int                     cpu     = get_cpu();
> +	unsigned long           gfn     = gpa >> PAGE_SHIFT;
> +	struct kvm_memory_slot *memslot = _intf->slotcache[cpu];
> +	unsigned long           addr    = 0;
> +
> +	if (!memslot
> +	    || gfn < memslot->base_gfn
> +	    || gfn >= memslot->base_gfn + memslot->npages) {
> +
> +		memslot = gfn_to_memslot(_intf->kvm, gfn);
> +		if (!memslot)
> +			goto out;
> +
> +		_intf->slotcache[cpu] = memslot;
> +	}
> +
> +	addr = _gfn_to_hva(gfn, memslot) + offset_in_page(gpa);
> +
> +out:
> +	put_cpu();
> +
> +	return addr;

Please optimize gfn_to_memslot() instead, so everybody benefits. It
shows very often on profiles.

> +
> +	page_list = (struct page **) __get_free_page(GFP_KERNEL);
> +	if (!page_list)
> +		return NULL;
> +
> +	down_write(&mm->mmap_sem);
> +
> +	ret = get_user_pages(p, mm, addr, npages, 1, 0, page_list, NULL);
> +	if (ret < 0)
> +		goto out;
> +
> +	ptr = vmap(page_list, npages, VM_MAP, PAGE_KERNEL);
> +	if (ptr)
> +		mm->locked_vm += npages;

Why don't you use gfn_to_page (here and elsewhere in the patch).

