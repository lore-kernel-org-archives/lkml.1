Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYKDQgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYKDQgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYKDQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:35:52 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:45802 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbYKDQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:35:51 -0500
Date: Tue, 4 Nov 2008 10:35:40 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v2 3/4] AUDIT: collect info when execve results in
	caps in pE
Message-ID: <20081104163540.GA24318@us.ibm.com>
References: <20081103201742.12059.36030.stgit@paris.rdu.redhat.com> <20081103201753.12059.67262.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103201753.12059.67262.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 8bb95ed..534abb5 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -8,6 +8,7 @@
>   */
> 
>  #include <linux/capability.h>
> +#include <linux/audit.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -373,6 +374,9 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
> 
>  void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
>  {
> +	kernel_cap_t pP = current->cap_permitted;
> +	kernel_cap_t pE = current->cap_effective;
> +
>  	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
>  	    !cap_issubset(bprm->cap_post_exec_permitted,
>  			  current->cap_permitted)) {
> @@ -407,6 +411,12 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
>  	}
> 
>  	/* AUD: Audit candidate if current->cap_effective is set */
> +	if (!cap_isclear(current->cap_effective)) {
> +		if (!cap_issubset(current->cap_effective, CAP_FULL_SET) ||

Hi Eric,

can you explain what the cap_issubset() check is for here?

thanks,
-serge

> +		    (bprm->e_uid != 0) || (current->uid != 0) ||
> +		    issecure(SECURE_NOROOT))
> +			audit_log_bprm_fcaps(bprm, &pP, &pE);
> +	}
> 
>  	current->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
>  }
