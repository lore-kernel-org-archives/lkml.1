Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZE0Uau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZE0Uau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZE0U3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:29:52 -0400
Received: from sous-sol.org ([216.99.217.87]:42332 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754752AbZE0U3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:29:50 -0400
Date: Wed, 27 May 2009 13:29:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix coalesced_mmio leak on shutdown
Message-ID: <20090527202932.GI20823@sequoia.sous-sol.org>
References: <20090527164059.23966.75880.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527164059.23966.75880.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> It would appear that we are invoking kfree() on the wrong pointer in the
> destructor for the coalesced_mmio device.  This would result in a potential
> leak during shutdown.

Happens to work and not leak:

struct kvm_coalesced_mmio_dev { 
        struct kvm_io_device dev;
        struct kvm *kvm;
        int nb_zones;
        struct kvm_coalesced_mmio_zone zone[KVM_COALESCED_MMIO_ZONE_MAX];
};

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  virt/kvm/coalesced_mmio.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5ae620d..03ea280 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -80,7 +80,10 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
>  
>  static void coalesced_mmio_destructor(struct kvm_io_device *this)
>  {
> -	kfree(this);
> +	struct kvm_coalesced_mmio_dev *dev =
> +		(struct kvm_coalesced_mmio_dev *)this->private;

I think container_of() makes more sense here.

thanks,
-chris
