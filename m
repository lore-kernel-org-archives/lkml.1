Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbXH2Exi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbXH2Exi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXH2Exb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:53:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbXH2Ex3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:53:29 -0400
Date: Wed, 29 Aug 2007 06:53:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Keith Packard <keith.packard@intel.com>
Subject: Re: CFS review
Message-ID: <20070829045316.GA15064@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org> <20070828164507.GA2969@elte.hu> <200708290719.24422.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708290719.24422.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> I have narrowed it down a bit to add_wait_runtime.

the scheduler is a red herring here. Could you "strace -ttt -TTT" one of 
the glxgears instances (and send us the cfs-debug-info.sh output, with 
CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y as requested before) so 
that we can have a closer look?

i reproduced something similar and there the stall is caused by 1+ 
second select() delays on the X client<->server socket. The scheduler 
stats agree with that:

 se.sleep_max             :          2194711437
 se.block_max             :                   0
 se.exec_max              :              977446
 se.wait_max              :             1912321

the scheduler itself had a worst-case scheduling delay of 1.9 
milliseconds for that glxgears instance (which is perfectly good - in 
fact - excellent interactivity) - but the task had a maximum sleep time 
of 2.19 seconds. So the 'glitch' was not caused by the scheduler.

	Ingo
