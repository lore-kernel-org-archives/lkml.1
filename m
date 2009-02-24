Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZBXHsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZBXHsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBXHr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:47:56 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:33103 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZBXHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:47:55 -0500
Date: Tue, 24 Feb 2009 01:47:39 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Linus Torvalds <torvalds@osdl.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v13][PATCH 05/14] x86 support for checkpoint/restart
Message-ID: <20090224014739.1b82fc35@thinkcentre.lan>
In-Reply-To: <1233076092-8660-6-git-send-email-orenl@cs.columbia.edu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
 <1233076092-8660-6-git-send-email-orenl@cs.columbia.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 711B1E7C-0247-11DE-8052-6F7C8D1D4FD0-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is an old thread I guess, but I just noticed some issues while
looking at this code.

On Tue, 27 Jan 2009 12:08:03 -0500
Oren Laadan <orenl@cs.columbia.edu> wrote:
> +static int cr_read_cpu_fpu(struct cr_ctx *ctx, struct task_struct *t)
> +{
> +	void *xstate_buf = cr_hbuf_get(ctx, xstate_size);
> +	int ret;
> +
> +	ret = cr_kread(ctx, xstate_buf, xstate_size);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* i387 + MMU + SSE */
> +	preempt_disable();
> +
> +	/* init_fpu() also calls set_used_math() */
> +	ret = init_fpu(current);
> +	if (ret < 0)
> +		return ret;

Several problems here:
* init_fpu can call kmem_cache_alloc(GFP_KERNEL), but is called here
  with preempt disabled (init_fpu could use a might_sleep annotation?)
* if init_fpu returns an error, we get preempt imbalance
* if init_fpu returns an error, we "leak" the cr_hbuf_get for
  xstate_buf

Speaking of cr_hbuf_get... I'd prefer to see that "allocator" go away
and its users converted to kmalloc/kfree (this is what I've done for
the powerpc C/R code, btw).

Using the slab allocator would:

* make the code less obscure and easier to review
* make the code more amenable to static analysis
* gain the benefits of slab debugging at runtime

But I think this has been pointed out before.  If I understand the
justification for cr_hbuf_get correctly, the allocations it services
are somehow known to be bounded in size and nesting.  But even if that
is the case, it's not much of a reason to avoid using kmalloc, is it?
