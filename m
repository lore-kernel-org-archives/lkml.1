Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZKYXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZKYXVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758889AbZKYXVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:21:35 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:35243 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758880AbZKYXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:21:35 -0500
Message-ID: <4B0DBC48.7000208@snapgear.com>
Date: Thu, 26 Nov 2009 09:22:48 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


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


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
