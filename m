Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZKYGQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZKYGQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZKYGQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:16:54 -0500
Received: from mail2.shareable.org ([80.68.89.115]:39527 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZKYGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:16:53 -0500
Date: Wed, 25 Nov 2009 06:16:40 +0000
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [uClinux-dev] [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Message-ID: <20091125061640.GB17203@shareable.org>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The mmu code uses the copy_*_user_page() variants in access_process_vm()
> rather than copy_*_user() as the former includes an icache flush.  This is
> important when doing things like setting software breakpoints with gdb.
> So switch the nommu code over to do the same.

Reasonable, but it's a bit subtle don't you think?
How about a one-line comment saying why it's using copy_*_user_page()?

(If it was called copy_*_user_flush_icache() I wouldn't say anything,
but it isn't).

> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  mm/nommu.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 9876fa0..51ae9be 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1889,9 +1889,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>  
>  		/* only read or write mappings where it is permitted */
>  		if (write && vma->vm_flags & VM_MAYWRITE)
> -			len -= copy_to_user((void *) addr, buf, len);
> +			copy_to_user_page(vma, NULL, NULL,
> +					  (void *) addr, buf, len);
>  		else if (!write && vma->vm_flags & VM_MAYREAD)
> -			len -= copy_from_user(buf, (void *) addr, len);
> +			copy_from_user_page(vma, NULL, NULL,
> +					    buf, (void *) addr, len);
>  		else
>  			len = 0;
>  	} else {
