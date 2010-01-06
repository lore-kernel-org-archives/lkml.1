Return-Path: <linux-kernel-owner+w=401wt.eu-S932468Ab0AFR0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0AFR0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418Ab0AFRZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:25:50 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54333 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab0AFRZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:25:46 -0500
Date: Wed, 6 Jan 2010 11:25:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] cred: fix memory leak
Message-ID: <20100106172541.GB15784@us.ibm.com>
References: <1262797265-26557-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262797265-26557-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jiri Slaby (jslaby@suse.cz):
> Stanse found a memory leak in prepare_exec_creds. tgcred is not
> freed/assigned on all paths. Fix that.
> 
> I.e. unifdef tgcred and add kfree(tgcred); as it is initialized to
> NULL already.

Does this compile with CONFIG_KEYS=n, , though?  I don't see a dummy
define for struct thread_group_cred in cred.h.  Should this patch add
one?

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: David Howells <dhowells@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Serge Hallyn <serue@us.ibm.com>
> ---
>  kernel/cred.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index dd76cfe..0e10f73 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -351,9 +351,7 @@ struct cred *prepare_exec_creds(void)
>   */
>  struct cred *prepare_usermodehelper_creds(void)
>  {
> -#ifdef CONFIG_KEYS
>  	struct thread_group_cred *tgcred = NULL;
> -#endif
>  	struct cred *new;
> 
>  #ifdef CONFIG_KEYS
> @@ -363,8 +361,10 @@ struct cred *prepare_usermodehelper_creds(void)
>  #endif
> 
>  	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
> -	if (!new)
> +	if (!new) {
> +		kfree(tgcred);
>  		return NULL;
> +	}
> 
>  	kdebug("prepare_usermodehelper_creds() alloc %p", new);
> 
> -- 
> 1.6.5.7
