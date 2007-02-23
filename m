Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXBWSQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXBWSQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXBWSQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:16:40 -0500
Received: from mail.screens.ru ([213.234.233.54]:37914 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161AbXBWSQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:16:39 -0500
Date: Fri, 23 Feb 2007 21:15:36 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070223181536.GB224@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702221803.41549.rjw@sisk.pl> <20070222174439.GA236@tv-sign.ru> <200702222256.19582.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702222256.19582.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Rafael J. Wysocki wrote:
>
> On Thursday, 22 February 2007 18:44, Oleg Nesterov wrote:
> > On 02/22, Rafael J. Wysocki wrote:
> > > 
> > > Okay, attached.  The first one closes the race between thaw_tasks() and the
> > > refrigerator that can occurs if the freezing fails.  The second one fixes the
> > > vfork problem (should go on top of the first one).
> > 
> > Looks good to me.
> > 
> > > > Any other ideas? In any case we should imho avoid a separate loop for
> > > > PF_FREEZER_SKIP tasks to just fix debug messages. In fact it can't help
> > > > anyway.
> > > 
> > > Why don't we just drop the warning?  try_to_freeze_tasks() should give us a
> > > warning if there's anything wrong anyway.
> > 
> > Indeed :)
> 
> Still, there is a tiny race in the error path of try_to_freeze_tasks(), where
> a vfork parent process can be preempted after clearing PF_FREEZER_SKIP and
> before entering refrigerator(), so try_to_freeze_tasks() will mistakenly report
> that this process has caused a problem.

Yes, basically the same race. But unlike thaw_tasks(), this is the error path,
it is not so critical to filter out the false warnings. We can't do this anyway.
Since try_to_freeze_tasks() failed, new processes can be created, we don't filter
out "TASK_TRACED && frozen(p->parent)", etc.

> I think this race can be closed by (1) clearing PF_FREEZER_SKIP after calling
> try_to_freeze() in freezer_count(), (2) clearing PF_FREEZER_SKIP in
> refrigerator() before calling frozen_process() and (3) taking task_lock()
> around the warning check in the error path of try_to_freeze_tasks().

I am a bit confused by this patch. Which method it uses?

> +static inline void freezer_count(void)
> +{
> +	try_to_freeze();
> +	current->flags &= ~PF_FREEZER_SKIP;
> +}
>
> ...
>
> @@ -42,6 +42,7 @@ void refrigerator(void)
>  
>  	task_lock(current);
>  	if (freezing(current)) {
> +		current->flags &= ~PF_FREEZER_SKIP;

Isn't it better to clear PF_FREEZER_SKIP unconditionally? freezer_count() will
do try_to_freeze(), nothing more.

It is not safe to clear PF_FREEZER_SKIP in freezer_count() ater try_to_freeze().
PF_FREEZER_SKIP is a promise to to try_to_freeze(). try_to_freeze_tasks() fails,
does cancel_freezing(), a CLONE_VFORK parent returns from try_to_freeze() with
PF_FREEZER_SKIP set, and now comes another try_to_freeze_tasks() ?

Surely, this can't happen in practice, but still.

Oleg.

