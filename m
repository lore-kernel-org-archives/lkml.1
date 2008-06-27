Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbYF0U7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbYF0U7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYF0U7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:59:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41225 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYF0U7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:59:13 -0400
Date: Fri, 27 Jun 2008 15:59:05 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
Message-ID: <20080627205905.GB17415@us.ibm.com>
References: <486357EC.5060205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486357EC.5060205@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Bugfix for strace, and CAP_SETPCAP, in the case that filesystem
> capabilities are supported.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFIY1fr+bHCR3gb8jsRAph7AKDOlmeveIpQs1jhIs0TJxjCdMAS5ACgsml6
> 7UYR+FZpW2XdmG8PkiZzemU=
> =+Ko+
> -----END PGP SIGNATURE-----

> From f4419c78fff77c4fa3cdfa6b0a78edae92ddf467 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Wed, 25 Jun 2008 23:24:10 -0700
> Subject: [PATCH] Blunt CAP_SETPCAP on strace with filesystem capability support
> 
> The filesystem capability support meaning for CAP_SETPCAP is less
> powerful than the non-filesystem capability support. As such, when
> filesystem capabilities are configured, we should not permit
> CAP_SETPCAP to 'enhance' the current process through strace
> manipulation of a child process.
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

If I understand this right, then LSM_UNSAFE_PTRACE_CAP will only be set
if the tracer didn't have CAP_SYS_PTRACE.  So this seems sane to me.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  security/commoncap.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5edabc7..a9ea921 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -103,10 +103,16 @@ static inline int cap_inh_is_capped(void)
>  	return (cap_capable(current, CAP_SETPCAP) != 0);
>  }
>  
> +static inline int cap_limit_straced_target(void) { return 1; }
> +
>  #else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
>  
>  static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
>  static inline int cap_inh_is_capped(void) { return 1; }
> +static inline int cap_limit_straced_target(void)
> +{
> +	return !capable(CAP_SETPCAP);
> +}
>  
>  #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
>  
> @@ -342,9 +348,10 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
>  				bprm->e_uid = current->uid;
>  				bprm->e_gid = current->gid;
>  			}
> -			if (!capable (CAP_SETPCAP)) {
> -				new_permitted = cap_intersect (new_permitted,
> -							current->cap_permitted);
> +			if (cap_limit_straced_target()) {
> +				new_permitted =
> +					cap_intersect(new_permitted,
> +						      current->cap_permitted);
>  			}
>  		}
>  	}
> -- 
> 1.5.3.7
> 

