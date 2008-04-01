Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbYDAVil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbYDAVil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760655AbYDAViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:38:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40978 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761319AbYDAViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:38:14 -0400
Date: Tue, 1 Apr 2008 14:38:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Andrea Arcangeli <andrea@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
Message-ID: <20080401213811.GD8558@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <1207084480.29991.2.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207084480.29991.2.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 11:14:40PM +0200, Peter Zijlstra wrote:
> (Christoph, why are your CCs so often messed up?)
> 
> On Tue, 2008-04-01 at 13:55 -0700, Christoph Lameter wrote:
> > plain text document attachment (emm_notifier)
> 
> > +/* Register a notifier */
> > +void emm_notifier_register(struct emm_notifier *e, struct mm_struct *mm)
> > +{
> > +	e->next = mm->emm_notifier;
> > +	/*
> > +	 * The update to emm_notifier (e->next) must be visible
> > +	 * before the pointer becomes visible.
> > +	 * rcu_assign_pointer() does exactly what we need.
> > +	 */
> > +	rcu_assign_pointer(mm->emm_notifier, e);
> > +}
> > +EXPORT_SYMBOL_GPL(emm_notifier_register);
> > +
> > +/* Perform a callback */
> > +int __emm_notify(struct mm_struct *mm, enum emm_operation op,
> > +		unsigned long start, unsigned long end)
> > +{
> > +	struct emm_notifier *e = rcu_dereference(mm)->emm_notifier;
> > +	int x;
> > +
> > +	while (e) {
> > +
> > +		if (e->callback) {
> > +			x = e->callback(e, mm, op, start, end);
> > +			if (x)
> > +				return x;
> > +		}
> > +		/*
> > +		 * emm_notifier contents (e) must be fetched after
> > +		 * the retrival of the pointer to the notifier.
> > +		 */
> > +		e = rcu_dereference(e)->next;
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__emm_notify);
> > +#endif
> 
> Those rcu_dereference()s are wrong. They should read:
> 
>   e = rcu_dereference(mm->emm_notifier);
> 
> and
> 
>   e = rcu_dereference(e->next);

Peter has it right.  You need to rcu_dereference() the same thing that
you rcu_assign_pointer() to.

							Thanx, Paul
