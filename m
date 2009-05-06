Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZEFX77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZEFX77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZEFX7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:59:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54011 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZEFX7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:59:49 -0400
Date: Thu, 7 May 2009 01:53:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090506235349.GC3756@redhat.com>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506080050.GF17457@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +	task_lock(task);
> >  	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
> > +	task_unlock(task);
> >  	if (retval)
> > -		goto bad;
> > +		goto unlock_creds;
>
> Hm, that's a bit ugly - why dont you reuse ptrace_may_access(),
> which does much of this already?

Indeed, even the changelog mentions this.

I was going to cleanup this later. Because I think that
__ptrace_may_access() should die. It has only one caller, mm_for_maps().
I will re-check, but it looks a bit strange. More precisely, I just
can't understand it. Why we can't just do

	struct mm_struct *mm_for_maps(struct task_struct *task)
	{
		struct mm_struct *mm = get_task_mm(task);

		if (mm && mm != current->mm && !ptrace_may_access()) {
			mmput(mm);
			mm = NULL;
		}

		return mm;
	}

? We do not care if this task exits and clears ->mm right before
or after ptrace_may_access(), and this is possible eith the current
code too once it drops tasklist.

Oleg.

