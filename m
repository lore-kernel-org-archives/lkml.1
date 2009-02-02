Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZBBTH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZBBTH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZBBTHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:07:46 -0500
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:56678 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752701AbZBBTHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:07:45 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 2 Feb 2009 19:06:25 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: 2.6.26.8-rt15
Message-ID: <20090202190625.GA7742@hades.domain.com>
References: <1233387250.922.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233387250.922.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 02:34:10AM -0500, Steven Rostedt wrote:
> We are pleased to announce the 2.6.26.8-rt15 tree which can be
> downloaded from the following location:
> 
>   http://rt.et.redhat.com/download/
> 
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page

I'm having compilation issues with this new patch.  Here's the error I got:

In file included from
/root/lmcorrei/linux/linux-2.6.26.8-rt15/kernel/sched.c:1701:
/root/lmcorrei/linux/linux-2.6.26.8-rt15/kernel/sched_rt.c: In
function 'inc_rt_tasks':
/root/lmcorrei/linux/linux-2.6.26.8-rt15/kernel/sched_rt.c:434: error:
'struct rq' has no member named 'online'

Now, function in question has the following code:

static inline
void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
{
        WARN_ON(!rt_prio(rt_se_prio(rt_se)));
        rt_rq->rt_nr_running++;
#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
        if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
                struct rq *rq = rq_of_rt_rq(rt_rq);
                rt_rq->highest_prio = rt_se_prio(rt_se);

                if (rq->online)
                        cpupri_set(&rq->rd->cpupri, rq->cpu,
                                   rt_se_prio(rt_se));
        }
#endif

The issue is that the 'online' member is actually defined only if CONFIG_SMP is
enabled and in my config I do not have it but I have CONFIG_RT_GROUP_SCHED.

I am not sending any patch because I actually do not know what is the best way
to solve this issue since I am not (yet!) a sched expert.  However, I forsee two
possible solutions:

 1. Nest another #ifdef inside the first one, so that the code is only compiled
    when CONFIG_SMP option is set (which will result in ugly code)
 2. Define 'online' member in structure outside of the CONFIG_SMP (which, I
    believe, is not an optimal solution)

Regards,
-- 
Luis Henriques

