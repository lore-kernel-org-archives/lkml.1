Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbXBWXI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbXBWXI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXBWXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:08:58 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1360 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbXBWXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:08:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Feb 2007 15:08:55 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 04/13] syslets: core code
In-Reply-To: <20070221211516.GD7579@elte.hu>
Message-ID: <Pine.LNX.4.64.0702231504370.31281@alien.or.mcafeemobile.com>
References: <20070221211516.GD7579@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Ingo Molnar wrote:

> +asmlinkage long
> +sys_threadlet_on(unsigned long restore_stack,
> +		 unsigned long restore_eip,
> +		 struct async_head_user __user *ahu)
> +{
> +	struct task_struct *t = current;
> +	struct async_head *ah = t->ah;
> +	struct async_thread *at = &t->__at;
> +	long ret;
> +
> +	/*
> +	 * Do not allow recursive calls of sys_threadlet_on():
> +	 */
> +	if (t->async_ready || t->at)
> +		return -EINVAL;
> +
> +	if (unlikely(!ah)) {
> +		ret = init_head(ah, t, ahu);
> +		if (ret)
> +			return ret;
> +		ah = t->ah;
> +	}
> +
> +	if (unlikely(list_empty(&ah->ready_async_threads))) {
> +		ret = refill_cachemiss_pool(ah, t, ahu);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	t->async_ready = at;
> +	ah->restore_stack = restore_stack;
> +	ah->restore_eip = restore_eip;
> +
> +	ah->ahu = ahu;
> +
> +	return 0;
> +}
> +
> +asmlinkage long sys_threadlet_off(void)
> +{
> +	struct task_struct *t = current;
> +	struct async_head *ah = t->ah;
> +
> +	/*
> +	 * Are we still executing as head?
> +	 */
> +	if (ah) {
> +		t->async_ready = NULL;
> +
> +		return 1;
> +	}
> +
> +	/*
> +	 * We got turned into a cachemiss thread,
> +	 * return to user-space, which can do
> +	 * the notification, etc:
> +	 */
> +	return 0;
> +}

If we have a new syscall that does the exec, we can save the two on/off 
calls. Also, the complete_thread() thingy can be done automatically from 
inside the kernel upon function return, by hence making the threadlet 
function look like a normal thread function:

long thfn(void *) {

	...
	return error;
}

No?



- Davide


