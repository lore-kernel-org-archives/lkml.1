Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbZKEACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbZKEACX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbZKEACW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:02:22 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44390 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbZKEACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:02:21 -0500
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
From: john stultz <johnstul@us.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <5419f8c1-218e-42d2-991f-e52fc20e5ee4@default>
References: <5419f8c1-218e-42d2-991f-e52fc20e5ee4@default>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 16:02:18 -0800
Message-ID: <1257379338.10811.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 13:28 -0800, Dan Magenheimer wrote:
> > From: john stultz [mailto:johnstul@us.ibm.com]
> > On Thu, Oct 29, 2009 at 7:07 AM, Avi Kivity <avi@redhat.com> wrote:
> > >
> > > Out of interest, do you know (and can you relate) why those 
> > apps need
> > > 100k/sec monotonically increasing timestamps?
> > 
> > This is sort of tangential, but depending on the need, this might be
> > of interest:  Recently I've added a new clock_id,
> > CLOCK_MONOTONIC_COARSE (as well as CLOCK_REALTIME_COARSE), which
> > return a HZ granular timestamp (same granularity as filesystem
> > timestamps). Its very fast to access, since there's no hardware to
> > touch, and is accessible via vsyscall.
> > 
> > The idea being, if your hitting clock_gettime 100k/sec but you really
> > don't have the need for nsec granular timestamps, it might provide a
> > really nice performance boost.
> > 
> > Here's the commit:
> 
> Hi John --
> 
> Yes, possibly of interest.  But does it work with CONFIG_NO_HZ?
> (I'm expecting that over time NO_HZ will become widespread
> for VM OS's, though interested in if you agree.)

It should work, with CONFIG_NO_HZ, as soon as we come out of a long idle
(likely due to a timer tick), the timekeeping code will accumulate all
the skipped ticks.

If we ever get to non-idle NOHZ, we'll need some extra work here
(probably lazy accumulation done conditionally in the read path), but
that's also true for filesystem timestamps. 


> Also very interested in your thoughts about a variation
> that returns something similar to a TSC_AUX to notify
> caller that the underlying reference clock has/may have
> changed.

I haven't been following that closely. Personally, experience makes me
skeptical of workarounds for unsynced TSCs. But I'm sure there's sharper
folks out there that might make it work. The kernel just requires that
it *really really* works, and not "mostly" works. :)

thanks
-john




