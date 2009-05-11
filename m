Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbZEKMSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbZEKMSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbZEKMRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:17:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344AbZEKMRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:17:51 -0400
Date: Mon, 11 May 2009 14:17:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090511121708.GD13954@elte.hu>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com> <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com> <20090511120418.GA3859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511120418.GA3859@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, May 11, 2009 at 12:12:40PM +0200, Vitaly Mayatskikh wrote:
> > +static int wait_copyout(struct wait_opts *wo, struct task_struct *p,
> > +			pid_t pid, uid_t uid, int why, int status, int signal)
> >  {
> > -	struct siginfo __user *infop;
> > +	struct siginfo __user *infop = wo->wo_info;
> >  	int retval = wo->wo_rusage
> >  		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
> >  
> > +	if (!retval && infop) {
> > +		retval = put_user(signal, &infop->si_signo);
> > +		if (!retval)
> > +			retval = put_user(0, &infop->si_errno);
> > +		if (!retval)
> > +			retval = put_user((short)why, &infop->si_code);
> > +		if (!retval)
> > +			retval = put_user(pid, &infop->si_pid);
> > +		if (!retval)
> > +			retval = put_user(uid, &infop->si_uid);
> > +		if (!retval)
> > +			retval = put_user(status, &infop->si_status);
> > +	}
> > +	return retval;
> 
> wouldn't this better be written as:
> 
> static int wait_copyout(struct wait_opts *wo, struct task_struct *p,
> 			pid_t pid, uid_t uid, int why, int status, int signal)
> {
> 	struct siginfo __user *infop = wo->wo_info;
> 
> 	if (wo->wo_rusage) {
> 		int retval = getrusage(p, RUSAGE_BOTH, wo->wo_rusage);
> 		if (retval)
> 			return retval;
> 	}
> 
> 	if (!infop)
> 		return 0;
> 
> 	if (put_user(signal, &infop->si_signo) ||
> 	    put_user(0, &infop->si_errno) ||
> 	    put_user((short)why, &infop->si_code) ||
> 	    put_user(pid, &infop->si_pid) ||
> 	    put_user(uid, &infop->si_uid) ||
> 	    put_user(status, &infop->si_status))
> 		return -EFAULT;

For best assembly code this should generally be written as a series 
of:

   __uaccess_err |= __put_user(x, ptr);
   __uaccess_err |= __put_user(y, ptr);
   __uaccess_err |= __put_user(z, ptr);

As this generates non-dependent, compressed, branch-less code.

See the (new) put_user_try / put_user_ex() / put_user_catch() 
abstraction in arch/x86/include/asm/uaccess.h, and how all the x86 
signal code makes use of that to optimize such patterns of per field 
user copies.

	Ingo
