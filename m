Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbYB0Nux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbYB0Nux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYB0Nun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:50:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:46158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbYB0Num (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:50:42 -0500
Date: Wed, 27 Feb 2008 14:50:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
Message-ID: <20080227135041.GC1340@wotan.suse.de>
References: <20080227124217.GA1340@wotan.suse.de> <20080227132713.GA13681@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227132713.GA13681@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:27:13PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > This isn't finished yet, however I'd just like to ask for comments.
> 
> looks really interesting!
> 
> only one fundamental observation:
> 
> > +struct call_data {
> > +	spinlock_t lock;
> > +	struct list_head list;
> >  	void (*func) (void *info);
> >  	void *info;
> > +	unsigned int flags;
> > +	unsigned int refs;
> > +	cpumask_t cpumask;
> > +	struct rcu_head rcu_head;
> >  };
> 
> > +struct call_single_data {
> > +	struct list_head list;
> > +	void (*func) (void *info);
> > +	void *info;
> > +	unsigned int flags;
> > +};
> 
> the two structures are quite similar in size and role - why not have a 
> type field and handle them largely together? I think we should try to 
> preserve a single queue and a single vector - that would remove a number 
> of ugly special-cases from the patch.

A single queue will kill one of the big fundamental scalability
improvements of the call_single. That's the problem.

