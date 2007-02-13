Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbXBMWjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbXBMWjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXBMWjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:39:55 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42342 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXBMWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:39:54 -0500
Message-ID: <45D23E38.1030607@vmware.com>
Date: Tue, 13 Feb 2007 14:39:52 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 06/21] Xen-paravirt: remove ctor for pgd cache
References: <20070213221729.772002682@goop.org> <20070213221829.929261125@goop.org>
In-Reply-To: <20070213221829.929261125@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>  
> @@ -261,10 +261,12 @@ void pgd_ctor(void *pgd, struct kmem_cac
>  	spin_unlock_irqrestore(&pgd_lock, flags);
>  }
>  
> -/* never called when PTRS_PER_PMD > 1 */
> -void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
> +static void pgd_dtor(pgd_t *pgd)
>  {
>  	unsigned long flags; /* can be called from interrupt context */
> +
> +	if (PTRS_PER_PMD == 1)
> +		return;
>  
>  	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
>  	spin_lock_irqsave(&pgd_lock, flags);
>   


Acked, with exceptions.  This bit breaks VMI.  The paravirt_release_pd 
must happen unconditionally.  But I would rather fix it after patches 
get applied just to make sure the entire allocation / deallocation order 
constraints are intact.

Zach
