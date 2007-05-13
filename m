Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbXEMWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbXEMWQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEMWQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:16:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXEMWQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:16:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Mon, 14 May 2007 00:21:13 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <200705132132.08546.rjw@sisk.pl> <200705132350.32582.rjw@sisk.pl> <20070513215425.GA3240@tv-sign.ru>
In-Reply-To: <20070513215425.GA3240@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705140021.14129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 23:54, Oleg Nesterov wrote:
> On 05/13, Rafael J. Wysocki wrote:
> >
> > On Sunday, 13 May 2007 23:34, Oleg Nesterov wrote:
> > > On 05/13, Rafael J. Wysocki wrote:
> > > >
> > > > @@ -819,20 +843,31 @@ static int __devinit workqueue_cpu_callb
> > > >  
> > > > +
> > > > +		case CPU_DEAD_FROZEN:
> > > > +			if (wq->freezeable) {
> > > > +				take_over_work(wq, cpu);
> > > > +				thaw_process(cwq->thread);
> > > 
> > > Suppose that PF_NOFREEZE task T does flush_workqueue(), and CPU 1 has pending
> > > works. T does flush_cpu_workqueue(0), CPU_DEAD_FROZEN moves works from CPU 1
> > > to CPU 0, T does flush_cpu_workqueue(1) and finds nothing.
> > 
> > I don't think this is possible, because we've acquired workqueue_mutex in
> > _cpu_down().
> 
> Yes, we did... but flush_workqueue() doesn't take it?

I was looking at the 2.6.21 code, sorry.

Hmm, I guess we could add an additional mutex that would only be taken in
flush_workqueue() and in _cpu_down()/_cpu_up() via workqueue_cpu_callback()
with CPU_LOCK_ACQUIRE?

It doesn't seem to be a good idea to run flush_workqueue() while CPUs are being
taken up and down anyway.

Greetings,
Rafael
