Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXEMVp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXEMVp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXEMVps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:45:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39150 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbXEMVps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:45:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Sun, 13 May 2007 23:50:31 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <200705132132.08546.rjw@sisk.pl> <200705132322.10032.rjw@sisk.pl> <20070513213424.GA3198@tv-sign.ru>
In-Reply-To: <20070513213424.GA3198@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132350.32582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 23:34, Oleg Nesterov wrote:
> On 05/13, Rafael J. Wysocki wrote:
> >
> > > > On Sunday, 13 May 2007 22:30, Oleg Nesterov wrote:
> > > > >
> > > > > I think the better fix (at least for now) is
> > > > > 
> > > > > 	- #define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
> > > > > 	+ #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
> > > > > 
> > > > > Alex, do you really need a multithreaded wq?
> > > > > 
> > > > > Rafael, what do you think?
> > > > 
> > Sure, if a singlethread workqueue is sufficient for Alex, I agree that this
> > would be preferable.
> 
> Great. Alex?
> 
> > @@ -819,20 +843,31 @@ static int __devinit workqueue_cpu_callb
> >  
> > +
> > +		case CPU_DEAD_FROZEN:
> > +			if (wq->freezeable) {
> > +				take_over_work(wq, cpu);
> > +				thaw_process(cwq->thread);
> 
> Suppose that PF_NOFREEZE task T does flush_workqueue(), and CPU 1 has pending
> works. T does flush_cpu_workqueue(0), CPU_DEAD_FROZEN moves works from CPU 1
> to CPU 0, T does flush_cpu_workqueue(1) and finds nothing.

I don't think this is possible, because we've acquired workqueue_mutex in
_cpu_down().

Greetings,
Rafael
