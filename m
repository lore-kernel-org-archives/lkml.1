Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbXENKCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbXENKCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXENKC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:02:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbXENKC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:02:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFD] Freezing of kernel threads
Date: Mon, 14 May 2007 12:07:21 +0200
User-Agent: KMail/1.9.5
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>
References: <200705122017.32792.rjw@sisk.pl> <20070514061846.GA30625@in.ibm.com> <20070514072659.GA16236@in.ibm.com>
In-Reply-To: <20070514072659.GA16236@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141207.23002.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 May 2007 09:26, Gautham R Shenoy wrote:
> On Mon, May 14, 2007 at 11:48:46AM +0530, Srivatsa Vaddagiri wrote:
> > 
> > The other complication get/put_hotcpu() had was dealing with
> > write-followed-by-read lock attempt by the *same* thread (whilst doing
> > cpu_down/up).  IIRC this was triggered by some callback processing in CPU_DEAD 
> > or CPU_DOWN_PREPARE.
> > 
> > 
> > cpu_down()
> >  |- take write lock 
> >  |- CPU_DOWN_PREPARE
> >  |        |- foo() wants a read_lock 
> > 
> > Stupid as it sounds, it was really found to be happening!  Gautham, do you 
> > recall who that foo() was? Somebody in cpufreq I guess ..
> 
> IIRC, it was a problem with ondemand. while handling CPU_DEAD, ondemand code
> would call destroy_workqueue, which tried flushing the workqueue, which
> once upon a time did lock_cpu_hotplug, before Oleg and Andrew cleaned 
> that up. 
> 
> Ofcourse, cpufreq works fine now after Venki's patches which
> just nullifies the reference to the policy structure of the cpu to be
> removed during the CPU_DOWN_PREPARE by calling __cpufreq_remove_dev
> instead of handling it in CPU_DEAD.
> 
> However, as we have discovered, without freezing all the threads, it
> is inadvisable to call flush_workqueue from a cpu-hotplug callback 
> path. 

Please see my recent patch at http://lkml.org/lkml/2007/5/14/7 .
It's not exactly the same thing, but I think the trick in there might be
useful.

Greetings,
Rafael
