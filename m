Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0BRNlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0BRNlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:41:08 -0500
Message-ID: <4B7D4368.6020903@redhat.com>
Date: Thu, 18 Feb 2010 15:40:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 01/10] KVM: SVM: Don't use kmap_atomic in nested_svm_map
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com> <1266493115-28386-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1266493115-28386-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> Use of kmap_atomic disables preemption but if we run in
> shadow-shadow mode the vmrun emulation executes kvm_set_cr3
> which might sleep or fault. So use kmap instead for
> nested_svm_map.
>
>
>
> -static void nested_svm_unmap(void *addr, enum km_type idx)
> +static void nested_svm_unmap(void *addr)
>   {
>   	struct page *page;
>
> @@ -1443,7 +1443,7 @@ static void nested_svm_unmap(void *addr, enum km_type idx)
>
>   	page = kmap_atomic_to_page(addr);
>
> -	kunmap_atomic(addr, idx);
> +	kunmap(addr);
>   	kvm_release_page_dirty(page);
>   }
>    

kunmap() takes a struct page *, not the virtual address (a consistent 
source of bugs).

kmap() is generally an unloved interface, it is slow and possibly 
deadlock prone, but it's better than sleeping in atomic context.  If you 
can hack your way around it, that is preferred.

-- 
error compiling committee.c: too many arguments to function

