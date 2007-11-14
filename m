Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbXKNOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbXKNOG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXKNOGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:06:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:62469 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbXKNOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:06:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jNqtMJyHVMcGJz228Jd90kwHMzxVCjiJUVqMEJ6IHuaSOrQW4+DYCxr+ECfCX97Seh9QHyJEzhQf47oXvLa2dKgNKYWDsBAK7TIbQwobXht5GIKpLzCjqb03u3YCjQCojn3zNSHvuhyo5iKXOLMYHW/yWQ8B5wofPEF4uJU7Uqc=
Message-ID: <b647ffbd0711140606r3e258c33v287875db06138a07@mail.gmail.com>
Date: Wed, 14 Nov 2007 15:06:49 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Divide-by-zero in the 2.6.23 scheduler code
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071114135605.GC3739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473A4C0F.6070504@redhat.com> <1195046856.6924.21.camel@twins>
	 <20071114135605.GC3739@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ forwarded to the list ]

so far, just a brief inspection below...

>
> The divide-by-zero is here in kernel/sched.c:
> [ ... ]
>
>         fair_delta64 = ls->delta_fair + 1;
>         ls->delta_fair = 0;
>
>         exec_delta64 = ls->delta_exec + 1;
>         ls->delta_exec = 0;
>
>         sample_interval64 = this_rq->clock - ls->load_update_last;
>         ls->load_update_last = this_rq->clock;
>
>         if ((s64)sample_interval64 < (s64)TICK_NSEC)
>                 sample_interval64 = TICK_NSEC;
>
>         if (exec_delta64 > sample_interval64)
>                 exec_delta64 = sample_interval64;
>
>         idle_delta64 = sample_interval64 - exec_delta64;
>
> ======> tmp64 = div64_64(SCHED_LOAD_SCALE * exec_delta64, fair_delta64);

fair_delta64 == 0
and
fair_delta64 == ls->delta_fair + 1;

so obviously, i.e. ls->delta_fair == -1. delta_fair is of 'insigned
long' and calculated in

__update_curr_load() by means of calc_delta_mine().

calc_delta_mine() does in the very end:

return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);

(*) so that means, we likely got 'tmp' > (unsigned long)LONG_MAX in
calc_delta_mine()...

btw.,

- fair_delta64 == ls->delta_fair + 1;
+ fair_delta64 == (u64)ls->delta_fair + 1;

in update_cpu_load() would avoid the problem, I guess (and perhaps,
can be legitimate, logically-wise).

maybe on the system with low HZ value (I can't see the kernel config
immediately on the bugzilla page) and a task niced to the lowest
priority (is this 'kjournald' mentioned in the report of lower prio? )
running for a full tick, 'tmp' can be such a big value... hmm?


-- 
Best regards,
Dmitry Adamushko
