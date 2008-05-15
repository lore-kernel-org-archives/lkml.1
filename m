Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbYEOEyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbYEOEyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 00:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYEOEyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 00:54:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:49839 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYEOEyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 00:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gso8J3xIyHvclwmKJU0YxBb2ZvkdeT/yqRg0sh7ufiobF26ARJCVlV5ijXWuKUZ/+8K/BnhVu/UJOv2UYWFLbiQt0xUz3MEEF7TJyIHnIiIGvqOZMhmWe7kvnPCd1RwuJLFH3Y2uV7KUV+hZRo9o4vzYfHb1bJRznoi8Rdq4Nw4=
Date: Thu, 15 May 2008 09:50:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com,
       Josh Triplett <josh@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rculist.h: use the rcu API
Message-ID: <20080515055011.GA12809@martell.zuzino.mipt.ru>
References: <482B5887.9050804@gmail.com> <482B58FA.30000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482B58FA.30000@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 11:26:18PM +0200, Franck Bui-Huu wrote:
> This patch makes almost all list mutation primitives use
> rcu_assign_pointer().
>
> The main point of this being readability improvement.

Which is not an improvement at all.

> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -17,9 +18,8 @@ static inline void __list_add_rcu(struct list_head *new,
> {
> 	new->next = next;
> 	new->prev = prev;
> -	smp_wmb();
> +	rcu_assign_pointer(prev->next, new);
> 	next->prev = new;
> -	prev->next = new;
> }

Nice chunk to demonstrate.

Before one could write this like:

	smp_wmb();			smp_wmb();
	next->prev = new;	or	prev->next = new;
	prev->next = new;		next->prev = new;

And both examples aren't buggy.

After, you can't write:

	next->prev = new;
	rcu_assign_pointer(prev->next, new);

Guess why?

This barrier is related not only to next assignment, but to the whole
group of assignments.

> @@ -108,9 +108,8 @@ static inline void list_replace_rcu(struct list_head 
> *old,
> {
> 	new->next = old->next;
> 	new->prev = old->prev;
> -	smp_wmb();
> +	rcu_assign_pointer(new->prev->next, new);
> 	new->next->prev = new;
> -	new->prev->next = new;
> 	old->prev = LIST_POISON2;
> }

