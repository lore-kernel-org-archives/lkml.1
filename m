Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYFRSWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYFRSWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFRSWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:22:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYFRSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:22:37 -0400
Date: Wed, 18 Jun 2008 14:22:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: akpm@linux-foundation.org, zach.brown@oracle.com, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: invalidate async directio writes
Message-ID: <20080618182223.GA14851@infradead.org>
References: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 02:09:51PM -0400, Jeff Moyer wrote:
> +		/* For async O_DIRECT writes, we need to invalidate the 
> +		 * page cache after the write completes.  Kick off a
> +		 * workqueue to do this and issue the completion in process
> +		 * context.
> +		 */
> +		if (dio->rw == READ) {
> +			int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
> +			aio_complete(dio->iocb, ret, 0);
> +			kfree(dio);
> +		} else {
> +			unsigned long flags;
> +			spin_lock_irqsave(&iocb_completion_list_lock, flags);
> +			list_add(&dio->done_list, &iocb_completion_list);
> +			spin_unlock_irqrestore(&iocb_completion_list_lock, flags);
> +			schedule_work(&aio_complete_work);
> +		}

Can we please move all these aio_complete calls to user context?  Having
AIO contexts completing from irq context is a major pain for complex
filesystems like XFS.
