Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZLMV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZLMV34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZLMV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:29:54 -0500
Received: from tundra.namei.org ([65.99.196.166]:39437 "HELO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754340AbZLMV3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:29:53 -0500
Date: Mon, 14 Dec 2009 08:29:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: David Howells <dhowells@redhat.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>, Chris Zankel <chris@zankel.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME
 architecture support
In-Reply-To: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
Message-ID: <alpine.LRH.2.00.0912140828430.25093@tundra.namei.org>
References: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009, Geert Uytterhoeven wrote:

> As of commit ee18d64c1f632043a02e6f5ba5e045bb26a5465f ("KEYS: Add a keyctl to
> install a process's session keyring on its parent [try #6]"), CONFIG_KEYS=y
> fails to build on architectures that haven't implemented TIF_NOTIFY_RESUME yet:
> 
> security/keys/keyctl.c: In function 'keyctl_session_to_parent':
> security/keys/keyctl.c:1312: error: 'TIF_NOTIFY_RESUME' undeclared (first use in this function)
> security/keys/keyctl.c:1312: error: (Each undeclared identifier is reported only once
> security/keys/keyctl.c:1312: error: for each function it appears in.)
> 
> Make KEYCTL_SESSION_TO_PARENT depend on TIF_NOTIFY_RESUME until blackfin,
> m68k, and xtensa have implemented it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@kernel.org

Looks ok to me -- once we have an ack from David, I'll add it to my tree 
and push to Linus with another fix.

> ---
> 1. This fixes a regression in 2.6.32.
> 2. Long-time build issues like this make linux-next miss newer build 
>    problems.
> 
>  security/keys/keyctl.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index 06ec722..3a9ad87 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -1236,6 +1236,7 @@ long keyctl_get_security(key_serial_t keyid,
>   */
>  long keyctl_session_to_parent(void)
>  {
> +#ifdef TIF_NOTIFY_RESUME
>  	struct task_struct *me, *parent;
>  	const struct cred *mycred, *pcred;
>  	struct cred *cred, *oldcred;
> @@ -1326,6 +1327,15 @@ not_permitted:
>  error_keyring:
>  	key_ref_put(keyring_r);
>  	return ret;
> +
> +#else /* !TIF_NOTIFY_RESUME */
> +	/*
> +	 * To be removed when TIF_NOTIFY_RESUME has been implemented on
> +	 * blackfin/m68k/xtensa
> +	 */
> +#warning TIF_NOTIFY_RESUME not implemented
> +	return -EOPNOTSUPP;
> +#endif /* !TIF_NOTIFY_RESUME */
>  }
>  
>  /*****************************************************************************/
> -- 
> 1.6.0.4
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> 

-- 
James Morris
<jmorris@namei.org>
