Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0BJPpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:45:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab0BJPpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:45:14 -0500
Date: Wed, 10 Feb 2010 16:43:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 2/4] x86, ptrace: regset extensions to support xstate
Message-ID: <20100210154333.GB26654@redhat.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com> <20100209202502.216592031@sbs-t61.sc.intel.com> <20100210112822.GB4546@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210112822.GB4546@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Oleg Nesterov wrote:
>
> On 02/09, Suresh Siddha wrote:
> >
> > +int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
> > +		unsigned int pos, unsigned int count,
> > +		void *kbuf, void __user *ubuf)
> > +{
> > +	int ret;
> > +	int size = regset->n * regset->size;
> > +	struct xsave_hdr_struct *xsave_hdr =
> > +				&target->thread.xstate->xsave.xsave_hdr;
> > +
> > +	if (!cpu_has_xsave)
> > +		return -ENODEV;
> > +
> > +	ret = init_fpu(target);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * First copy the fxsave bytes 0..463
> > +	 */
> > +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > +				  &target->thread.xstate->xsave, 0,
> > +				  offsetof(struct i387_fxsave_struct,
> > +					   sw_reserved));
> > +	if (!ret)
> > +		/*
> > +		 * Copy the 48bytes defined by software
> > +		 */
> > +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > +					  xstate_fx_sw_bytes,
> > +					  offsetof(struct i387_fxsave_struct,
> > +						   sw_reserved),
> > +					  offsetof(struct xsave_struct,
> > +						   xsave_hdr));
>
> Hmm. Suresh, could you confirm these offsetof's are correct?
>
> We are copying xstate_fx_sw_bytes array which is u64[6], but
> start_pos == sizeof(i387_fxsave_struct) - padding ?

Sorry for noise. Now I see this should be correct, see another email I sent.

In fact, unless I missed something again, the 2nd and 3rd _copyout's could
use pos as start_pos instead of offsetof(what_we_already_copied).

Oleg.

