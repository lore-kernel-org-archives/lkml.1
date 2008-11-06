Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbYKFVpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbYKFVpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKFVoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:44:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYKFVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:44:53 -0500
Date: Thu, 6 Nov 2008 22:44:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       roland@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] revert: timers: fix itimer/many thread hang
Message-ID: <20081106214434.GA5999@elte.hu>
References: <1224694989.8431.23.camel@oberon> <1225132746.14792.13.camel@bobble.smo.corp.google.com> <1225219114.24204.37.camel@oberon> <1225936715.27507.44.camel@bobble.smo.corp.google.com> <1225969420.7803.4366.camel@twins> <1225989102.7803.4749.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225989102.7803.4749.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> This patch reverts all the itimer/many thread patches:
> 
> 7086efe1c1536f6bc160e7d60a9bfd645b91f279
> bb34d92f643086d546b49cef680f6f305ed84414
> 5ce73a4a5a4893a1aa4cdeed1b1a5a6de42c43b6
> 0a8eaa4f9b58759595a1bfe13a1295fdc25ba026
> f06febc96ba8e0af80bcc3eaec0a109e88275fac
> 
> Because I think the per-cpu accounting approach is wrong and makes 
> things worse for people with a machine that has more than a 
> hand-full of CPUs.

hm, the revert is rather large but i guess the best way forward. 
Unless we can avoid this loop:

-       for_each_possible_cpu(i) {
-               tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
-               times->utime = cputime_add(times->utime, tot->utime);
-               times->stime = cputime_add(times->stime, tot->stime);
-               times->sum_exec_runtime += tot->sum_exec_runtime;
-       }

we have to revert it.

That loop could _perhaps_ be avoided by maintaining the sums from the 
scheduler tick: by just adding the latest delta values for the current 
task to times->*time. Plus at exit time cleaning up the remaining 
delta. That would be a far smaller patch.

	Ingo
