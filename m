Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZFXVXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZFXVXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbZFXVXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:23:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440AbZFXVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:23:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A427F83.8010404@novell.com>
References: <4A427F83.8010404@novell.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: dhowells@redhat.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] slow-work: add (module*)work->owner to fix races with module clients
Date: Wed, 24 Jun 2009 22:23:02 +0100
Message-ID: <7230.1245878582@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins <ghaskins@novell.com> wrote:

>   I found this while working on KVM.  I actually posted this patch with
> a KVM
> series yesterday and standalone earlier today, but neither seems to have
> made it to the lists.  I suspect there is an issue with git-mail/postfix
> on my system.

Also, your mail client has damaged the whitespace in the patch.

>  struct slow_work {
> +    struct module          *owner;

Can you add it to slow_work_ops instead?

>      work->ops->put_ref(work);
> +    barrier(); /* ensure that put_ref is not re-ordered with module_put =
> */
> +    module_put(work->owner);

Ummm...  Can it be?  module_put() and put_ref() are both out of line - surely
the compiler isn't allowed to reorder them?  If it's the CPU doing it then
barrier() isn't going to save you.

Note, however, that work may not be dereferenced like this after put_ref() is
called, unless you're sure that there's still a reference outstanding.

> +            if (!try_module_get(work->owner))
> +                goto cant_get_mod;

Note that this may result in a module getting stuck in unloading.  It may need
to do some work to complete the unload, and this will prevent that.

A better way might be to have put_ref() return, say, a pointer to a completion
struct, and if not NULL, have the caller of put_ref() call complete() on it.
That way you don't need to touch the module count, but can have something in
put_ref() keep track of when the last object is released and have its caller
invoke a completion to celebrate this fact.

David
