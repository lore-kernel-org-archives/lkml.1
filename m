Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZGGNVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZGGNVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZGGNVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:21:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46510 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbZGGNVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:21:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090629191653.14240.44995.stgit@dev.haskins.net>
References: <20090629191653.14240.44995.stgit@dev.haskins.net>
To: Gregory Haskins <ghaskins@novell.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com,
       swhiteho@redhat.com
Subject: Re: [PATCH v4] slow-work: add (module*)work->ops->owner to fix races with module clients
Date: Tue, 07 Jul 2009 14:21:33 +0100
Message-ID: <15258.1246972893@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins <ghaskins@novell.com> wrote:

> +	struct module *owner = work->ops->owner;
> +
> +	work->ops->put_ref(work);
> +	module_put(owner);

Hmmm...  There needs to be an smp_mb() between the read of the module owner
and the call to put_ref(), lest the CPU reorder things...  However, if
put_ref(), say, calls atomic_dec_and_test(), then inserting one here would be
superfluous.

I think documenting this will be enough - perhaps something like:

 (*) Release a reference on an item:

	void (*put_ref)(struct slow_work *work);

     This allows the thread pool to unpin an item by releasing the reference on
     it.  The thread pool will not touch the item again once this has been
     called.

     This function must interpolate a general SMP memory barrier before freeing
     or re-using the work struct as the caller may have read the module
     pointer.  Implying a barrier with something like atomic_dec_and_test() is
     sufficient.

Do you agree?

David
