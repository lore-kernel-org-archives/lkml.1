Return-Path: <linux-kernel-owner+w=401wt.eu-S935610AbZLHFKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935610AbZLHFKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 00:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZLHFKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 00:10:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41006 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZLHFKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 00:10:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Bryan Donlan <bdonlan@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, Timo Sirainen <tss@iki.fi>,
       WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091208044605.GA32669@elte.hu>
References: <20091208121145.B58D.A69D9226@jp.fujitsu.com> <20091208044605.GA32669@elte.hu>
Message-Id: <20091208135010.B5A8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 14:10:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > +	/*
> > +	 * If argv and environ aren't continuous (i.e. the process used
> > +	 * prctl(PR_SET_PROCTITLE_AREA)), we don't care environ override.
> 
> s/dont't care environ override/don't care about the evironment override/

Thanks. I'll fix.

> 
> > +		case PR_SET_PROCTITLE_AREA: {
> > +			struct mm_struct *mm = current->mm;
> > +			unsigned long addr = arg2;
> > +			unsigned long len = arg3;
> > +			unsigned long end = arg2 + arg3;
> 
> would be cleaner to write the latter as 'addr + len'.

Will fix.

> 
> > +			if (len > PAGE_SIZE)
> > +				return -EINVAL;
> > +
> > +			if (addr >= end)
> > +				return -EINVAL;
> > +
> > +			/*
> > +			 * If the process pass broken pointer, EFAULT is might better
> > +			 * than ps output zero-length proctitle. Plus if
> > +			 * the process pass kernel address (or something-else),
> > +			 * We have to block it. Oherwise, strange exploit
> > +			 * chance is there.
> > +			 */
> > +			if (!access_ok(VERIFY_READ, addr, len))
> > +				return -EFAULT;
> 
> the addr >= end check looks (partly) duplicative of the access_ok() 
> check.

ok.

> > +
> > +			down_write(&mm->mmap_sem);
> > +			mm->arg_start = addr;
> > +			mm->arg_end = end;
> > +			up_write(&mm->mmap_sem);
> 
> well we might as well name 'addr' as 'start' and have a match then here 
> too.

I'll do.


> The feature looks useful, but the choice of a prctl as an API is strange 
> - it limits us to the current task only - while the ability to set 
> arguments for another task looks a more generic (and potentially more 
> useful) solution.

No. It's impossible.
/proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
receive string, it receive virtual address itself. I don't want any task
allow to change another task's memory except ptrace.

Plus, glibc don't need such capability. setproctitle() can only cahnge
own task's title.

Of cource, we can change argv is held in kernel structure (e.g. task_struct or
mm_struct). but it increase kernel memory footprint and I'm not sure its worth.



