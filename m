Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZH0AEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZH0AEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 20:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZH0AET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 20:04:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbZH0AET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 20:04:19 -0400
Date: Wed, 26 Aug 2009 17:02:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: zohar@us.ibm.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
       torvalds@linux-foundation.org, James Morris <jmorris@namei.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] allow disabling IMA at runtime
Message-Id: <20090826170225.7574759e.akpm@linux-foundation.org>
In-Reply-To: <20090826021005.GD19494@bombadil.infradead.org>
References: <20090826021005.GD19494@bombadil.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 22:10:05 -0400
Kyle McMartin <kyle@mcmartin.ca> wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> Due to a memory leak in IMA that we're currently debugging in Fedora
> rawhide, it would be nice to be able to disable that support at runtime.
> Currently it's only able to be built in, and there's no toggle to avoid
> initializing it.
> 
> Provide one, in order to enhance debuggability. If a user can reboot a
> machine and edit its command line, one can do a far sight worse things
> than disabling a security precaution.
> 

nits:

> 
> ---
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7936b80..0d1b1ed 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -926,6 +926,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  	ihash_entries=	[KNL]
>  			Set number of hash buckets for inode cache.
>  
> +	ima=		[IMA]
> +			Format: { "0" | "1" }
> +			0 -- disable IMA.
> +			1 -- enable IMA. (default)
> +
>  	ima_audit=	[IMA]
>  			Format: { "0" | "1" }
>  			0 -- integrity auditing messages. (Default)
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 101c512..cc7603e 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -339,10 +339,27 @@ int ima_bprm_check(struct linux_binprm *bprm)
>  	return 0;
>  }
>  
> +static int ima_disabled = 0;
> +static int __init ima_enabled(char *str)
> +{
> +	unsigned long enabled;
> +
> +	if (!strict_strtoul(str, 0, &enabled))
> +		ima_disabled = enabled ? 0 : 1;
> +	return 1;
> +}

- documentation says "0 or 1" but the implementation says "0 or non-zero".

- implementation returns `1' whether or not the argument was
  successfully parsed.

  What happens if a __setup() functions returns non-1?

  <spends a while fossicking through prehistory and RustyCode>

  From my reading of kernel/params.c:parse_args(), every __setup()
  function which returns `1' should result in printk("%s: `%s' invalid
  for parameter `%s'), so I'm all confused and giving up.

> +__setup("ima=", ima_enabled);

Are we supposed to use core_param() nowadays?

>  static int __init init_ima(void)
>  {
>  	int error;
>  
> +	if (ima_disabled) {
> +		pr_info("IMA disabled at user request.\n");
> +		return 0;
> +	}
> +
>  	ima_iintcache_init();
>  	error = ima_init();
>  	ima_initialized = 1;

