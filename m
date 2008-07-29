Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYG2VVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYG2VVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYG2VVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:21:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYG2VVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:21:31 -0400
Date: Tue, 29 Jul 2008 14:21:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before
 late_initcall and move level 6s (sync) first
Message-ID: <20080729142123.5164b1a4@infradead.org>
In-Reply-To: <488F87AB.9080309@keyaccess.nl>
References: <20080720085924.122feb2b@infradead.org>
	<20080720090041.5924f5ff@infradead.org>
	<488F84ED.9010200@keyaccess.nl>
	<20080729140434.31022f55@infradead.org>
	<488F87AB.9080309@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:12:11 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 29-07-08 23:04, Arjan van de Ven wrote:
> 
> > On Tue, 29 Jul 2008 23:00:29 +0200
> >> Isn't this a bit confusing? All the other sync levels are directly
> >> after their respective levels. I can see why you want another level
> >> now, but shouldn't that mean late_initcall now wants to be 8,
> >> device_initcall 7 and your new 6s just 6 (device_core_initcall or
> >> something...)?
> >>
> > 
> > yeah it is.. but nobody is using them
> > 
> > I'll make a note to clean this up
> > 
> > (by removing the unused ones)
> 
> Fair enough. By the way:
> 
> > @@ -775,6 +776,11 @@ static void __init do_initcalls(void)
> >  		}
> >  		if (phase == 1 && call >= __async_initcall_end)
> >  			phase = 2;
> > +		if (phase == 2 && call >= __device_initcall_end) {
> > +			phase = 3;
> > +			/* make sure all async work is done before
> > level 7 */
> > +			flush_workqueue(async_init_wq);
> > +		}
> >  		if (phase != 1)
> >  			do_one_initcall(*call);
> 
> After this patch, there are now 2 flush_workqueue(async_init_wq)
> calls in do_initcalls. Should the other one remain as well?

yes because if you don't have any level 7's then you won't hit this
condition... you need the second one.

flush_workqueue is cheap for the nothing-in-there case.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
