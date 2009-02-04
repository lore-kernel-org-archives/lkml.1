Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZBDNVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZBDNVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZBDNVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:21:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZBDNVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:21:46 -0500
Date: Wed, 4 Feb 2009 14:19:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Roland McGrath <roland@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of
	->signal to check the task is alive
Message-ID: <20090204131901.GA7367@redhat.com>
References: <20090203231717.GA5028@redhat.com> <1233746479.5076.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233746479.5076.6.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Peter Zijlstra wrote:
>
> On Wed, 2009-02-04 at 00:17 +0100, Oleg Nesterov wrote:
> > Sadly, it is not trivial to audit kernel/posix-cpu-timers.c, but it really
> > abuses tasklist_lock. I believe it doesn't need this lock at all, but the
> > changes are not easy to test.
>
> It uses that to hold of task reaping so ->signal doesn't go away.

Yes sure, but ->siglock alone is enough (this was not true when this code
was written, as far as I know). It is not trivial to remove tasklist
completely, but some places are trivial.

> If we make ->signal refcountable, and rcu freed along with the tasks I
> think we can get away without tasklist_lock.

I think this is possible even without this change (which is good anyway).
But the problem is not only that ->signal can go away. For example,
posix_cpu_timer_set/posix_cpu_timer_schedule should not proceed if the
task was already released, even if it had the valid ->signal.

Oleg.

