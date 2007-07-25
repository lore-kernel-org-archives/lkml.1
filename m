Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbXGYLCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbXGYLCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbXGYLCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:02:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758739AbXGYLCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:02:10 -0400
Date: Wed, 25 Jul 2007 13:01:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tong Li <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070725110159.GA15076@elte.hu>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tong Li <tong.n.li@intel.com> wrote:

> This patch extends CFS to achieve better fairness for SMPs. For 
> example, with 10 tasks (same priority) on 8 CPUs, it enables each task 
> to receive equal CPU time (80%). [...]

hm, CFS should already offer reasonable long-term SMP fairness. It 
certainly works on a dual-core box, i just started 3 tasks of the same 
priority on 2 CPUs, and on vanilla 2.6.23-rc1 the distribution is this:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7084 mingo     20   0  1576  248  196 R   67  0.0   0:50.13 loop
 7083 mingo     20   0  1576  244  196 R   66  0.0   0:48.86 loop
 7085 mingo     20   0  1576  244  196 R   66  0.0   0:49.45 loop

so each task gets a perfect 66% of CPU time.

prior CFS, we indeed did a 50%/50%/100% split - so for example on 
v2.6.22:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2256 mingo     25   0  1580  248  196 R  100  0.0   1:03.19 loop
 2255 mingo     25   0  1580  248  196 R   50  0.0   0:31.79 loop
 2257 mingo     25   0  1580  248  196 R   50  0.0   0:31.69 loop

but CFS has changed that behavior.

I'll check your 10-tasks-on-8-cpus example on an 8-way box too, maybe we 
regressed somewhere ...

	Ingo
