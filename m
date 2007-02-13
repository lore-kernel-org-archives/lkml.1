Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXBMWQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXBMWQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXBMWQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:16:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:39146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXBMWQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:16:33 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Feb 2007 00:15:58 +0100
In-Reply-To: <20070213142035.GF638@elte.hu>
Message-ID: <p73bqjxhcnl.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> +
> +static struct async_thread *
> +pick_ready_cachemiss_thread(struct async_head *ah)

The cachemiss names are confusing. I assume that's just a left over
from Tux?
> +
> +	memset(atom->args, 0, sizeof(atom->args));
> +
> +	ret |= __get_user(arg_ptr, &uatom->arg_ptr[0]);
> +	if (!arg_ptr)
> +		return ret;
> +	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
> +		return -EFAULT;

It's a little unclear why you do that many individual access_ok()s.
And why is the target constant sized anyways?


+	/*
+	 * Lock down the ring. Note: user-space should not munlock() this,
+	 * because if the ring pages get swapped out then the async
+	 * completion code might return a -EFAULT instead of the expected
+	 * completion. (the kernel safely handles that case too, so this
+	 * isnt a security problem.)
+	 *
+	 * mlock() is better here because it gets resource-accounted
+	 * properly, and even unprivileged userspace has a few pages
+	 * of mlock-able memory available. (which is more than enough
+	 * for the completion-pointers ringbuffer)
+	 */

If it's only a few pages you don't need any resource accounting.
If it's more then it's nasty to steal the users quota.
I think plain gup() would be better.


-Andi
