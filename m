Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZJPR60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZJPR60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZJPR6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:58:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51851 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZJPR6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:58:24 -0400
Subject: Re: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
From: john stultz <johnstul@us.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       arch/x86 maintainers <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
In-Reply-To: <4AD7E440.2030503@goop.org>
References: <4AD6B1F0.6030904@goop.org>
	 <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>
	 <1f1b08da0910151832m59d14ac2i4add6555d6a1208a@mail.gmail.com>
	 <4AD7E440.2030503@goop.org>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 10:58:18 -0700
Message-Id: <1255715898.5135.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 20:10 -0700, Jeremy Fitzhardinge wrote:
> On 10/15/09 18:32, john stultz wrote:
> >>> No, cycle_last isn't updated on every read, only on timer ticks.  This
> >>> test doesn't seem to be intended to make sure that every
> >>> clocksource_read is globally monotonic, but just to avoid
> >>> some boundary
> >>> conditions in the timer interrupt.  I just copied it directly from
> >>> read_tsc().
> >>>       
> >> I understand but you are now essentially emulating a
> >> reliable platform timer with a potentially unreliable
> >> (but still high resolution) per-CPU timer AND probably
> >> delivering that result to userland.
> >>
> >> Read_tsc should only be used if either CONSTANT_TSC
> >> or TSC_RELIABLE is true, so read_tsc is guaranteed
> >> to be monotonically-strictly-increasing by hardware
> >> (and enforced for CONSTANT_TSC by check_tsc_warp
> >> at boot).
> >>     
> > Ideally, yes, only perfect TSCs should be used.
> >
> > But in reality, its a big performance win for folks who can get away
> > with just slightly offset TSCs.
> >   
> 
> What monotonicity guarantees do we make to usermode, for both syscall
> and vsyscall gettimeofday and clock_gettime?

The guarantee is time won't go backwards. It may not always increase,
between two calls, but applications should not see a previous time after
a later time from clock_gettime/gettimeofday.

> Though its not clear to me how usermode would even notice very small
> amounts of cross-thread/cpu non-monotonicity anyway.  It would need make
> sure that it samples the time and stores it to some globally visible
> place atomically (with locks, compare-and-swap, etc), which is going to
> be pretty expensive.  And if its going to all that effort it may as well
> do its own monotonicity checking/adjustments if its all that important.

If the TSCs are offset enough for a thread to move between cpus and see
an inconsistency, then the TSC needs to be thrown out. The TSC sync
check at boot should provide this.

The cycle_last check in read_tsc() is really only for very very slight
offsets, that would otherwise pass the sync check, and a process could
not detect when switching between cpus (the skew would have to be
smaller then the time it takes to migrate between cpus). 


> (I can think of plenty of ways of doing it incorrectly, where you'd get
> apparent non-monotonicity regardless of the quality of the time source.)

There's been some interesting talk of creating a more offset-robust TSC
clocksource using a per-cpu TSC offsets synced periodically against a
global counter like the HPET.  It seems like it could work, but there
are a lot of edge cases and it really has to be right all of the time,
so I don't think its quite as trivial as some folks have thought. But it
would be interesting to see!

thanks
-john

