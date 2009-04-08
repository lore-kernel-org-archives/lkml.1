Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbZDHMq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbZDHMq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZDHMqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:46:48 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:12511 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZDHMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:46:47 -0400
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
In-Reply-To: <200904081247.08712.rusty@rustcorp.com.au>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com>
	 <200904071356.29914.rusty@rustcorp.com.au>
	 <1239087953.798.5513.camel@twins>
	 <200904081247.08712.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 14:48:26 +0200
Message-Id: <1239194906.13185.93.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 12:47 +0930, Rusty Russell wrote:
> On Tuesday 07 April 2009 16:35:53 Peter Zijlstra wrote:
> > On Tue, 2009-04-07 at 13:56 +0930, Rusty Russell wrote:
> > > Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
> > > patch which I just put out the pull request for.
> > 
> > Would it make sense to teach it about a short-circuit like:
> > 
> > work_on_cpu() {
> > 
> >   if (cpumask_weight(current->cpus_allowed) == 1 && 
> >       smp_processor_id() == cpu)
> >     return do_work_right_here();
> 
> Does that happen much?  I guess put a counter in and see?

Ego spotted the case where cpufreq calls it from an cpu-affine
workqueue, it seems to me in that case its desirable to have the
short-cut, and currently that's needed for correctness too as it will
generate this circular lock thingy.

