Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZL0DNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZL0DNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 22:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZL0DNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 22:13:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZL0DNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 22:13:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=ko6EdxNdcCcA:10 a=Op-mwl0xAAAA:8 a=tpc2gLB6XL8vKuoJyD4A:9 a=EXntZn3IKx_apzsdnqUA:7 a=AErYG5wyx7Z1XsuIzD-3zGFeu7sA:4 a=d4CUUju0HPYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Sat, 26 Dec 2009 21:26:04 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/3] Security: Add disablenetwork interface. (v4)
Message-ID: <20091227032604.GB17629@hallyn.com>
References: <20091227010441.GA12077@heat> <20091227010640.GA12173@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227010640.GA12173@heat>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> Daniel Bernstein has observed [1] that security-conscious userland processes
> may benefit from the ability to irrevocably remove their ability to create,
> bind, connect to, or send messages except in the case of previously connected
> sockets or AF_UNIX filesystem sockets.
> 
> This patch provides
> 
>    * a new configuration option named CONFIG_SECURITY_DISABLENETWORK,
>    * a new prctl option-pair (PR_SET_NETWORK, PR_GET_NETWORK),
>    * a new prctl(PR_SET_NETWORK) flag named PR_NETWORK_OFF, and
>    * a new task_struct flags field named "network"
> 
> Signed-off-by: Michael Stone <michael@laptop.org>
> ---
>   include/linux/prctl.h         |    7 +++++
>   include/linux/prctl_network.h |    7 +++++
>   include/linux/sched.h         |    4 +++
>   kernel/sys.c                  |   53 +++++++++++++++++++++++++++++++++++++++++
>   security/Kconfig              |   11 ++++++++
>   5 files changed, 82 insertions(+), 0 deletions(-)
>   create mode 100644 include/linux/prctl_network.h
> 
> diff --git a/include/linux/prctl.h b/include/linux/prctl.h
> index a3baeb2..4eb4110 100644
> --- a/include/linux/prctl.h
> +++ b/include/linux/prctl.h
> @@ -102,4 +102,11 @@
>   
>   #define PR_MCE_KILL_GET 34
>   
> +/* Get/set process disable-network flags */
> +#define PR_SET_NETWORK	35
> +#define PR_GET_NETWORK	36
> +# define PR_NETWORK_ON        0
> +# define PR_NETWORK_OFF       1
> +# define PR_NETWORK_ALL_FLAGS 1
> +
>   #endif /* _LINUX_PRCTL_H */
> diff --git a/include/linux/prctl_network.h b/include/linux/prctl_network.h
> new file mode 100644
> index 0000000..d18f8cb
> --- /dev/null
> +++ b/include/linux/prctl_network.h
> @@ -0,0 +1,7 @@
> +#ifndef _LINUX_PRCTL_NETWORK_H
> +#define _LINUX_PRCTL_NETWORK_H
> +
> +extern long prctl_get_network(unsigned long*);
> +extern long prctl_set_network(unsigned long*);
> +
> +#endif /* _LINUX_PRCTL_NETWORK_H */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f2f842d..6fcaef8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1403,6 +1403,10 @@ struct task_struct {
>   #endif
>   	seccomp_t seccomp;
>   
> +#ifdef CONFIG_SECURITY_DISABLENETWORK
> +  unsigned long network;
> +#endif
> +
>   /* Thread group tracking */
>      	u32 parent_exec_id;
>      	u32 self_exec_id;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 26a6b73..b48f021 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -35,6 +35,7 @@
>   #include <linux/cpu.h>
>   #include <linux/ptrace.h>
>   #include <linux/fs_struct.h>
> +#include <linux/prctl_network.h>
>   
>   #include <linux/compat.h>
>   #include <linux/syscalls.h>
> @@ -1578,6 +1579,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>   			else
>   				error = PR_MCE_KILL_DEFAULT;
>   			break;
> +		case PR_SET_NETWORK:
> +			error = prctl_set_network((unsigned long*)arg2);
> +			break;
> +		case PR_GET_NETWORK:
> +			error = prctl_get_network((unsigned long*)arg2);
> +			break;

Is there any reason not to handle these in
	disablenetwork_security_prctl()
?

Other than that, this looks quite good to me...  (No need to
initialize ret=0 in your security_* updates, to get pedantic,
that's all I noticed)

I'll give it a closer look on monday before I ack.

thanks,
-serge
