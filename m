Return-Path: <linux-kernel-owner+w=401wt.eu-S935575AbZLHEqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575AbZLHEqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 23:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZLHEqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 23:46:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33820 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578AbZLHEqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 23:46:21 -0500
Date: Tue, 8 Dec 2009 05:46:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Timo Sirainen <tss@iki.fi>, WANG Cong <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-ID: <20091208044605.GA32669@elte.hu>
References: <20091208121145.B58D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208121145.B58D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +	/*
> +	 * If argv and environ aren't continuous (i.e. the process used
> +	 * prctl(PR_SET_PROCTITLE_AREA)), we don't care environ override.

s/dont't care environ override/don't care about the evironment override/

> +		case PR_SET_PROCTITLE_AREA: {
> +			struct mm_struct *mm = current->mm;
> +			unsigned long addr = arg2;
> +			unsigned long len = arg3;
> +			unsigned long end = arg2 + arg3;

would be cleaner to write the latter as 'addr + len'.

> +			if (len > PAGE_SIZE)
> +				return -EINVAL;
> +
> +			if (addr >= end)
> +				return -EINVAL;
> +
> +			/*
> +			 * If the process pass broken pointer, EFAULT is might better
> +			 * than ps output zero-length proctitle. Plus if
> +			 * the process pass kernel address (or something-else),
> +			 * We have to block it. Oherwise, strange exploit
> +			 * chance is there.
> +			 */
> +			if (!access_ok(VERIFY_READ, addr, len))
> +				return -EFAULT;

the addr >= end check looks (partly) duplicative of the access_ok() 
check.

> +
> +			down_write(&mm->mmap_sem);
> +			mm->arg_start = addr;
> +			mm->arg_end = end;
> +			up_write(&mm->mmap_sem);

well we might as well name 'addr' as 'start' and have a match then here 
too.

The feature looks useful, but the choice of a prctl as an API is strange 
- it limits us to the current task only - while the ability to set 
arguments for another task looks a more generic (and potentially more 
useful) solution.

	Ingo
