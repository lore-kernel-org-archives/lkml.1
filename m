Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZC2N1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZC2N1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZC2N0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:26:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZC2N0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:26:51 -0400
Message-ID: <49CF7716.1000008@redhat.com>
Date: Sun, 29 Mar 2009 16:26:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] kvm mmu: implement necessary data structures for
 second huge page accounting
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164319-16092-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch adds the necessary data structures to take care of write
> protections in place within a second huge page sized page.
>
>
> +#ifdef KVM_PAGES_PER_LHPAGE
> +	if (npages && !new.hpage_info) {
> +		int hugepages = npages / KVM_PAGES_PER_LHPAGE;
> +		if (npages % KVM_PAGES_PER_LHPAGE)
> +			hugepages++;
> +		if (base_gfn % KVM_PAGES_PER_LHPAGE)
> +			hugepages++;
>   

Consider a slot with base_gfn == 1 and npages == 1.  This will have 
hugepages == 2, which is wrong.

I think the right calculation is

  ((base_gfn + npages - 1) / N) - (base_gfn / N) + 1

i.e. index of last page, plus one so we can store it.

The small huge page calculation is off as well.

> +
> +		new.hpage_info = vmalloc(hugepages * sizeof(*new.hpage_info));
> +
> +		if (!new.hpage_info)
> +			goto out_free;
> +
> +		memset(new.hpage_info, 0, hugepages * sizeof(*new.hpage_info));
> +
> +		if (base_gfn % KVM_PAGES_PER_LHPAGE)
> +			new.hpage_info[0].write_count = 1;
> +		if ((base_gfn+npages) % KVM_PAGES_PER_LHPAGE)
> +			new.hpage_info[hugepages-1].write_count = 1;
> +	}
> +#endif
> +
>   

-- 
error compiling committee.c: too many arguments to function

