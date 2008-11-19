Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYKSPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYKSPzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYKSPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:55:18 -0500
Received: from qb-out-0506.google.com ([72.14.204.237]:48040 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYKSPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:55:16 -0500
Message-ID: <492436DE.2080906@codemonkey.ws>
Date: Wed, 19 Nov 2008 09:55:10 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] always assign userspace_addr
References: <1226977462-8086-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1226977462-8086-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Currently, kvm only sets new.userspace_addr in slots
> that were just allocated. This is not the intended behaviour,
> and actually breaks when we try to use the slots to implement
> aliases, for example.
>
> Cirrus VGA aliases maps and address to a userspace address, and
> then keep mapping this same address to different locations
> until the whole screen is filled.
>
> The solution is to assign new.userspace_addr no matter what,
> so we can be sure that whenever the guest changes this field,
> it sees the change being reflected in the code.
>
> Signed-off-by: Glauber Costa <glommer@redhat.com>
>   

I think this is masking a much bigger problem.


> ---
>  virt/kvm/kvm_main.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a87f45e..fc3abf0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -762,15 +762,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		memset(new.rmap, 0, npages * sizeof(*new.rmap));
>  
>  		new.user_alloc = user_alloc;
> -		/*
> -		 * hva_to_rmmap() serialzies with the mmu_lock and to be
> -		 * safe it has to ignore memslots with !user_alloc &&
> -		 * !userspace_addr.
> -		 */
> -		if (user_alloc)
> -			new.userspace_addr = mem->userspace_addr;
> -		else
> -			new.userspace_addr = 0;
>   

This is guarded in:

>     if (npages && !new.rmap) {

In this case, npages > 0 but !new.rmap is already allocated.  But this 
is a new slot?  The problem is that when we delete the slot, the rmap 
never gets freed.  This means that if we delete a slot, then create a 
new slot which happens to be a different size, we use the old rmap and 
potentially overrun that buffer.

So I think we need a fix that properly frees the rmap when the slot is 
destroyed.

Regards,

Anthony Liguori

