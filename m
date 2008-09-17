Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYIQOrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYIQOrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYIQOrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:47:33 -0400
Received: from smtp2a.orange.fr ([80.12.242.140]:19658 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYIQOrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:47:32 -0400
X-ME-UUID: 20080917144729182.2CA80700008B@mwinf2a18.orange.fr
Message-ID: <48D11871.4090805@cosmosbay.com>
Date: Wed, 17 Sep 2008 16:47:13 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <1221306287.5213.111.camel@marge.simson.net>	 <48CD1D25.9080301@linux-foundation.org>	 <1221421907.4597.24.camel@marge.simson.net>	 <1221475440.4784.39.camel@marge.simson.net>	 <1221568105.5020.17.camel@marge.simson.net>	 <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>	 <1221626391.5043.13.camel@marge.simson.net>	 <1221627676.5125.3.camel@marge.simson.net> <20080917104044.GC18764@elte.hu>	 <1221651701.5102.17.camel@marge.simson.net> <20080917124943.GA7738@elte.hu> <1221657111.5511.14.camel@marge.simson.net>
In-Reply-To: <1221657111.5511.14.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith a écrit :
> On Wed, 2008-09-17 at 14:49 +0200, Ingo Molnar wrote:
>> * Mike Galbraith <efault@gmx.de> wrote:
>>
>>>> It looks like a potentially bogus bisection result, but _maybe_ it 
>>>> has relevance: changes the size of "struct security_operations", 
>>>> which could have alignment and layout effects on all sorts of kernel 
>>>> variables, kmalloc sizes, etc.
>>> This may well be a mythical creature infestation for all I know ;-), 
>>> but it's address is somewhere in the 2069f45..847106f block, 316 
>>> commits, none of which look like they should be the least bit 
>>> interesting to netperf.  I reverted this particular commit in 27.git, 
>>> got the expected result.  Looks like I'll keep poking at it, can't 
>>> seem to resist.  Grr.
>> are you sure it's 2069f45..847106f? Filtering out the 
>> likely-uninteresting commits:
> 
> Yeah, as sure as I can be.  I've built both (et al) kernels several
> times, and it has repeated every time.  Would be nice if someone would
> try to confirm/deny though.  For my little quad, I do..
> 
> #!/bin/sh
> 
> echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns 
> 
> netserver -p 12865
> netserver -p 12866
> netserver -p 12867
> netserver -p 12868
> 
> netperf -p 12865 -t TCP_RR -l 60 -H 127.0.0.1 -T 0,0 -- -r 1,1&
> netperf -p 12866 -t TCP_RR -l 60 -H 127.0.0.1 -T 1,1 -- -r 1,1&
> netperf -p 12867 -t TCP_RR -l 60 -H 127.0.0.1 -T 2,2 -- -r 1,1&
> netperf -p 12868 -t TCP_RR -l 60 -H 127.0.0.1 -T 3,3 -- -r 1,1&
> 
> wait
> killall netserver
> 
> 
>> git log --pretty=format:"%h: %s" 2069f45..847106f | grep -viE \
>> 'block|alsa|pcmcia|sound|Merge|iosched|blk|DAC960|scsi|s390|paride|pktcdvd|filter|cdrom|drm'
>>
>> gives us:
>>
>>  7daf705: Start using the new '%pS' infrastructure to print symbols
>>  6f0f0fd: security: remove register_security hook
>>  93cbace: security: remove dummy module fix
>>  5915eb5: security: remove dummy module
>>  b478a9f: security: remove unused sb_get_mnt_opts hook
>>  32502b8: splice: fix generic_file_splice_read() race with page invalidation
>>  8b3d356: ramfs: enable splice write
>>  a144ff0: xen: Avoid allocations causing swap activity on the resume path
>>
>> which really only leaves that security commit your bisection fingered. 
>> Which _slightly_ raises its likelyhood of being implicated. Structure 
>> size changes can move two formerly far-apart netperf-relevant symbols on 
>> the same cacheline, which can start cache ping-pong-ing badly.
> 
> I sure hope it's something like ping-pong, it's driving me NUTS.

Could you please try following patch ?

[PATCH] security_ops moved to read_mostly section

"struct security_operations *security_ops" should be moved to read_mostly 
section in order to NOT let it share a cache line with higly modified variables.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/security/security.c b/security/security.c
index 3a4b4f5..0b13d65 100644
--- a/security/security.c
+++ b/security/security.c
@@ -24,7 +24,7 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1];
 extern struct security_operations default_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);
 
-struct security_operations *security_ops;	/* Initialized to NULL */
+struct security_operations *security_ops __read_mostly;e
 
 /* amount of vm to protect from userspace access */
 unsigned long mmap_min_addr = CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR;



