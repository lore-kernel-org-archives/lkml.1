Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbXE3IbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbXE3IbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXE3IbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:31:06 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:11356 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXE3IbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:31:04 -0400
Date: Wed, 30 May 2007 12:39:39 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] /proc/*/environ: wrong placing of ptrace_may_attach() check
Message-ID: <20070530083939.GA10627@localhost.sw.ru>
References: <20070528134157.GA7171@localhost.sw.ru> <20070529171623.6879e159.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529171623.6879e159.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 05:16:23PM -0700, Andrew Morton wrote:
> On Mon, 28 May 2007 17:41:57 +0400
> Alexey Dobriyan <adobriyan@sw.ru> wrote:

> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -204,12 +204,17 @@ static int proc_pid_environ(struct task_
> >  	int res = 0;
> >  	struct mm_struct *mm = get_task_mm(task);
> >  	if (mm) {
> > -		unsigned int len = mm->env_end - mm->env_start;
> > +		unsigned int len;
> > +
> > +		res = -ESRCH;
> > +		if (!ptrace_may_attach(task))
> > +			goto out;
> > +
> > +		len  = mm->env_end - mm->env_start;
> >  		if (len > PAGE_SIZE)
> >  			len = PAGE_SIZE;
> >  		res = access_process_vm(task, mm->env_start, buffer, len, 0);
> > -		if (!ptrace_may_attach(task))
> > -			res = -ESRCH;
> > +out:
> >  		mmput(mm);
> >  	}
> >  	return res;
>
> What's wrong with the existing code?  It's a bit dopey-looking and can, I
> guess, permit a task to cause a pagefault in an mm which it doesn't have
> permission to read from.  But is there some more serious problem being
> fixed here?

I think not, because environment will be copied from target task, stay
in kernel tmp buffer, but not copied to target buffer due to -ESRCH.
But such code is asking for problems.

