Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbZGPPhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbZGPPhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbZGPPhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:37:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37194 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbZGPPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:37:44 -0400
Message-ID: <4A5F4945.3080202@us.ibm.com>
Date: Thu, 16 Jul 2009 10:37:41 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net>
In-Reply-To: <20090716151945.29318.10882.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> +/*
> + * ------------
> + * XINTERFACE (External Interface)
> + * -------------
> + */
> +
> +static struct kvm *
> +intf_to_kvm(struct kvm_xinterface *intf)
> +{
> +	return container_of(intf, struct kvm, xinterface);
> +}
> +
> +static unsigned long
> +xinterface_gpa_to_hva(struct kvm_xinterface *intf, unsigned long gpa)
> +{
> +	struct kvm *kvm = intf_to_kvm(intf);
> +	unsigned long addr;
> +
> +	addr = gfn_to_hva(kvm, gpa >> PAGE_SHIFT);
> +	if (kvm_is_error_hva(addr))
> +		return 0;
> +
> +	return addr + offset_in_page(gpa);
> +}
> +
> +static struct page *
> +xinterface_gpa_to_page(struct kvm_xinterface *intf, unsigned long gpa)
> +{
> +	struct kvm *kvm = intf_to_kvm(intf);
> +	struct page *page;
> +
> +	page = gfn_to_page(kvm, gpa >> PAGE_SHIFT);
> +	if (page == bad_page)
> +		return ERR_PTR(-EINVAL);
> +
> +	return page;
> +}
> +
> +static void
> +xinterface_release(struct kvm_xinterface *intf)
> +{
> +	struct kvm *kvm = intf_to_kvm(intf);
> +
> +	kvm_put_kvm(kvm);
> +}
> +
> +struct kvm_xinterface_ops _kvm_xinterface_ops = {
> +	.gpa_to_hva  = xinterface_gpa_to_hva,
> +	.gpa_to_page = xinterface_gpa_to_page,
> +	.release     = xinterface_release,
> +};
>   

How do you deal with locking?

The mappings (gpa_to_page) are not fixed.  They can and do change very 
often.  The interface doesn't seem to attempt to cope with this.

Regards,

Anthony Liguori
