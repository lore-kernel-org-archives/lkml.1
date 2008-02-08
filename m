Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbYBHWrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbYBHWrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYBHWre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:47:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235AbYBHWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:47:33 -0500
Date: Fri, 8 Feb 2008 14:46:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: rth@twiddle.net, tony.luck@intel.com, anton@samba.org, paulus@samba.org,
       bunk@kernel.org, kamalesh@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] moduleparam: fix alpha, ia64 and ppc64 compile failures
Message-Id: <20080208144615.9f2fc593.akpm@linux-foundation.org>
In-Reply-To: <20080208223341.GB15333@jurassic.park.msu.ru>
References: <20080208223341.GB15333@jurassic.park.msu.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 01:33:41 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On alpha, ia64 and ppc64 only relocations to local data can go into
> read-only sections. The vast majority of module parameters use the global
> generic param_set_*/param_get_* functions, so the 'const' attribute for
> struct kernel_param is not only useless, but it also causes compile
> failures due to 'section type conflict' in those rare cases where
> param_set/get are local functions.
> 
> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=8964
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> ---
>  include/linux/moduleparam.h |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 8126e55..ec62438 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -62,6 +62,16 @@ struct kparam_array
>  	void *elem;
>  };
>  
> +/* On alpha, ia64 and ppc64 relocations to global data cannot go into
> +   read-only sections (which is part of respective UNIX ABI on these
> +   platforms). So 'const' makes no sense and even causes compile failures
> +   with some compilers. */
> +#if defined(CONFIG_ALPHA) || defined(CONFIG_IA64) || defined(CONFIG_PPC64)
> +#define __moduleparam_const
> +#else
> +#define __moduleparam_const const
> +#endif
> +
>  /* This is the fundamental function for registering boot/module
>     parameters.  perm sets the visibility in sysfs: 000 means it's
>     not there, read bits mean it's readable, write bits mean it's
> @@ -71,7 +81,7 @@ struct kparam_array
>  	static int __param_perm_check_##name __attribute__((unused)) =	\
>  	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
>  	static const char __param_str_##name[] = prefix #name;		\
> -	static struct kernel_param const __param_##name			\
> +	static struct kernel_param __moduleparam_const __param_##name	\
>  	__used								\
>      __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
>  	= { __param_str_##name, perm, set, get, { arg } }

I think it would have been better to define a new CONFIG_MODULEPARAM_CONST
for those three archictures, rather than muckying up the code like this.

But hey, I get to close a bugzilla report - I'm doing that amlonst monthly
now.  Thanks.

