Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZBSQLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZBSQLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZBSQKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:10:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59763 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbZBSQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:10:52 -0500
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       roland@redhat.com, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
References: <20090219030207.GA18783@us.ibm.com>
	<20090219030743.GG18990@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 08:11:06 -0800
In-Reply-To: <20090219030743.GG18990@us.ibm.com> (Sukadev Bhattiprolu's message of "Wed\, 18 Feb 2009 19\:07\:43 -0800")
Message-ID: <m1y6w21k6d.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: sukadev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, daniel@hozac.com, roland@redhat.com, oleg@tv-sign.ru, akpm@osdl.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 24 Dec 2008 14:14:18 -0800
> Subject: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns
> boundary
>
> When sending a signal to a descendant namespace, set ->si_pid to 0 since
> the sender does not have a pid in the receiver's namespace.
>
> Note:
> 	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
> 	  signal across a pid namespace boundary, the value in ->si_pid
> 	  will be cleared to 0.
>
> Changelog[v5]:
> 	- (Oleg Nesterov) Address both sys_kill() and sys_tkill() cases
> 	  in send_signal() to simplify code (this drops patch 7/7 from
> 	  earlier version of patchset).
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  kernel/signal.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index c94355b..a416d77 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -883,6 +883,8 @@ static int __send_signal(int sig, struct siginfo *info,
> struct task_struct *t,
>  			break;
>  		default:
>  			copy_siginfo(&q->info, info);
> +			if (from_ancestor_ns)
> +				q->info.si_pid = 0;

This is wrong.  siginfo is a union and you need to inspect
code to see if si_pid is present in the current union.


Eric
