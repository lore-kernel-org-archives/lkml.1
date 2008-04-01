Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYDAVbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYDAVbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYDAVax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:30:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59462 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYDAVax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:30:53 -0400
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrea Arcangeli <andrea@qumranet.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080401205635.793766935@sgi.com>
References: <20080401205531.986291575@sgi.com>
	 <20080401205635.793766935@sgi.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 23:14:40 +0200
Message-Id: <1207084480.29991.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Christoph, why are your CCs so often messed up?)

On Tue, 2008-04-01 at 13:55 -0700, Christoph Lameter wrote:
> plain text document attachment (emm_notifier)

> +/* Register a notifier */
> +void emm_notifier_register(struct emm_notifier *e, struct mm_struct *mm)
> +{
> +	e->next = mm->emm_notifier;
> +	/*
> +	 * The update to emm_notifier (e->next) must be visible
> +	 * before the pointer becomes visible.
> +	 * rcu_assign_pointer() does exactly what we need.
> +	 */
> +	rcu_assign_pointer(mm->emm_notifier, e);
> +}
> +EXPORT_SYMBOL_GPL(emm_notifier_register);
> +
> +/* Perform a callback */
> +int __emm_notify(struct mm_struct *mm, enum emm_operation op,
> +		unsigned long start, unsigned long end)
> +{
> +	struct emm_notifier *e = rcu_dereference(mm)->emm_notifier;
> +	int x;
> +
> +	while (e) {
> +
> +		if (e->callback) {
> +			x = e->callback(e, mm, op, start, end);
> +			if (x)
> +				return x;
> +		}
> +		/*
> +		 * emm_notifier contents (e) must be fetched after
> +		 * the retrival of the pointer to the notifier.
> +		 */
> +		e = rcu_dereference(e)->next;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__emm_notify);
> +#endif

Those rcu_dereference()s are wrong. They should read:

  e = rcu_dereference(mm->emm_notifier);

and

  e = rcu_dereference(e->next);



