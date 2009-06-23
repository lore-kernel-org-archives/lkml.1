Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZFWUTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZFWUTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZFWUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:19:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbZFWUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:19:07 -0400
Date: Tue, 23 Jun 2009 13:18:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090623131848.b876d42e.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 12:25:36 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> The following patch changes the eventfd interface to de-couple the eventfd 
> memory context, from the file pointer instance.
> Without such change, there is no clean way to racely free handle the 
> POLLHUP event sent when the last instance of the file* goes away.
> Also, now the internal eventfd APIs are using the eventfd context instead 
> of the file*.
> Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> adding a bunch of empty function stubs inside eventfd.h in order to 
> handle the (AIO && !EVENTFD) case.
> 
> 
> ...
>
> +/**
> + * eventfd_ctx_get - Acquires a reference to the internal eventfd context.
> + * @ctx: [in] Pointer to the eventfd context.
> + *
> + * Returns: In case of success, returns a pointer to the eventfd context,
> + *          otherwise a proper error code.

The description of the return value

> + */
> +struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
> +{
> +	kref_get(&ctx->kref);
> +	return ctx;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_ctx_get);

doesn't match the code.


Also...

> + * Returns: A pointer to the eventfd file structure in case of success, or a
> + *          proper error pointer in case of failure.


> + * Returns: In case of success, it returns a pointer to the internal eventfd
> + *          context, otherwise a proper error code.
> + */

I'm unsure what the word "proper" means in this context.

The term "proper error pointer" is understandable enough - something
you run IS_ERR() against.  "error pointer" would suffice.

But the term "proper error code" is getting a bit remote from reality.


Unfortunately the kernel doesn't have a simple and agreed-to term for
an ERR_PTR() thingy.  Perhaps we should invent one.  "err_ptr"?

