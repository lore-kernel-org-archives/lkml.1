Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYIQNMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYIQNMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYIQNL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:11:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:52443 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752248AbYIQNL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:11:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Fw0849niFJysamUUfWWOh81VNb5jbvJ0iphgYGk
	o9NN0cjBLaxZAE
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
In-Reply-To: <20080917124943.GA7738@elte.hu>
References: <1221306287.5213.111.camel@marge.simson.net>
	 <48CD1D25.9080301@linux-foundation.org>
	 <1221421907.4597.24.camel@marge.simson.net>
	 <1221475440.4784.39.camel@marge.simson.net>
	 <1221568105.5020.17.camel@marge.simson.net>
	 <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>
	 <1221626391.5043.13.camel@marge.simson.net>
	 <1221627676.5125.3.camel@marge.simson.net> <20080917104044.GC18764@elte.hu>
	 <1221651701.5102.17.camel@marge.simson.net> <20080917124943.GA7738@elte.hu>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 15:11:51 +0200
Message-Id: <1221657111.5511.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 14:49 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > It looks like a potentially bogus bisection result, but _maybe_ it 
> > > has relevance: changes the size of "struct security_operations", 
> > > which could have alignment and layout effects on all sorts of kernel 
> > > variables, kmalloc sizes, etc.
> > 
> > This may well be a mythical creature infestation for all I know ;-), 
> > but it's address is somewhere in the 2069f45..847106f block, 316 
> > commits, none of which look like they should be the least bit 
> > interesting to netperf.  I reverted this particular commit in 27.git, 
> > got the expected result.  Looks like I'll keep poking at it, can't 
> > seem to resist.  Grr.
> 
> are you sure it's 2069f45..847106f? Filtering out the 
> likely-uninteresting commits:

Yeah, as sure as I can be.  I've built both (et al) kernels several
times, and it has repeated every time.  Would be nice if someone would
try to confirm/deny though.  For my little quad, I do..

#!/bin/sh

echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns 

netserver -p 12865
netserver -p 12866
netserver -p 12867
netserver -p 12868

netperf -p 12865 -t TCP_RR -l 60 -H 127.0.0.1 -T 0,0 -- -r 1,1&
netperf -p 12866 -t TCP_RR -l 60 -H 127.0.0.1 -T 1,1 -- -r 1,1&
netperf -p 12867 -t TCP_RR -l 60 -H 127.0.0.1 -T 2,2 -- -r 1,1&
netperf -p 12868 -t TCP_RR -l 60 -H 127.0.0.1 -T 3,3 -- -r 1,1&

wait
killall netserver


> git log --pretty=format:"%h: %s" 2069f45..847106f | grep -viE \
> 'block|alsa|pcmcia|sound|Merge|iosched|blk|DAC960|scsi|s390|paride|pktcdvd|filter|cdrom|drm'
> 
> gives us:
> 
>  7daf705: Start using the new '%pS' infrastructure to print symbols
>  6f0f0fd: security: remove register_security hook
>  93cbace: security: remove dummy module fix
>  5915eb5: security: remove dummy module
>  b478a9f: security: remove unused sb_get_mnt_opts hook
>  32502b8: splice: fix generic_file_splice_read() race with page invalidation
>  8b3d356: ramfs: enable splice write
>  a144ff0: xen: Avoid allocations causing swap activity on the resume path
> 
> which really only leaves that security commit your bisection fingered. 
> Which _slightly_ raises its likelyhood of being implicated. Structure 
> size changes can move two formerly far-apart netperf-relevant symbols on 
> the same cacheline, which can start cache ping-pong-ing badly.

I sure hope it's something like ping-pong, it's driving me NUTS.

	-Mike

