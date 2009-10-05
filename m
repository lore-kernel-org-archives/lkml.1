Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZJESbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZJESbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZJESbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZJESba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:31:30 -0400
Date: Mon, 5 Oct 2009 20:25:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] signals: send_signal: use si_fromuser() to detect
	from_ancestor_ns
Message-ID: <20091005182536.GA943@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021954.GC21006@redhat.com> <20091005181255.GE30442@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005181255.GE30442@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> |
> | --- TTT_32/kernel/signal.c~FU_2_SEND_SIGNAL	2009-10-04 02:21:55.000000000 +0200
> | +++ TTT_32/kernel/signal.c	2009-10-04 03:09:44.000000000 +0200
> | @@ -928,9 +928,8 @@ static int send_signal(int sig, struct s
> |  	int from_ancestor_ns = 0;
> |
> |  #ifdef CONFIG_PID_NS
> | -	if (!is_si_special(info) && SI_FROMUSER(info) &&
> | -			task_pid_nr_ns(current, task_active_pid_ns(t)) <= 0)
> | -		from_ancestor_ns = 1;
> | +	from_ancestor_ns = si_fromuser(info) &&
> | +			   !task_pid_nr_ns(current, task_active_pid_ns(t));
>
> Makes sense. And we had mentioned earlier that container-init is immune
> to suicide but should we add a check for 'current == t' above to cover the
>
> 	send_sig(SIGKILL, current, 0);
>
> in load_aout_binary() and friends
>
> 	from_ancestor_ns = si_fromuser(info) && (current == t ||
> 				!task_pid_nr_ns(current, task_active_pid_ns(t)));

I don't think so.

First of all, this is just ugly. If we need this check we should change
the callers, not send_signal().

But more importantly, I disagree with "container-init is immune to suicide"
above. This is another issue I was going to discuss later, lets do this now.

When load_elf_binary() does send_sig(SIGKILL, current) init must die, because
we have no option. Exec failed, but we can't return to user-space with the
error code, it is too late.

So, imho this patch also fixes this case by accident, but I think it would
be better to change load_aout_binary/etc to use force_sig_info() to make
the code more explicit.

What do you think?

Oleg.

