Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYGBBjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYGBBjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYGBBj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:39:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38256 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756337AbYGBBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:39:28 -0400
Date: Tue, 1 Jul 2008 20:39:27 -0500
From: Dean Nelson <dcn@sgi.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robin Holt <holt@sgi.com>, ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Delayed interrupt work, thread pools
Message-ID: <20080702013927.GA2264@sgi.com>
References: <1214916335.20711.141.camel@pasglop> <20080701130240.GD10511@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701130240.GD10511@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:02:40AM -0500, Robin Holt wrote:
> Adding Dean Nelson to this discussion.  I don't think he actively
> follows lkml.  We do something similar to this in xpc by managing our
> own pool of threads.  I know he has talked about this type thing in the
> past.
> 
> Thanks,
> Robin
> 
> 
> On Tue, Jul 01, 2008 at 10:45:35PM +1000, Benjamin Herrenschmidt wrote:
> > 
> > For the specific SPU management issue we've been thinking about, we
> > could just implement an ad-hoc mechanism locally, but it occurs to me
> > that maybe this is a more generic problem and thus some kind of
> > extension to workqueues would be a good idea here.
> > 
> > Any comments ?

As Robin, mentioned XPC manages a pool of kthreads that can (for performance
reasons) be quickly awakened by an interrupt handler and that are able to
block for indefinite periods of time.

In drivers/misc/sgi-xp/xpc_main.c you'll find a rather simplistic attempt
at maintaining this pool of kthreads. 

The kthreads are activated by calling xpc_activate_kthreads(). Either idle
kthreads are awakened or new kthreads are created if a sufficent number of
idle kthreads are not available.

Once finished with current 'work' a kthread waits for new work by calling
wait_event_interruptible_exclusive(). (The call is found in
xpc_kthread_waitmsgs().)

The number of idle kthreads is limited as is the total number of kthreads
allowed to exist concurrently.

It's certainly not optimal in the way it maintains the number of kthreads
in the pool over time, but I've not had the time to spare to make it better.

I'd love it if a general mechanism were provided so that XPC could get out
of maintaining its own pool.

Thanks,
Dean
