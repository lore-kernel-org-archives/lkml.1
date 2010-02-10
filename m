Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0BJTNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:13:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab0BJTM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:12:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 4/4] ptrace: Add support for generic
	PTRACE_GETREGSET/PTRACE_SETREGSET
In-Reply-To: Oleg Nesterov's message of  Wednesday, 10 February 2010 14:18:26 +0100 <20100210131826.GA21196@redhat.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.406177090@sbs-t61.sc.intel.com>
	<20100210131826.GA21196@redhat.com>
X-Shopping-List: (1) Indecent inundated protrusions
   (2) Serious chain commendations
   (3) Stagnant welt dogs
   (4) Abrupt friction
Message-Id: <20100210191240.DC9E4CC@magilla.sf.frob.com>
Date: Wed, 10 Feb 2010 11:12:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
> +			struct iovec *uiov)
			       	     ^__user
> +{
> +	const struct user_regset_view *view = task_user_regset_view(task);
> +	const struct user_regset *regset = find_regset(view, type);
> +	struct iovec kiov;
> +
> +	if (!regset)
> +		return -EIO;
> +
> +	if (copy_from_user(&kiov, uiov, sizeof kiov))
> +		return -EFAULT;

Since it's just two words, most places handling struct iovec seem to just
use two get_user() calls, which is probably more efficient.

Also, here is where this function would need to be split in half for
compat_ptrace_request() calls where it has to use struct compat_iovec.

> +	// I am not sure. Afaics it is OK to pass the
> +	// size which is less than n * size. If iov_len
> +	// is bigger, we can silently truncate it, or
> +	// even write the correct value back.

Modifying iov_len to report how much we accessed seems good to me.  If we
do that, we should certainly allow a larger size for get, so userland can
just use a generic large buffer before even knowing the real size.  I'm not
sure whether we should allow a smaller size, especially for set.  I could
go either way.


Thanks,
Roland
