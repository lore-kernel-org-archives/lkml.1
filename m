Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYFFQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYFFQ0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYFFQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:26:09 -0400
Received: from mx1.suse.de ([195.135.220.2]:48630 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYFFQ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:26:08 -0400
Date: Fri, 6 Jun 2008 18:26:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 3/7] mm: speculative page references
Message-ID: <20080606162603.GB23939@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net> <20080605094825.699347000@nick.local0.net> <1212762004.23439.119.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212762004.23439.119.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 04:20:04PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-06-05 at 19:43 +1000, npiggin@suse.de wrote:
> > plain text document attachment (mm-speculative-get_page-hugh.patch)
> 
> > +static inline int page_cache_get_speculative(struct page *page)
> > +{
> > +	VM_BUG_ON(in_interrupt());
> > +
> > +#ifndef CONFIG_SMP
> > +# ifdef CONFIG_PREEMPT
> > +	VM_BUG_ON(!in_atomic());
> > +# endif
> > +	/*
> > +	 * Preempt must be disabled here - we rely on rcu_read_lock doing
> > +	 * this for us.
> 
> Preemptible RCU is already in the tree, so I guess you'll have to
> explcitly disable preemption if you require it.
 
Oh, of course, I forget about preempt RCU, lucky for the comment.
Good spotting.

--
As per the comment here, we can only use that shortcut if rcu_read_lock
disabled preemption. It would be somewhat annoying to have to put
preempt_disable/preempt_enable around all callers in order to support
this, but preempt RCU isn't going to be hugely performance critical
anyway (and actually it actively trades performance for fewer preempt off
sections), so it can use the slightly slower path quite happily.

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -111,7 +111,7 @@ static inline int page_cache_get_specula
 {
 	VM_BUG_ON(in_interrupt());
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
