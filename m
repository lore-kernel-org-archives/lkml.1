Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXJAREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXJAREF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXJARDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:03:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47201 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXJARDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:03:52 -0400
Subject: Re: [RFC][PATCH] make module refcounts use percpu_counters
From: Dave Hansen <haveblue@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1191231833.26950.66.camel@localhost.localdomain>
References: <20070928230057.2712A579@kernel>
	 <1191231833.26950.66.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 10:03:36 -0700
Message-Id: <1191258216.7344.129.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 19:43 +1000, Rusty Russell wrote:
> On Fri, 2007-09-28 at 16:00 -0700, Dave Hansen wrote:
> > Module refcounts currently use a percpu counter stored
> > in the 'struct module'.  However, we also have a more
> > generic implementation that does stuff like handle
> > hotplug cpus.
> > 
> > I'm not actually all that convinced that this refcount
> > actually does a lot of good, with cpus racing bumping
> > the counters at the same time that they're being
> > summed up.  But, it certainly isn't any worse than
> > what was there before.
> 
> That's why we look at the counters inside stop_machine_run().

Ahhh.  That makes sense.  Although it wasn't apparent during my 3-second
perusal of the code.

> Note that (1) the module implementation handles hotplug CPUs


You're saying it handles hotplug because of stop_machine_run()?


> But it might be a useful cleanup (although a slight de-optimization).
> If you want I'll queue for 2.6.24 (there are several other module
> patches pending too).

Might as well.  It removed a very small amount of code, and opens the
door a bit for future optimizations in a single place.

> In an ideal world, (1) we would have percpu pointers using the same
> percpu mechanism as percpu variables, (2) we would have a modal variant
> of percpu counters which would collapse to a single counter when we
> cared about the precise value (probably using stop_machine for the
> transition).  This would be useful for many other cases.

Yeah, but before we do that, we need some kind of flag to get the
percpu_counter_mod() fast path shoved into the slow path that takes the
lock.

I'm not sure the stop_machine() mechanism will work very well if we try
to expand this much further for other users.  What would the SGI guys
think if these happened more than once in a blue moon?


-- Dave

