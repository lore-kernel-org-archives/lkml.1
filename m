Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbXJYHBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbXJYHBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbXJYHBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:01:18 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34422 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbXJYHBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:01:17 -0400
Date: Wed, 24 Oct 2007 23:30:34 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, David Miller <davem@davemloft.net>,
       Paul Jackson <pj@sgi.com>, Josh Triplett <josh@freedesktop.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/5] Refcount based Cpu Hotplug. V2
Message-ID: <20071024180034.GB8663@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071024052931.GA22722@in.ibm.com> <Pine.LNX.4.64.0710241001160.26202@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710241001160.26202@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 10:04:41AM -0700, Christoph Lameter wrote:
> On Wed, 24 Oct 2007, Gautham R Shenoy wrote:
> 
> > This is the version 2 of the refcount based cpu-hotplug "locking" 
> > implementation. 
> 
> Uggh. This introduces a global lock that has to be taken always when 
> scanning over cpus? 

Well, no! we take the global lock only while bumping up the refcount. 
We don't hold the lock while scanning over the cpus. And this is
definitely an improvement over the lock_cpu_hotplug() global mutex
we have now.

>Is multipe cpus are scanning over processor lists then 
> we will get into scaling problems. Wasnt there an RCU based implementation 
> that avoided cacheline bouncing and refcounting?

Oh yes! You are probably refering to 
http://lkml.org/lkml/2006/10/26/73
which was posted a year ago. Unfortunately it didn't get much review, 
and we moved on towards a bunch of other implementations.

Anyway, the first step would be to move away from locks towards
a refcount model. Later on we can use rcu + per-cpu refcounts thereby
making it scalable on the read side.

> 
> > The patchstack which is based against 2.6.23-mm1 has behaved well
> > when it was stress tested with kernbench running while continuously
> > performing cpu-hotplug operations on i386, x86_64 and ppc64.
> 
> What was the highest cpu count in testing?

8 cpus on i386 and x86_64.
16 cpus on ppc64.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
