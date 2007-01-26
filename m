Return-Path: <linux-kernel-owner+w=401wt.eu-S1161025AbXAZKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025AbXAZKIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161026AbXAZKIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:08:19 -0500
Received: from mail.screens.ru ([213.234.233.54]:50778 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161025AbXAZKIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:08:18 -0500
Date: Fri, 26 Jan 2007 13:08:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: S?bastien Dugu? <sebastien.dugue@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + make-good_sigevent-non-static.patch added to -mm tree
Message-ID: <20070126100801.GA94@tv-sign.ru>
References: <20070125154324.GA183@tv-sign.ru> <20070126103208.78c4937f@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070126103208.78c4937f@frecb000686>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, S?bastien Dugu? wrote:
>
> On Thu, 25 Jan 2007 18:43:24 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Sébastien Dugué wrote:
> > >
> > > +struct task_struct *good_sigevent(sigevent_t *event)
> > > +{
> > > +	struct task_struct *task = current->group_leader;
> > > +
> > > +	if ((event->sigev_notify & SIGEV_THREAD_ID) == SIGEV_THREAD_ID) {
> > > +		task = find_task_by_pid(event->sigev_notify_thread_id);
> > > +
> > > +		if (!task || task->tgid != current->tgid)
> > > +			return NULL;
> > > +	} else if (event->sigev_notify == SIGEV_SIGNAL) {
> > 
> > No, no, we can't use "else" here,
> > 
> > > +		if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
> > 
> > because we skip the check above in SIGEV_THREAD_ID case.
> 
>   Right, will fix this.
> 
> > 
> > This way any user can crash the kernel with a minimal effort.
> 
>   Well I tried, no crash, just the signal failing to be delivered.

	sigaddset:

		set->sig[sig / _NSIG_BPW] |= 1UL << (sig % _NSIG_BPW);

This writes to ->sig[event->sigev_signo / _NSIG_BPW] location, so we can
corrupt the memory if ->sigev_signo > _NSIG.

Btw, since you are exporting this function, may I suggest to rename it?
No, I can't suggest a better name :) But "good_sigevent" is a bit confusing
imho.

Oleg.

