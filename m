Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYIQMuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYIQMuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 08:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYIQMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 08:50:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYIQMuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 08:50:03 -0400
Date: Wed, 17 Sep 2008 14:49:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20080917124943.GA7738@elte.hu>
References: <1221306287.5213.111.camel@marge.simson.net> <48CD1D25.9080301@linux-foundation.org> <1221421907.4597.24.camel@marge.simson.net> <1221475440.4784.39.camel@marge.simson.net> <1221568105.5020.17.camel@marge.simson.net> <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi> <1221626391.5043.13.camel@marge.simson.net> <1221627676.5125.3.camel@marge.simson.net> <20080917104044.GC18764@elte.hu> <1221651701.5102.17.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221651701.5102.17.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > It looks like a potentially bogus bisection result, but _maybe_ it 
> > has relevance: changes the size of "struct security_operations", 
> > which could have alignment and layout effects on all sorts of kernel 
> > variables, kmalloc sizes, etc.
> 
> This may well be a mythical creature infestation for all I know ;-), 
> but it's address is somewhere in the 2069f45..847106f block, 316 
> commits, none of which look like they should be the least bit 
> interesting to netperf.  I reverted this particular commit in 27.git, 
> got the expected result.  Looks like I'll keep poking at it, can't 
> seem to resist.  Grr.

are you sure it's 2069f45..847106f? Filtering out the 
likely-uninteresting commits:

git log --pretty=format:"%h: %s" 2069f45..847106f | grep -viE \
'block|alsa|pcmcia|sound|Merge|iosched|blk|DAC960|scsi|s390|paride|pktcdvd|filter|cdrom|drm'

gives us:

 7daf705: Start using the new '%pS' infrastructure to print symbols
 6f0f0fd: security: remove register_security hook
 93cbace: security: remove dummy module fix
 5915eb5: security: remove dummy module
 b478a9f: security: remove unused sb_get_mnt_opts hook
 32502b8: splice: fix generic_file_splice_read() race with page invalidation
 8b3d356: ramfs: enable splice write
 a144ff0: xen: Avoid allocations causing swap activity on the resume path

which really only leaves that security commit your bisection fingered. 
Which _slightly_ raises its likelyhood of being implicated. Structure 
size changes can move two formerly far-apart netperf-relevant symbols on 
the same cacheline, which can start cache ping-pong-ing badly.

It wouldnt be the first such incident - alignment changes impacting 
macro benchmarks. (and it's hard to find it as the thing that changes 
alignment/size/sharedness might be something totally unrelated)

It's still a bit too early to say this for sure though ...

	Ingo
