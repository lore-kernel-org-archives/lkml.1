Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab0BLD5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 22:57:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab0BLD5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 22:57:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       peter.lachner@intel.com
Subject: Re: [patch v3 2/2] ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET
In-Reply-To: Suresh Siddha's message of  Thursday, 11 February 2010 11:51:00 -0800 <20100211195614.886724710@sbs-t61.sc.intel.com>
References: <20100211195058.071883111@sbs-t61.sc.intel.com>
	<20100211195614.886724710@sbs-t61.sc.intel.com>
X-Shopping-List: (1) Distant cow companions
   (2) Recurrent dark rain hatred
   (3) Gripping chasers
   (4) Calamitous samples
Message-Id: <20100212035606.119B3C821@magilla.sf.frob.com>
Date: Thu, 11 Feb 2010 19:56:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that this patch and the xstate user_regset patch are entirely independent.
They can me merged in any order or one without the other.

> +/*
> + * Generic ptrace interface that exports the architecture specific regsets
> + * using the corresponding NT_* types (which are also used in the core dump).

There is a special case here, which I think already works as we intend it
to, but which should be clarified in the comment about this API.  The
NT_PRSTATUS note type in a core dump contains a full 'struct elf_prstatus'.
But the user_regset for NT_PRSTATUS contains just the elf_gregset_t that
is the pr_reg field of 'struct elf_prstatus'.

For all the other user_regset flavors, the user_regset layout and the ELF
core dump note payload are exactly the same layout, as your comment implies.

> +static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
> +			 struct iovec *kiov)
> +{
> +	const struct user_regset_view *view = task_user_regset_view(task);
> +	const struct user_regset *regset = find_regset(view, type);
> +	int regset_no;
> +
> +	if (!regset || (kiov->iov_len % regset->size) != 0)
> +		return -EIO;

My inclination would be to diagnose these more specifically.  For a bad
size, give -EINVAL.  For an unknown regset type, give maybe -EINVAL or
maybe -ENODEV.  (-ENODEV is what you get for a known NT_* type that has a
user_regset implemented in the kernel, but that the particular hardware
we're running on doesn't support.  So perhaps you don't want to overload
that for a wholly unrecognized NT_* type.)

Otherwise, looks good to me.  ACK contingent on Oleg's ACK.


Thanks,
Roland
