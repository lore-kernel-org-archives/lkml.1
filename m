Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZJAWfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZJAWfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZJAWfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:35:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:57362 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZJAWfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:35:41 -0400
Date: Fri, 2 Oct 2009 08:34:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 7/9] Simplify bound checks in capabilities for 
 copy_from_user
In-Reply-To: <20090929112410.0adc17f6@infradead.org>
Message-ID: <alpine.LRH.2.00.0910020834170.8455@tundra.namei.org>
References: <20090926204951.424e567e@infradead.org> <20090926205336.77bc5b21@infradead.org> <21d7e9970909282255y6718b11cvadafae0e1648817c@mail.gmail.com> <20090929112410.0adc17f6@infradead.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Arjan van de Ven wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH 7/9] Simplify bound checks in capabilities for copy_from_user
> CC: James Morris <jmorris@namei.org>
> 
> The capabilities syscall has a copy_from_user() call where gcc currently
> cannot prove to itself that the copy is always within bounds.
> 
> This patch adds a very explicity bound check to prove to gcc that 
> this copy_from_user cannot overflow its destination buffer.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: James Morris <jmorris@namei.org>


> diff --git a/kernel/capability.c b/kernel/capability.c
> index 4e17041..204f11f 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -238,7 +241,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
>  SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
>  {
>  	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
> -	unsigned i, tocopy;
> +	unsigned i, tocopy, copybytes;
>  	kernel_cap_t inheritable, permitted, effective;
>  	struct cred *new;
>  	int ret;
> @@ -255,8 +258,11 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
>  	if (pid != 0 && pid != task_pid_vnr(current))
>  		return -EPERM;
>  
> -	if (copy_from_user(&kdata, data,
> -			   tocopy * sizeof(struct __user_cap_data_struct)))
> +	copybytes = tocopy * sizeof(struct __user_cap_data_struct);
> +	if (copybytes > sizeof(kdata))
> +		return -EFAULT;
> +
> +	if (copy_from_user(&kdata, data, copybytes))
>  		return -EFAULT;
>  
>  	for (i = 0; i < tocopy; i++) {
> 
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> 

-- 
James Morris
<jmorris@namei.org>
