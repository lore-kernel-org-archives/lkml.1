Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXKTGoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXKTGoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXKTGnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:43:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527AbXKTGnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:43:53 -0500
Date: Mon, 19 Nov 2007 22:43:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] wait_task_stopped: pass correct exit_code to
 wait_noreap_copyout
Message-Id: <20071119224326.198f77a0.akpm@linux-foundation.org>
In-Reply-To: <1195377204.6070.3.camel@wing-commander>
References: <1195377204.6070.3.camel@wing-commander>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 09:13:24 +0000 Scott James Remnant <scott@ubuntu.com> wrote:

> In wait_task_stopped() exit_code already contains the right value for
> the si_status member of siginfo, and this is simply set in the non
> WNOWAIT case.
>     
> Pass it unchanged to wait_noreap_copyout();  we would only need to
> shift it and add 0x7f if we were returning it in the user status field
> and that isn't used for any function that permits WNOWAIT.
>     
> Signed-off-by: Scott James Remnant <scott@ubuntu.com>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Roland McGrath <roland@redhat.com>
> 
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1389,7 +1389,7 @@ static int wait_task_stopped(struct task_struct
> *p, int delayed_group_leader,
>  		if (unlikely(!exit_code) || unlikely(p->exit_state))
>  			goto bail_ref;
>  		return wait_noreap_copyout(p, pid, uid,
> -					   why, (exit_code << 8) | 0x7f,
> +					   why, exit_code,
>  					   infop, ru);
>  	}

Is this bug visible to userspace?  If so, I'm surprised that none of the
various testsuites (which like to exercise this sort of interface) has
detected it.

