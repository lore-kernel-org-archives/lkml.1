Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXBOS3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXBOS3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030457AbXBOS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:29:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:55552 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030470AbXBOS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:29:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=DpIAX/7T4pN3nxIHGlxKASrRnzuzJEgc3FWAzrbKi433Kugc/18rNwXmQzrBcwkk9aQdIvdH6SqrEAZGL0fAoEcUAaxEhYSkjBa3CldFfoL26lpgI+iYzpncc2SW0pea4wY0sjgSOetJZy07yd+fx/c3qvr9NjGJVtsDdbI2xIg=
Date: Fri, 16 Feb 2007 18:28:13 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/14] syslets: core code
Message-ID: <20070216182813.GB32060@slug>
References: <20070215165228.GF4285@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215165228.GF4285@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:52:28PM +0100, Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> +static struct syslet_uatom __user *
> +exec_atom(struct async_head *ah, struct task_struct *t,
> +	  struct syslet_uatom __user *uatom)
> +{
> +	struct syslet_uatom __user *last_uatom;
> +	struct syslet_atom atom;
> +	long ret;
> +
- run_next:
+ 	do {
> +	if (unlikely(copy_uatom(&atom, uatom)))
> +		return ERR_PTR(-EFAULT);
> +
> +	last_uatom = uatom;
> +	ret = __exec_atom(t, &atom);
> +	if (unlikely(signal_pending(t) || need_resched()))
+ 		break;
- 		goto stop;
> +
> +	uatom = next_uatom(&atom, uatom, ret);
+ 	} while(uatom);
- 	if (uatom)
- 		goto run_next;
-  stop:
> +	/*
> +	 * We do completion only in async context:
> +	 */
> +	if (t->at && complete_uatom(ah, t, &atom, last_uatom))
> +		return ERR_PTR(-EFAULT);
> +
> +	return last_uatom;
> +}
Goto's are cool granted :), but IMO the "do {} while()" is more natural
here.
> +asmlinkage long
> +sys_async_register(struct async_head_user __user *ahu, unsigned int len)
> +{
> +	struct task_struct *t = current;
> +
> +	/*
> +	 * This 'len' check enables future extension of
> +	 * the async_head ABI:
> +	 */
I'm not sure I understand why this isn't a '>' check. If you want to
extend the ABI, you'll add members to async_head_user. So you just need
to check that you understand all the information that userspace passes
to you, or did I missed something?
> +	if (len != sizeof(struct async_head_user))
> +		return -EINVAL;
> +	/*
> +	 * Already registered?
> +	 */
> +	if (t->ah)
> +		return -EEXIST;
> +
> +	return async_head_init(t, ahu);
> +}
> +

Regards,
Frederik
