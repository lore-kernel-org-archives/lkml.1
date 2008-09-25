Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYIYS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYIYS1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYIYS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:27:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47703 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYIYS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:27:08 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Tilman Baumann <tilman.baumann@collax.com>
Subject: Re: SMACK netfilter smacklabel socket match
Date: Thu, 25 Sep 2008 14:26:58 -0400
User-Agent: KMail/1.9.9
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
References: <48DBC9A1.20900@collax.com>
In-Reply-To: <48DBC9A1.20900@collax.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251426.58179.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008 1:25:53 pm Tilman Baumann wrote:
> Hi all,

Hello.

> i made some SMACK related patches. I hope this list is the right
> place to post them.

Most Smack development has taken place on the LSM mailing list.  At the 
very least I would recommend you CC the LSM list when sending Smack 
patches.  I've taken the liberty of CC'ing both the LSM list and Casey 
on this email.

> The intention behind this patch is that i needed a way to (firewall)
> match for packets originating from specific processes.
> The existing owner match did not work well enough, especially since
> the cmd-owner part is removed.
> Then i thought about a way to tag processes and somehow match this
> tag in the firewall.
> I recalled that SELinux can do this (SECMARK) but SELinux would have
> been way to complex for what i want. But the idea was born, i just
> needed something more simple.

It appears the simplest option would be to provide the necessary SECMARK 
support in Smack.  SECMARK has provisions for supporting different 
types of LSMs and adding Smack support should be relatively trivial.  
In fact, it is possible for SECMARK to be made entirely LSM agnostic 
and have it deal strictly with secctx/label and secid/token values.  We 
would need to retain the SELinux specific interface for 
legacy/compatibility reasons but I would encourage new patches to take 
this more general approach rather than LSM specific extension.

> SMACK seemed to be the right way. So i made a little primitive
> netfilter match to match against the security context of sockets.
> SMACK does CIPSO labels, but this was not what i wanted, i wanted to
> label the socket not the packet (on the wire).

I would encourage you to look at selinux_ip_postroute() since it does 
exactly what you describe above using the SECMARK mechanism (in 
addition to other work).  In particular look at the following code 
snippet:

        sk = skb->sk;
        if (sk) {
                struct sk_security_struct *sksec = sk->sk_security;
                peer_sid = sksec->sid;
                secmark_perm = PACKET__SEND;
        } else {
                if (selinux_skb_peerlbl_sid(skb, family, &peer_sid))
                                return NF_DROP;
                secmark_perm = PACKET__FORWARD_OUT;
        }

        if (secmark_active)
                if (avc_has_perm(peer_sid, skb->secmark,
                                 SECCLASS_PACKET, secmark_perm, &ad))
                        return NF_DROP;

In the first if block you see that we are actually getting the security 
label from the socket, _not_ the packet, and then using that to perform 
the access control decision with avc_has_perm().  It should be easy to 
do the same with Smack and SECMARK.

[NOTE: you may notice the above code changing slightly in future 
kernels, it turns out that skb->sk == NULL is not a true indicator of a 
non-local sender, see my labeled networking patches for 2.6.28 or 
linux-next for the revised approach]

> This of course only works for packets with a local socket, but this
> was my intention anyway.

You could also expand it to handle non-local senders.  However, from my 
discussions with Casey about Smack and network access controls, 
enforcing policy against forwarded traffic is not something he is 
interested in at this point.

> I have no kernel coding experience whatsoever and little C coding
> history. So i would really like you guys to look over it a bit.

[NOTE: you will want to post your patches inline in the future, sending 
patches as attachments are frowned upon]

Okay, I'll make a few comments on the kernel patch, you would probably 
want to ask the netfilter folks for comments on both patches.  However, 
please keep in mind that I do not currently see a reason why you 
couldn't achieve your needs with the existing SECMARK code (with some 
modification/extension), please pursue that option before continuing 
with a dedicated SMACK target for netfilter.

A few comments on your patch:

> From 1c79c7c413dd3ebd72dbe12e1133037c6ea223af Mon Sep 17 00:00:00
> 2001 From: Tilman Baumann <tilman.baumann@collax.com>
> Date: Thu, 25 Sep 2008 19:07:37 +0200
> Subject: [PATCH] SMACK netfilter socket label match
>
>
> Signed-off-by: Tilman Baumann <tilman.baumann@collax.com>
> ---
>  include/linux/netfilter/Kbuild     |    1 +
>  include/linux/netfilter/xt_smack.h |   21 +++++++++
>  net/netfilter/Kconfig              |   10 +++++
>  net/netfilter/Makefile             |    1 +
>  net/netfilter/xt_smack.c           |   79
> ++++++++++++++++++++++++++++++++++++ 5 files changed, 112
> insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/netfilter/xt_smack.h
>  create mode 100644 net/netfilter/xt_smack.c

...

> --- /dev/null
> +++ b/net/netfilter/xt_smack.c
> @@ -0,0 +1,79 @@
> +/*
> + * Kernel module to match against SMACK labels
> + *
> + * (C) 2008 Tilman Baumann <tilman.baumann@collax.com>
> + *
> + * This program is free software; you can redistribute it and/or
> modify + * it under the terms of the GNU General Public License
> version 2 as + * published by the Free Software Foundation.
> + */
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/file.h>
> +#include <net/sock.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_smack.h>
> +#include <../security/smack/smack.h>

If you need a Smack specific interface you shouldn't include a file from 
security/smack, instead you should use/create an interface in 
include/linux/smack.h.  In this particular case this would mean 
creating the file.

> +static bool
> +smack_mt(const struct sk_buff *skb, const struct net_device *in,
> +         const struct net_device *out, const struct xt_match *match,
> +         const void *matchinfo, int offset, unsigned int protoff,
> +         bool *hotdrop)
> +{
> +	const struct xt_smack_match_info *info = matchinfo;
> +	struct socket_smack *smacks;
> +
> +	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
> +		return (info->mask ^ info->invert) == 0;
> +	smacks = skb->sk->sk_security;
> +	if (smacks == NULL){
> +		 return (info->mask ^ info->invert);
> +	}
> +
> +	if(info->mask & XT_SMACK_IN){
> +		return ! ((!strncmp(smacks->smk_in, info->match_in, SMK_LABELLEN))
> ^ +			(info->invert & XT_SMACK_IN));
> +	}
> +
> +	if(info->mask & XT_SMACK_OUT){
> +		return ! ((!strncmp(smacks->smk_in, info->match_out,
> SMK_LABELLEN)) ^ +			(info->invert & XT_SMACK_OUT));
> +	}
> +
> +	if(info->mask & XT_SMACK_PEER){
> +		return ! ((!strncmp(smacks->smk_packet, info->match_peer_packet,
> SMK_LABELLEN)) ^ +			(info->invert & XT_SMACK_IN));
> +	}

I don't like how the access control is being done outside of the Smack 
LSM; once again I would encourage you to further investigate the 
approach taken by SECMARK.  If you must do access control outside of 
the LSM then please at least abstract the actual access control 
decision, in this case strncmp(), to a LSM interface.

-- 
paul moore
linux @ hp
