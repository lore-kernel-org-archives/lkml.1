Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZBQXwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZBQXwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZBQXw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:52:26 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:28716 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZBQXwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:52:25 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
Date: Tue, 17 Feb 2009 18:52:20 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <fa.3IBoeBnwT1eZcqeO6DAE1tHBYc4@ifi.uio.no> <499B178B.9090601@numericable.fr>
In-Reply-To: <499B178B.9090601@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171852.21061.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 03:01:15 pm etienne wrote:
> I realize this patch is a little ugly, a cleaner way would be to insert 
> struct smk_netlbladdr sorted from longest to smallest mask and break the
> loop as soon as we have a match... regards,

Agreed, the address matching code really should be improved; if you feel like 
you could contribute the changes I'm pretty sure Casey would welcome the 
patches :)

Regarding your fix below, I think a cleaner solution would be to do something 
like the following in place of the existing mask check ...

	if ((miap->s_addr & bestmask.s_addr) || (bestmask.s_addr == 0)) {
		bestmask.s_addr = miap->s_addr;
		bestlabel = snp->smk_label;
	}	

... however there is one small problem with this approach (your proposal 
suffers from the same issue): normally the smack_host_label() code prefers the 
first matching entry in the list, the change above preserves that with the 
exception of a 0.0.0.0/0 entry.  Granted, you shouldn't allow that in the 
first place but I believe it is possible so it is something that needs to be 
taken into consideration.

> Signed-off-by: Etienne <etienne.basset@numericable.fr>
> ------
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0278bc0..9d2576d 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1540,7 +1540,7 @@ static char *smack_host_label(struct sockaddr_in
> *sip) * If the list entry mask is less specific than the best * already
> found this entry is uninteresting.
>                  */
> -               if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
> +               if ( ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
> &&  (miap->s_addr | bestmask.s_addr) != 0  ) continue;
>                 /*
>                  * This is better than any entry found so far.
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-security-module" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
paul moore
linux @ hp

