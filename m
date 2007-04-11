Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbXDKPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbXDKPcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXDKPcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:32:19 -0400
Received: from mail.screens.ru ([213.234.233.54]:38452 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbXDKPcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:32:19 -0400
Date: Wed, 11 Apr 2007 18:36:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com
Subject: Re: [PATCH] kthread: Don't depend on work queues
Message-ID: <20070411143626.GA125@tv-sign.ru>
References: <20070410185133.GA104@tv-sign.ru> <m13b37v517.fsf@ebiederm.dsl.xmission.com> <20070411000316.52f2551e.akpm@linux-foundation.org> <200704111213.35523.rjw@sisk.pl> <20070411112105.GA24813@in.ibm.com> <20070411114805.GA165@tv-sign.ru> <20070411133139.GB10623@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411133139.GB10623@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Gautham R Shenoy wrote:
> On Wed, Apr 11, 2007 at 03:48:05PM +0400, Oleg Nesterov wrote:
> > On 04/11, Gautham R Shenoy wrote:
> > >
> > > On Wed, Apr 11, 2007 at 12:13:34PM +0200, Rafael J. Wysocki wrote:
> > > > 
> > > > It should be calling try_to_freeze() somewhere anyway.  We may need to freeze
> > > > all tasks in some cases.
> > > 
> > > How about
> > > for (;;) {
> > > 	try_to_freeze();
> > > 
> > > ?
> > 
> > Why?
> 
> If some event (defintely NOT cpu hotplug) needs this thread frozen.
> 
> > 
> > > This change allows us to make all the worker threads freezeable by default.
> > > >From cpu-hotplug perspective, helper_wq was the only singlethreaded
> > > non-freezeable workqueue.
> > 
> > I think Eric's patch is what you need. We should _not_ freeze kthreadd(), we
> > need kthread_create() after freezing. Now it doesn't depend on workqueues, we
> > can freeze them all, single-thread or not.
> > 
> 
> These were my exact thoughts. 

Sorry, I misunderstood your message.

Yes, we can freeze it with FE_HOTPLUG_CPU. In that case wait_event()
should also check !freezing(), and try_to_freeze() should be called
after case wait_event().

On the other hand, if "kthreadd" does not sleep on kthread_create_work,
we have another unfrozen process waiting for kthread_create_info.done.
So, is there any practical reason why kthreadd() should explicitely go
to refrigerator?

Oleg.

