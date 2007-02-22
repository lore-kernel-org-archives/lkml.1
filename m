Return-Path: <linux-kernel-owner+w=401wt.eu-S1422833AbXBVLec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422833AbXBVLec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422852AbXBVLec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:34:32 -0500
Received: from mail.screens.ru ([213.234.233.54]:48983 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422833AbXBVLeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:34:31 -0500
Date: Thu, 22 Feb 2007 14:33:56 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070222113356.GA83@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070221200314.GA91@tv-sign.ru> <20070221210606.GH7063@linux.vnet.ibm.com> <200702220010.54126.rjw@sisk.pl> <20070222104747.GA505@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222104747.GA505@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Oleg Nesterov wrote:
>
> On 02/22, Rafael J. Wysocki wrote:
> >
> > @@ -207,7 +209,7 @@ static void thaw_tasks(int thaw_user_spa
> >  		if (is_user_space(p) == !thaw_user_space)
> >  			continue;
> >  
> > -		if (!thaw_process(p))
> > +		if (!thaw_process(p) && !freezer_should_skip(p))
> >  			printk(KERN_WARNING " Strange, %s not stopped\n",
> 
> This is racy, the warning could be false. We wake up the task, testing
> its ->flags is not reliable.
> 
> Damn. PF_FREEZER_SKIP task could be woken before, clear PF_FREEZER_SKIP,
> but not frozen.
> 
> We can change freezer_count() to clear PF_FREEZER_SKIP after try_to_freeze(),
> not before. Now thaw_process() can take PF_FREEZER_SKIP into account and
> return "true".
> 
> But this means the task may be PF_FREEZER_SKIP | PF_FROZEN. What if we we
> call try_to_freeze_tasks() soon after thaw_tasks()? We may hit the task which
> leaves the refrigerator, but didn't clear PF_FREEZER_SKIP yet. This means
> that thaw_process() should clear PF_FREEZER_SKIP as well. This is messy :(
> 
> Any other ideas? In any case we should imho avoid a separate loop for
> PF_FREEZER_SKIP tasks to just fix debug messages. In fact it can't help
> anyway.

Probably: current clears PF_FREEZER_SKIP along with TIF_FREEZE "atomically"
under task_lock in refrigerator(). thaw_process() takes PF_FREEZER_SKIP into
account.

Oleg.

