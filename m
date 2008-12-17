Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751257AbYLQSz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbYLQSz1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYLQSzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:55:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59449 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYLQSzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:55:10 -0500
Subject: Re: [PATCH 2/2] ipc namespaces: implement support for posix
	msqueues
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.osdl.org>
In-Reply-To: <20081217175549.GB23331@us.ibm.com>
References: <20081217175513.GA23291@us.ibm.com>
	 <20081217175549.GB23331@us.ibm.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 10:54:59 -0800
Message-Id: <1229540099.17206.426.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 11:55 -0600, Serge E. Hallyn wrote:
> -void free_ipc_ns(struct kref *kref)
> +void put_ipc_ns(struct ipc_namespace *ns)
>  {
> -       struct ipc_namespace *ns;
> +       if (ns && atomic_dec_and_lock(&ns->count, &mq_lock)) {
> +               mq_clear_sbinfo(ns);
> +               spin_unlock(&mq_lock);
> +               mq_put_mnt(ns);
> +               free_ipc_ns(ns);
> +       }
> +}

OK, I see now why you wanted to remove the kref and add an atomic_t.
That's probably worth a sentence in the patch description.

I know that atomic_dec_and_lock() can be a nice logical thing to do, but
is it necessary here?  Basically, is there something that happens under
mq_lock that can re-raise the ns->count?

-- Dave

