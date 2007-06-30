Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbXF3Bz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbXF3Bz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 21:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXF3BzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 21:55:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:2386 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXF3BzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 21:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NDzSU4jHzBDy5SCIH8dUW9dAijlKO51G6IF0BPPkJ4I/a+e7XC9ro9fvhceRkuD3l7aHO+zAb3iIZpdWLAvBHmoemIfCrAYjVTyTvrp1hz+nHeX4I2omb9fSPXdGpLfZ0iWgv4q7rL1xJPCTH66BrNVsgHxm2yGGpFs2IdoBr0Q=
Message-ID: <a36005b50706291855j4069e4d0j73c006e9bf180b42@mail.gmail.com>
Date: Fri, 29 Jun 2007 18:55:18 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 3/6] sys_indirect RFC - sys_indirect core
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <send-serie.davidel@xmailserver.org.28360.1183153736.3>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.28360.1183153736.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> +int indirect_set_context(struct fsa_context *ator,
> +                        const struct indirect_ctx __user * __user *ctxs,
> +                        unsigned int nctxs, struct indirect_op **first)
> +{
> +       unsigned int i;
> +       int error;
> +       u32 ctx;
> +       const struct indirect_ctx __user *pctx;
> +       struct indirect_op *new;
> +
> +       *first = NULL;
> +       for (i = 0; i < nctxs; i++) {
> +               if (get_user(pctx, &ctxs[i]) || get_user(ctx, &pctx->ctx))
> +                       return -EFAULT;
> +               if (unlikely(ctx >= ARRAY_SIZE(inprocs) || !inprocs[ctx].set))
> +                       return -EINVAL;
> +               error = (*inprocs[ctx].set)(ator, pctx, &new);
> +               if (unlikely(error))
> +                       return error;
> +               new->next = *first;
> +               *first = new;
> +       }

If you use one single struct as explained in my last mail all this
shouldn't be necessary.  The sys_indirect syscall would simply points
current->ind_ctx to a kernel-copy of the struct.  Then call the
syscall and on return clear current->ind_ctx.

In the affected syscalls we can then test whether current->ind_ctx is
NULL and if not, enable the extra functionality.

These callbacks etc seem to be far too expensive and complicated.
