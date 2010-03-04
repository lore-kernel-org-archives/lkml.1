Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0CDHUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 02:20:32 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50335 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab0CDHUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 02:20:31 -0500
Date: Thu, 4 Mar 2010 01:20:07 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, wylda@volny.cz, gregkh@suse.de,
       jkosina@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO
 instead	of force_sig()
Message-ID: <20100304072007.GA16398@us.ibm.com>
References: <20100302201646.GA10734@redhat.com>
 <alpine.LFD.2.00.1003021223060.3616@localhost.localdomain>
 <20100303013227.4FFDE89EB@magilla.sf.frob.com>
 <alpine.LFD.2.00.1003021740560.3616@localhost.localdomain>
 <20100303112343.B89802F@magilla.sf.frob.com>
 <alpine.LFD.2.00.1003030930100.3627@localhost.localdomain>
 <20100303184412.GA7816@redhat.com>
 <alpine.LFD.2.00.1003031053050.3599@localhost.localdomain>
 <20100303193003.GA10734@redhat.com>
 <20100303202650.GA15521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303202650.GA15521@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> zap_pid_ns_processes() uses force_sig(SIGKILL) to ensure SIGKILL
> will be delivered to sub-namespace inits as well. This is correct,
> but we are going to change force_sig_info() semantics.
> See http://bugzilla.kernel.org/show_bug.cgi?id=15395#c31
> 
> We can use send_sig_info(SEND_SIG_NOINFO) instead, since
> 614c517d7c00af1b26ded20646b329397d6f51a1 SEND_SIG_NOINFO means
> "from user" and therefore send_signal() will get the correct
> from_ancestor_ns = T flag.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Justification makes sense, and (in some superficial testing, killing some
nested pid_ns's) the patch seems to do the right thing.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  kernel/pid_namespace.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> --- mm/kernel/pid_namespace.c~NS_DONT_ABUSE_FORCE	2010-02-25 15:22:13.000000000 +0100
> +++ mm/kernel/pid_namespace.c	2010-03-03 20:58:12.000000000 +0100
> @@ -161,13 +161,12 @@ void zap_pid_ns_processes(struct pid_nam
>  		rcu_read_lock();
> 
>  		/*
> -		 * Use force_sig() since it clears SIGNAL_UNKILLABLE ensuring
> -		 * any nested-container's init processes don't ignore the
> -		 * signal
> +		 * Any nested-container's init processes won't ignore the
> +		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
>  		 */
>  		task = pid_task(find_vpid(nr), PIDTYPE_PID);
>  		if (task)
> -			force_sig(SIGKILL, task);
> +			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
> 
>  		rcu_read_unlock();
> 
