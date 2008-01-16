Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYAPQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYAPQYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYAPQYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:24:13 -0500
Received: from quasar.osc.edu ([192.148.249.15]:49373 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYAPQYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:24:12 -0500
Date: Wed, 16 Jan 2008 11:24:10 -0500
From: Pete Wyckoff <pw@osc.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: dean gaudet <dean@arctic.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nosmp/maxcpus=0 or 1 -> TSC unstable
Message-ID: <20080116162410.GB26898@osc.edu>
References: <alpine.DEB.0.999999.0801121142370.11727@twinlark.arctic.org> <20080115225039.GA25701@osc.edu> <20080116153137.GA18553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116153137.GA18553@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mingo@elte.hu wrote on Wed, 16 Jan 2008 16:31 +0100:
> 
> * Pete Wyckoff <pw@osc.edu> wrote:
> 
> > > pretty sure this is the culprit is that num_possible_cpus() > 1, 
> > > which would mean cpu_possible_map contains the second cpu... but i'm 
> > > not quite sure what the right fix is... or perhaps this is all 
> > > intended.
> > 
> > We've seen the same problem.  We use gettimeofday() for timing of 
> > network-ish operations on the order of 10-50 us.  But not having the 
> > TSC makes gettimeofday() itself very slow, on the order of 30 us.
> 
> 30 usecs is too much - even with pmtimer it's typically below 5 usecs. 
> Could you run this on your box:
> 
>   http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
> 
> and send back what it reports? (run it for a few minutes)

You're right.  That 30 us comes from an old comment.  Testing with
your code shows under 5 us as you expected.  I had to hack out the
#ifndef i386 error; compiling on x86-64.  Dual-socket 2.4 GHz
Opteron 250.  TSC-warps grows continually in all situations.

On 2.6.24-rc6 + scsi-misc + random stuff, 2 processors:

 | 0.39 us, TSC-warps:983002775 | 4.81 us, TOD-warps:0 | 4.81 us, CLOCK-warps:0 

With "maxcpus=1", no broken patch to force TSC:

 | 0.33 us, TSC-warps:679679972 | 3.30 us, TOD-warps:0 | 3.30 us, CLOCK-warps:0 

With "maxcpus=1", including my broken patch to force use of TSC in
this situation:

 | 0.05 us, TSC-warps:2884019968 | 0.45 us, TOD-warps:0 | 0.45 us, CLOCK-warps:0

For giggles, an older fedora kernel (2.6.23.1-42.fc8) gives:

 | 0.87 us, TSC-warps:575054334 | 8.67 us, TOD-warps:0 | 8.67 us, CLOCK-warps:0 

		-- Pete
