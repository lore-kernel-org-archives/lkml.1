Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYGFPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYGFPrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYGFPrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:47:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652AbYGFPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:47:12 -0400
Date: Sun, 6 Jul 2008 08:46:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
Message-ID: <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11025
> Subject		: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
> Submitter	: Dan Williams <dan.j.williams@intel.com>
> Date		: 2008-07-01 1:57 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=121487749429883&w=4
> Handled-By	: Mel Gorman <mel@csn.ul.ie>
> 		  Andy Whitcroft <apw@shadowen.org>

Fixed by commit 494de90098784b8e2797598cefdd34188884ec2e: "Do not 
overwrite nr_zones on !NUMA when initialising zlcache_ptr" by Mel.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10919
> Subject		: [regression] display dimming is slow and laggy - Acer Travelmate 661lci
> Submitter	: Maximilian Engelhardt <maxi@daemonizer.de>
> Date		: 2008-06-14 22:31 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=121348428828320&w=4

I wonder if this one could be related. The 'nr_zones' overwriting bug 
would result in kswapd not reclaiming any memory asynchronously, so the 
kernel would basically be constantly under a low-memory situation, and 
processes would be forced to do synchronous reclaim. 

That, in turn, could easily explain laggy operation, especially if it is 
something bigger that needs to allocate new memory (not that I know if X 
dimming needs to, but I could imagine that it does some double buffering 
or whatever).

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> Subject		: x86_64 boot hang when CONFIG_NUMA=n
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-06-05 21:50 (32 days old)
> References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> 		  http://lkml.org/lkml/2008/6/11/355
> 		  http://lkml.org/lkml/2008/6/15/117
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>

This really doesn't sound like low memory, but the CONFIG_NUMA thing is 
intriguing, since again, the 'nr_zones' thing depended on that. It would 
break 'balance_pgdat()' entirely, and maybe some balancing operation can 
get confused even before you actually run out of memory

Unlikely, but worth re-testing.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11008
> Subject		: after laptop re-dock: usb-storage device no longer detected
> Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Date		: 2008-06-26 17:37 (11 days old)
> References	: http://lkml.org/lkml/2008/6/26/391
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://lkml.org/lkml/2008/6/30/305

This patch got merged: commit 1236edf1c70107a0d31b3fba0b2a8783615d0d24 
("USB: don't lose disconnections during suspend").

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11006
> Subject		: 2.6.26-rc6: pcmcia stopped working
> Submitter	: Pavel Machek <pavel@suse.cz>
> Date		: 2008-06-22 22:40 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=121420740806363&w=4
> 		  http://marc.info/?t=121439185700001&r=1&w=4
> Handled-By	: Tejun Heo <htejun@gmail.com>
> 		  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121526230022719&w=4

Ditto: commit 7cd95f56cb61f5348d062527c9d3653196f6e629 ("ide: fix 
hwif->gendev refcounting")

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10860
> Subject		: total system freeze at boot with 2.6.26-rc
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2008-06-05 12:38 (32 days old)
> Handled-By	: Tejun Heo <htejun@gmail.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16556

Fixed in commit 70a3143af87c6ca188107cbd49ab5eec2c86c456 ("sata_uli: 
hardreset is broken")

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> Date		: 2008-05-27 09:23 (41 days old)
> References	: http://lkml.org/lkml/2008/5/27/9
> 		  http://lkml.org/lkml/2008/6/14/87
> Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> 		  Linus Torvalds <torvalds@linux-foundation.org>
> 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Patch		: http://lkml.org/lkml/2008/5/28/16

This one is the same thing that is reported as unresolved, and no, I don't 
think that existing patch was ever really tested to fix anything. Paul?

I suspect SRCU will need to be simply marked BROKEN for now, because 
nobody knows what the problem Alexey sees is. Apparently it's been seen by 
a few other people too.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
> Subject		: x86-64 NODES_SHIFT compile failure.
> Submitter	: Dave Jones <davej@codemonkey.org.uk>
> Date		: 2008-05-16 12:54 (52 days old)
> References	: http://lkml.org/lkml/2008/5/16/312
> Handled-By	: Mike Travis <travis@sgi.com>
> Patch		: http://lkml.org/lkml/2008/5/16/343

Fixed in commit efac41894df57d32b483ac622d03541b5b2692c0 ("x86: fix 
NODES_SHIFT Kconfig range").

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
> Subject		: USB Mass storage mount fails: Write protect on
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2008-05-16 14:55 (52 days old)
> References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://marc.info/?l=linux-scsi&m=121433068314568&w=2

Hmm. James?

				Linus
