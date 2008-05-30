Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYE3Xpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYE3Xpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYE3Xp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:45:28 -0400
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:44500 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752412AbYE3Xp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:45:27 -0400
X-YMail-OSG: XwZNDsUVM1k_0Itipyude6sYtUjSY_Odgg.4F5vjTQAVPz.RmbAQrOgFVEwr3FJyTA--
X-RocketYMMF: rancidfat
Date: Fri, 30 May 2008 16:45:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH BUGFIX -v2 -rc4] Smack: Respect 'unlabeled' netlabel mode
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080530235751.GA6888@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <902960.53844.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi!,
> 
> [ Sorry, Fix: Acquire smack_ambient_lock before reading smack_net_ambient ]
> 
> -->
> 
> In case of Smack 'unlabeled' netlabel option, Smack passes a _zero_
> initialized 'secattr' to label a packet/sock. This causes an 
> [unfound domain label error]/-ENOENT by netlbl_sock_setattr().
> Above Netlabel failure leads to Smack socket hooks failure causing 
> an always-on socket() -EPERM error.
> 
> Such packets should have a netlabel domain agreed with netlabel to 
> represent unlabeled packets. Fortunately Smack net ambient label 
> packets are agreed with netlabel to be treated as unlabeled packets. 
> 
> Treat all packets coming out from a 'unlabeled' Smack system as
> coming from the smack net ambient label.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 4a4477f..81b94ba 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -16,6 +16,7 @@
>  #include <linux/capability.h>
>  #include <linux/spinlock.h>
>  #include <linux/security.h>
> +#include <linux/mutex.h>
>  #include <net/netlabel.h>
>  
>  /*
> @@ -178,6 +179,7 @@ u32 smack_to_secid(const char *);
>  extern int smack_cipso_direct;
>  extern int smack_net_nltype;
>  extern char *smack_net_ambient;
> +extern struct mutex smack_ambient_lock;
>  
>  extern struct smack_known *smack_known;
>  extern struct smack_known smack_known_floor;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index b5c8f92..0d9c7dc 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1292,6 +1292,11 @@ static void smack_to_secattr(char *smack, struct
> netlbl_lsm_secattr *nlsp)
>  		}
>  		break;
>  	default:
> +		mutex_lock(&smack_ambient_lock);
> +		nlsp->domain = kstrdup(smack_net_ambient, GFP_ATOMIC);
> +		mutex_unlock(&smack_ambient_lock);
> +
> +		nlsp->flags = NETLBL_SECATTR_DOMAIN;
>  		break;
>  	}
>  }

This is truely awful. I suggest that instead of doing this
locking you disallow changes to the ambient label if the
nltype is not a well handled type, that is, CIPSO. The overhead
you're introducing to handle a case that will cause the system
to be pretty well useless (if ambient isn't the floor label
your system isn't going to work very well) seems ill advised.

> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 271a835..cc357dc 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -46,7 +46,7 @@ enum smk_inos {
>   */
>  static DEFINE_MUTEX(smack_list_lock);
>  static DEFINE_MUTEX(smack_cipso_lock);
> -static DEFINE_MUTEX(smack_ambient_lock);
> +DEFINE_MUTEX(smack_ambient_lock);
>  
>  /*
>   * This is the "ambient" label for network traffic.
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> 


Casey Schaufler
casey@schaufler-ca.com
