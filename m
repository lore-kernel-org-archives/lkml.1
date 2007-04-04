Return-Path: <linux-kernel-owner+w=401wt.eu-S2992812AbXDDJ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992812AbXDDJ6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992813AbXDDJ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:58:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41656 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992812AbXDDJ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:58:13 -0400
Date: Wed, 4 Apr 2007 11:57:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable entries
Message-ID: <20070404095745.GA16726@elte.hu>
References: <20070402055652.610711908@goop.org> <20070402055704.278590661@goop.org> <200704020812.18320.ak@suse.de> <46136F25.7030907@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46136F25.7030907@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > What do the benchmarks say with CONFIG_PARAVIRT on native hardware 
> > compared to !CONFIG_PARAVIRT. e.g. does lmbench suffer?
> 
> Barely.  There's a slight hit for not using patching, and patching is 
> almost identical to native performance.  The most noticeable 
> difference is in the null syscall microbenchmark, but once you get to 
> complex things the difference is in the noise.

i'd not call this 'barely' or 'noise'! Look:

> Processor, Processes - times in microseconds - smaller is better
> ------------------------------------------------------------------------------
> Host                 OS  Mhz null null      open slct sig  sig  fork exec sh  
>                              call  I/O stat clos TCP  inst hndl proc proc proc
> --------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
> non-paravirt
> ezr       Linux 2.6.21- 1000 0.25 0.52 31.6 34.7 10.3 1.03 5.31 726. 1565 4520
> ezr       Linux 2.6.21- 1000 0.25 0.52 31.8 34.7 12.6 1.03 5.41 725. 1564 4585
> ezr       Linux 2.6.21- 1000 0.25 0.55 31.7 34.5 11.8 1.02 5.47 720. 1595 4518
> 
> paravirt, no patching
> ezr       Linux 2.6.21- 1000 0.28 0.55 31.3 34.3 10.0 1.05 5.56 747. 1621 4675
> ezr       Linux 2.6.21- 1000 0.28 0.56 31.5 34.3 12.9 1.05 5.66 755. 1629 4684
> ezr       Linux 2.6.21- 1000 0.28 0.55 31.8 34.5 12.5 1.05 5.45 747. 1622 4695

the main metric we are interested in is the overhead for people who just 
want to run the non-patched native kernel that has CONFIG_PARAVIRT 
enabled (99%+ of the users at the moment), so the delta is:

 null:              +12.0%
 null IO:            +7.5%
 stat:        within noise
 open/close:  within noise
 TCP:                ~5.0%
 signal install:      2.0%
 signal handle:       4.7%
 fork:                2.7%
 exec:                3.6%
 shell:               3.6%

this is not 'barely measurable' but 'BLOODY LARGE' overhead. Really. I 
mean for something as complex as exec we still are 'a couple of percent' 
slower? Linux has literally _dozens_ of important but inactive features 
in every critical fastpath and in every critical system call, and if 
each took 'just a few percent', we'd be a few _times_ slower as an end 
result, for features that are not even used! The answer to any such 
overhead is: "get your act together and stop burdening those who dont 
want to use that feature" ... This is a basic engineering requirement.

> paravirt, patching
> ezr       Linux 2.6.21- 1000 0.25 0.53 31.8 34.4 10.1 1.04 5.44 730. 1583 4600
> ezr       Linux 2.6.21- 1000 0.26 0.55 32.1 35.2 13.3 1.03 5.48 748. 1589 4606
> ezr       Linux 2.6.21- 1000 0.26 0.54 32.0 34.9 14.1 1.04 5.43 752. 1606 4647

i guess this pretty much makes the case for patching ...

	Ingo
