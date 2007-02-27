Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXB0XNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXB0XNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXB0XNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:13:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53210 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXB0XNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:13:20 -0500
Date: Tue, 27 Feb 2007 15:13:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, hugh@veritas.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adapt page_lock_anon_vma() to PREEMPT_RCU
Message-ID: <20070227231315.GC1919@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070225200621.GA2259@tv-sign.ru> <20070227122517.c8bceaf5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227122517.c8bceaf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 12:25:17PM -0800, Andrew Morton wrote:
> > On Sun, 25 Feb 2007 23:06:21 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > page_lock_anon_vma() uses spin_lock() to block RCU. This doesn't work with
> > PREEMPT_RCU, we have to do rcu_read_lock() explicitely. Otherwise, it is
> > theoretically possible that slab returns anon_vma's memory to the system
> > before we do spin_unlock(&anon_vma->lock).
> > 
> > ...
> >
> > +static void page_unlock_anon_vma(struct anon_vma *anon_vma)
> > +{
> > +	spin_unlock(&anon_vma->lock);
> > +	rcu_read_unlock();
> >  }
> 
> It's a bit sad doing a double preempt_disable() for non-PREEMPT_RCU builds.
> 
> Perhaps we would benefit from a new rcu_read_lock_preempt_rcu() which is a
> no-op if !PREEMPT_RCU.

We were doing double preempt_disable() before as well.  The only
difference is that we moved RCU preempt_enable() (it used to be inside the
critical section, and now it is after the corresponding spin_unlock()).

I hope to keep RCU API proliferation down to a dull roar, but if we
need more APIs, we need more APIs.  This example does not demonstrate
that need to me, however.

						Thanx, Paul
