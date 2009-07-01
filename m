Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZGAX1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZGAX1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZGAX1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:27:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49226 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZGAX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:27:41 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20090701073140.GA14284@us.ibm.com>
	<20090701074654.A6C6321D57@magilla.sf.frob.com>
	<20090701082452.GA3297@redhat.com> <20090701214805.GA25734@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 01 Jul 2009 16:27:38 -0700
In-Reply-To: <20090701214805.GA25734@us.ibm.com> (Sukadev Bhattiprolu's message of "Wed\, 1 Jul 2009 14\:48\:05 -0700")
Message-ID: <m1zlbooufp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: sukadev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, adobriyan@gmail.com, serue@us.ibm.com, orenl@cs.columbia.edu, roland@redhat.com, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> | This won't fix the problem. The child won't autoreap itself if ->exit_signal
> | != SIGCHLD.
> | 
> | > If you want to make this change because of container-init issues, I think
> | > you should just say so independent of this global-init case.
> | 
> | Yes, agreed, the comment looks confusing.
> | 
> | Oleg
>
> Here is an updated patch with comments fixed.
>
> Roland pls ack again if this is better.
>
> ---
>
> Disable CLONE_PARENT for init.
>
> When global or container-init processes use CLONE_PARENT, they create a
> multi-rooted process tree. Besides if the siblings of init exit, the
> SIGCHLD is not sent to init process resulting in the zombies sticking
> around indefinitely.
>
> Changelog[v3]:
> 	- [Roland, Oleg] Simplify comment describing the change
> Changelog[v2]:
> 	- Simplify patch description based on comments from Eric Biederman
> 	  and Oleg Nesterov.
> 	- [Oleg Nesterov] Use SIGNAL_UNKILLABLE instead of is_global_init()
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>  kernel/fork.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> Index: linux-mmotm/kernel/fork.c
> ===================================================================
> --- linux-mmotm.orig/kernel/fork.c	2009-06-30 23:01:06.000000000 -0700
> +++ linux-mmotm/kernel/fork.c	2009-07-01 14:43:10.000000000 -0700
> @@ -974,6 +974,14 @@ static struct task_struct *copy_process(
>  	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
>  		return ERR_PTR(-EINVAL);
>  
> +	/*
> +	 * To avoid multi-rooted process-trees prevent global and container
> +	 * inits from creating siblings.
> +	 */
> +	if ((clone_flags & CLONE_PARENT) &&
> +				current->signal->flags & SIGNAL_UNKILLABLE)
> +		return ERR_PTR(-EINVAL);
> +
>  	retval = security_task_create(clone_flags);
>  	if (retval)
>  		goto fork_out;
