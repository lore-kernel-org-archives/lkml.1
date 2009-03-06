Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZCFLIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZCFLIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZCFLIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:08:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZCFLIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:08:14 -0500
Date: Fri, 6 Mar 2009 12:08:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH for tip][bugfix] ftrace: fix deadlock when setting
	set_ftrace_pid
Message-ID: <20090306110800.GF21168@elte.hu>
References: <20090306151155.0778.A69D9226@jp.fujitsu.com> <49B0C94E.6020300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0C94E.6020300@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> KOSAKI Motohiro wrote:
> > Impact: fix deadlock bug
> > 
> > reproduce way:
> > 	# cd /sys/kernel/debug/tracing
> > 	# echo $$ > set_ftrace_pid
> > 
> > 	then, console become hangup.
> > 
> > detail:
> > when writing set_ftracepid, kernel callstack is following
> > 
> > 	ftrace_pid_write()
> > 		mutex_lock(&ftrace_lock);
> > 		ftrace_update_pid_func()
> > 			mutex_lock(&ftrace_lock);
> > 			mutex_unlock(&ftrace_lock);
> > 		mutex_unlock(&ftrace_lock);
> > 
> > then, system alaways deadlock when ftrace_pid_write() is called.
> > 
> > In past days, ftrace_pid_write() use ftrace_start_lock, but
> > commit e6ea44e9b4c12325337cd1c06103cd515a1c02b2 consolidate
> > ftrace_start_lock to ftrace_lock.
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 5a3a06b..0d3b393 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -218,10 +218,8 @@ static void ftrace_update_pid_func(void)
> >  {
> >  	ftrace_func_t func;
> >  
> > -	mutex_lock(&ftrace_lock);
> > -
> >  	if (ftrace_trace_function == ftrace_stub)
> > -		goto out;
> > +		return;
> >  
> >  	func = ftrace_trace_function;
> >  
> > @@ -238,9 +236,6 @@ static void ftrace_update_pid_func(void)
> >  #else
> >  	__ftrace_trace_function = func;
> >  #endif
> > -
> > - out:
> > -	mutex_unlock(&ftrace_lock);
> >  }
> >  
> >  /* set when tracing only a pid */
> > 
> > 
> 
> Reviewed-By: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied, thanks!

	Ingo
