Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZJDCXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZJDCXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 22:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZJDCXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 22:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZJDCXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 22:23:40 -0400
Date: Sun, 4 Oct 2009 04:18:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Was: pidns : PR_SET_PDEATHSIG + SIGKILL regression
Message-ID: <20091004021844.GA21006@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003171029.GA30442@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Sukadev Bhattiprolu wrote:
>
>  static void reparent_thread(struct task_struct *father, struct task_struct *p,
>  				struct list_head *dead)
>  {
> -	if (p->pdeath_signal)
> -		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
> +	if (p->pdeath_signal) {
> +		struct siginfo info;
> +
> +		info.si_code = SI_USER;
> +		info.si_signo = p->pdeath_signal;
> +		info.si_errno = 0;
> +
> +		rcu_read_lock();
> +		info.si_pid = task_tgid_nr_ns(father, task_active_pid_ns(p));
> +		info.si_uid = __task_cred(father)->uid;
> +		rcu_read_unlock();
> +
> +		group_send_sig_info(p->pdeath_signal, &info, p);
> +	}

I think the patch is correct.

But afaics we should clarify the "from user" semantics and fix
send_signal() instead.

What do you think about this simple series? (the last 2 patches
are pure cosmetic and off-topic).

Oleg.

