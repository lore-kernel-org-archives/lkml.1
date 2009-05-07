Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZEGAXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZEGAXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbZEGAXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:23:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760003AbZEGAXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:23:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 May 2009 01:53:49 +0200 <20090506235349.GC3756@redhat.com>
References: <20090505224729.GA965@redhat.com>
	<20090506080050.GF17457@elte.hu>
	<20090506235349.GC3756@redhat.com>
X-Windows: garbage at your fingertips.
Message-Id: <20090507002133.02D05FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 17:21:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was going to cleanup this later. Because I think that
> __ptrace_may_access() should die. It has only one caller, mm_for_maps().

CC'ing Al Viro, who wrote mm_for_maps() (and no one has touched it since,
see commit 831830b).

> I will re-check, but it looks a bit strange. More precisely, I just
> can't understand it. Why we can't just do
> 
> 	struct mm_struct *mm_for_maps(struct task_struct *task)
> 	{
> 		struct mm_struct *mm = get_task_mm(task);
> 
> 		if (mm && mm != current->mm && !ptrace_may_access()) {
> 			mmput(mm);
> 			mm = NULL;
> 		}
> 
> 		return mm;
> 	}

That seems fine to me.  I suspect the old code just predated the PF_KTHREAD
check in get_task_mm() and excluding the borrowed-mm window races was the
only reason for using task_lock() that way.

> ? We do not care if this task exits and clears ->mm right before
> or after ptrace_may_access(), and this is possible eith the current
> code too once it drops tasklist.

I agree.


Thanks,
Roland
