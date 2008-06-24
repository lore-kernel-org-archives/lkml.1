Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYFXAue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYFXAue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYFXAuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:50:24 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:35413 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751371AbYFXAuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:50:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M4Qlk1yWxK76lxoGD+IzFoQnWRt5nfCsHHxVVn8rh8KawOCERzucg+16yEAFwIturlS4dGuxKDmhCSjBmUPSXI0AMcA7XNfBKPvIvAgce9V1IRFg/O8xrQrUFNtBOKVvWobMr+vw4V2v+LTXknJfAAPmEPSrZDArgohcih0P86Q=  ;
X-YMail-OSG: IDaOexsVM1n73DdE5_esiLIw67G5HAlAFr3a8Y0JjaFaKdNq_2XSGRjfsVkYA5S5dVO9RPpCA2ymz7sIz6S1A8fgNFEFC3e5bPPX4WP1AF.J2SqMSiT6dE4CJozKairHrOUBH96n7gsMInNLzMIV2A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at least one task has moved over
Date: Tue, 24 Jun 2008 10:50:11 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, dbahi@novell.com
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com> <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241050.12028.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 09:04, Gregory Haskins wrote:
> Inspired by Peter Zijlstra.

Is this really getting tested well? Because at least for SCHED_OTHER
tasks, the newidle balancer is still supposed to be relatively
conservative and not over balance too much. By the time you have
done all this calculation and reached here, it will be a loss to only
move one task if you could have moved two and halved your newidle
balance rate...

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/sched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3efbbc5..c8e8520 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2775,6 +2775,10 @@ static int move_tasks(struct rq *this_rq, int
> this_cpu, struct rq *busiest, max_load_move - total_load_moved,
>  				sd, idle, all_pinned, &this_best_prio);
>  		class = class->next;
> +
> +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
> +			break;
> +
>  	} while (class && max_load_move > total_load_moved);
>
>  	return total_load_moved > 0;
>
> --
