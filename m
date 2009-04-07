Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZDGHFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZDGHFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZDGHFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:05:04 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:65504 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZDGHFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:05:03 -0400
X-SourceIP: 213.93.53.227
Subject: Re: pm-hibernate : possible circular locking dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <200904071356.29914.rusty@rustcorp.com.au>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com>
	 <200904051212.53353.rjw@sisk.pl> <20090405134454.GB25250@elte.hu>
	 <200904071356.29914.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 09:05:53 +0200
Message-Id: <1239087953.798.5513.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 13:56 +0930, Rusty Russell wrote:
> On Sunday 05 April 2009 23:14:54 Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Sunday 05 April 2009, Ming Lei wrote:
> > > > kernel version : one simple usb-serial patch against  commit
> > > > 6bb597507f9839b13498781e481f5458aea33620.
> > > > 
> > > > Thanks.
> > > 
> > > Hmm, CPU hotplug again, it seems.
> > > 
> > > I'm not sure who's the maintainer at the moment.  Andrew, is that 
> > > Gautham?
> > 
> > CPU hotplug tends to land on the scheduler people's desk normally.
> > 
> > But i'm not sure that's the real thing here - key appears to be this 
> > work_on_cpu() worklet by the cpufreq code:
> 
> Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
> patch which I just put out the pull request for.

Would it make sense to teach it about a short-circuit like:

work_on_cpu() {

  if (cpumask_weight(current->cpus_allowed) == 1 && 
      smp_processor_id() == cpu)
    return do_work_right_here();

  queue_the_bugger();
}

?

