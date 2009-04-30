Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZD3NIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZD3NIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZD3NIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:08:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51484 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbZD3NII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:08:08 -0400
Date: Thu, 30 Apr 2009 16:07:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090430130708.GA13763@redhat.com>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427183334.6646.90800.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:33:34PM -0400, Gregory Haskins wrote:
> This allows an eventfd to be registered as an irq source with a guest.  Any
> signaling operation on the eventfd (via userspace or kernel) will inject
> the registered GSI at the next available window.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

If we ever want to use this with e.g. MSI-X emulation in guest, and want
to be stricly compliant to MSI-X, we'll need a way for guest to mask
interrupts, and for host to report that a masked interrupt is pending.
Ideally, all this will be doable with a couple of mmapped pages to avoid
vmexits/system calls.

> +static void
> +irqfd_inject(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
> +	struct kvm *kvm = irqfd->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> +	mutex_unlock(&kvm->lock);

This will do weird stuff (deliver the irq twice) if the irq is
MSI/MSI-X. I know this was discussed already and is a temporary
shortcut, but maybe add a comment that we really want kvm_toggle_irq,
so that we won't forget?

> +}
> +

-- 
MST
