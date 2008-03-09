Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYCILP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYCILP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYCILPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:15:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYCILPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:15:16 -0400
Date: Sun, 9 Mar 2008 12:14:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309111456.GA21690@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Bart reported http://bugzilla.kernel.org/show_bug.cgi?id=9991. He 
> assumed a memory leak in 32bit kernels when he analyzed the output of 
> /proc/meminfo.
> 
> The leak is not a leak, it's an accounting bug. quicklists keep a 
> large amount of pages which are accounted as used memory.
[...]
> Another strange observation about quicklists is the imbalance of the 
> quicklists across CPUs. Running the above loop on a 2way machine I can 
> observe that the quicklist pages are acuumulating on one CPU. Stopping 
> and restarting the loop a couple of times can shift the accumulation 
> from one to the other CPU.

hm. I think we should not let this much RAM hang around in a 
special-purpose allocator like quicklists. Shouldnt the quicklists be 
temporary in nature, and be trimmed much more agressively?

in fact, we have a check_pgt_cache() call in cpu_idle(), which does:

        quicklist_trim(0, pgd_dtor, 25, 16);

but it appears we dont do quicklist trimming anywhere else! So if a 
system has no idle time, the quicklist can grow unbounded, and that's a 
real memory leak IMO.

	Ingo
