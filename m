Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbYFSRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbYFSRXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYFSRXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:23:12 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:49691 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758611AbYFSRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:23:11 -0400
Message-ID: <485A95FE.9080308@oracle.com>
Date: Thu, 19 Jun 2008 10:23:10 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: akpm@linux-foundation.org, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: invalidate async directio writes
References: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static DECLARE_WORK(aio_complete_work, aio_complete_fn, NULL);
> +static DEFINE_SPINLOCK(iocb_completion_list_lock);
> +static LIST_HEAD(iocb_completion_list);

It seems like a bad idea to funnel all AIO DIO completion in the system
through one cacheline.  Should we have per-cpu lists and work structs?

> +			unsigned long flags;
> +			spin_lock_irqsave(&iocb_completion_list_lock, flags);
> +			list_add(&dio->done_list, &iocb_completion_list);
> +			spin_unlock_irqrestore(&iocb_completion_list_lock, flags);
> +			schedule_work(&aio_complete_work);

And we should probably use list_add_tail() here so that we don't reverse
 the order of IO completion and end_io() callbacks.

And hopefully going per-cpu could simplify the locking so that we don't
have even more per-io locking.

- z
