Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZKBSvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZKBSvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZKBSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:51:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621AbZKBSvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:51:47 -0500
Date: Mon, 2 Nov 2009 19:51:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091102185137.GA28803@elte.hu>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102175407.GE4075@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> > Have you ensured that no rlimit gets propagated during task init 
> > into some other value - under the previously correct assumption that 
> > rlimits dont change asynchronously under the feet of tasks?
> 
> I've looked, and the only place that I see the rlim array getting 
> copied is via copy_signal when we're in the clone path.  The entire 
> rlim array is copied from old task_struct to new task_struct under the 
> protection of the current->group_leader task lock, which I also hold 
> when updating via sys_setprlimit, so I think we're safe in this case.

I mean - do we set up any data structure based on a particular rlimit, 
that can get out of sync with the rlimit being updated?

A prominent example would be the stack limit - we base address layout 
decisions on it. Check arch/x86/mm/mmap.c. RLIM_INFINITY has a special 
meaning plus we also set mmap_base() based on the rlim.

Also, there appears to be almost no security checks in the new syscall! 
We look up a PID but that's it - this code will allow unprivileged users 
to lower various rlimits of system daemons - as if it were their own 
limit. That's a rather big security hole.

	Ingo
