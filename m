Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbXIFHOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbXIFHOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 03:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXIFHOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 03:14:32 -0400
Received: from mail.suse.de ([195.135.220.2]:60047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbXIFHOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 03:14:31 -0400
Date: Thu, 6 Sep 2007 09:14:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>
Subject: Re: Fast path efficiency (Re: [rfc][patch] dynamic data structure switching)
Message-ID: <20070906071428.GA24721@wotan.suse.de>
References: <20070902182738.GA13145@wotan.suse.de> <20070902183618.GB13145@wotan.suse.de> <E1IT3wK-0006Bh-22@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IT3wK-0006Bh-22@flower>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 01:05:40AM +0200, Oleg Verych wrote:
> * Sun, 2 Sep 2007 20:36:19 +0200
> >
> 
> I see, that in many places all pre-checks are done in negative form
> with resulting return or jump out. In this case, if function was called,
> what likely() path is?
> 
> > +static void resize_pid_hash(void)
> > +{
> > +	unsigned int old_shift, new_shift;
> > +
> > +	if (system_state != SYSTEM_RUNNING)
> > +		return;
> > +
> > +	old_shift = cur_pid_hash->shift;
> > +	new_shift = ilog2(nr_pids * 2 - 1);
> > +	if (new_shift == old_shift)
> > +		return;
> > +
> > +	if (!mutex_trylock(&dyn_pidhash.resize_mutex))
> > +		return;
> 
> that one or this?
> 
> ==
> 	if (system_state == SYSTEM_RUNNING) {
> 		old_shift = cur_pid_hash->shift;
> 		new_shift = ilog2(nr_pids * 2 - 1);
> 		if (new_shift != old_shift && mutex_trylock(&dyn_pidhash.resize_mutex)) {
> ==
> 		> +	old_shift = cur_pid_hash->shift;
> 		> +	new_shift = ilog2(nr_pids * 2 - 1);
> 
> /* hope this repetition is needed by design */
> 
> 		...
> 		
> 		> +	mutex_unlock(&dyn_pidhash.resize_mutex);
> 		}
> 
> What is more efficient in general sense,
> as opposed to s,3,2,1,0 Optimized?

I'm not too sure, but I'd guess that most of the time the compiler will
be able to figure out they are the same.

resize_pid_hash() fortunately isn't a fastpath anyway -- it calls
dyn_data_replace which ends up calling synchronize_rcu() 3 times,
each of which is likely to take a long time!

