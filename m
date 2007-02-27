Return-Path: <linux-kernel-owner+w=401wt.eu-S1750874AbXB0Vqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874AbXB0Vqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbXB0Vqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:46:49 -0500
Received: from mail.screens.ru ([213.234.233.54]:49708 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXB0Vqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:46:48 -0500
Date: Wed, 28 Feb 2007 00:46:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hugh@veritas.com, paulmck@linux.vnet.ibm.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adapt page_lock_anon_vma() to PREEMPT_RCU
Message-ID: <20070227214601.GA102@tv-sign.ru>
References: <20070225200621.GA2259@tv-sign.ru> <20070227122517.c8bceaf5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227122517.c8bceaf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Andrew Morton wrote:
>
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

Actually, we don't in this case. This patch in essence moves "preempt_enable"
from "lock" to "unlock" side. Zero impact for non-PREEMPT_RCU builds, except
.text grows a bit.

Before this patch, page_lock_anon_vma() does preempt_enable() before return,
but this can't help because ->preempt_count was incremented by spin_lock().

> Perhaps we would benefit from a new rcu_read_lock_preempt_rcu() which is a
> no-op if !PREEMPT_RCU.

I also thought about things like

	rcu_read_lock_when_we_know_that_preemption_disabled()
	rcu_read_lock_when_we_know_that_irqs_disabled()

which are noops when !PREEMPT_RCU.

Oleg.

