Return-Path: <linux-kernel-owner+w=401wt.eu-S1765436AbYDPPEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765436AbYDPPEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYDPPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:04:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56777 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYDPPEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:04:30 -0400
Date: Wed, 16 Apr 2008 17:03:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-ID: <20080416150353.GA26740@elte.hu>
References: <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416000356.GA24737@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ps. anyone who can correctly guess the method with which i found the
>     exact place that corrupted memory will get a free beer next time 
>     we meet :-)

the method was to notice that the slub_debug_slabs SLUB variable got 
corrupted from an expected value of 0 to a value of 0x1.

Then i added a simple brute-force function-tracer hook (in sched-devel) 
that checked when slub_debug_slabs went from 0 to 1, and which then 
printed a backtrace.

Since under CONFIG_FTRACE=y every kernel function calls this callback, 
it triggered immediately after the value got corrupted:

[    0.000000] console [earlyser0] enabled
[    0.000000] BUG: slub_debug_slabs: 00000001
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-rc9-sched-devel.git-x86-latest.git #982
[    0.000000]  [<c0177fba>] print_slub_debug_slabs+0x3a/0x40
[    0.000000]  [<c01050f7>] trace+0x8/0x11
[    0.000000]  [<c0cc929e>] ? mtrr_bp_init+0xe/0x320
[    0.000000]  [<c01050f7>] ? trace+0x8/0x11
[    0.000000]  [<c0cd7369>] ? memory_present+0x9/0x50
[    0.000000]  [<c0cc7a09>] ? find_max_pfn+0x99/0xb0
[    0.000000]  [<c0cc6af7>] setup_arch+0x217/0x470
[    0.000000]  [<c012c59b>] ? printk+0x1b/0x20
[    0.000000]  [<c0cc2b46>] start_kernel+0x96/0x3f0
[    0.000000]  [<c0cc22fd>] i386_start_kernel+0xd/0x10
[    0.000000]  =======================
[    0.000000] x86: PAT support disabled.

and the backtrace had all the guilty parties on stack - memory_present() 
[which was just called] and find_max_pfn()/setup_arch() - thanks to the 
new fuzzy "?" backtrace entries we print out in v2.6.25.

(i could also have printed out the current ftrace buffer as well, 
showing the history of all recent function calls that the kernel 
executed.)

	Ingo
