Return-Path: <linux-kernel-owner+w=401wt.eu-S1762556AbXJQFiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762556AbXJQFiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXJQFiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:38:17 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43303 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbXJQFiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:38:16 -0400
Date: Wed, 17 Oct 2007 11:07:54 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-ID: <20071017053754.GB9940@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <20071016103417.GA16570@in.ibm.com> <200710171047.42693.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710171047.42693.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 10:47:41AM +1000, Rusty Russell wrote:
> On Tuesday 16 October 2007 20:34:17 Gautham R Shenoy wrote:
> > This patch implements a Refcount + Waitqueue based model for
> > cpu-hotplug.
> 
> Hi Gautham,

Hi Rusty, 

> 
> 	I can't see where you re-initialize the completion.  

The cpu_hotplug.readers_done is a global variable which has been
initialized in cpu_hotplug_init. 

So I am wondering is the re-initialization required ? 

> 
> > +static void cpu_hotplug_begin(void)
> > +{
> > +	mutex_lock(&cpu_hotplug.lock);
> > +	cpu_hotplug.active_writer = current;
> > +	while (cpu_hotplug.refcount) {
> > +		mutex_unlock(&cpu_hotplug.lock);
> > +		wait_for_completion(&cpu_hotplug.readers_done);
> > +		mutex_lock(&cpu_hotplug.lock);
> > +	}
> 
> AFAICT this will busy-wait on the second CPU hotplug.
> 

Well when the first cpu_hotplug comes out of wait_for_completion, it
would have decremented the ->done count, so it's as good as new 
for the second CPU hotplug, no?

> Cheers,
> Rusty.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
