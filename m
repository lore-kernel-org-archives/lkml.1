Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYFRTqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYFRTqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYFRTqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:46:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbYFRTqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:46:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, zach.brown@oracle.com, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: invalidate async directio writes
References: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
	<20080618182223.GA14851@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 18 Jun 2008 15:45:28 -0400
In-Reply-To: <20080618182223.GA14851@infradead.org> (Christoph Hellwig's
	message of "Wed, 18 Jun 2008 14:22:23 -0400")
Message-ID: <x49abhiy1bb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Jun 18, 2008 at 02:09:51PM -0400, Jeff Moyer wrote:
>> +		/* For async O_DIRECT writes, we need to invalidate the 
>> +		 * page cache after the write completes.  Kick off a
>> +		 * workqueue to do this and issue the completion in process
>> +		 * context.
>> +		 */
>> +		if (dio->rw == READ) {
>> +			int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
>> +			aio_complete(dio->iocb, ret, 0);
>> +			kfree(dio);
>> +		} else {
>> +			unsigned long flags;
>> +			spin_lock_irqsave(&iocb_completion_list_lock, flags);
>> +			list_add(&dio->done_list, &iocb_completion_list);
>> +			spin_unlock_irqrestore(&iocb_completion_list_lock, flags);
>> +			schedule_work(&aio_complete_work);
>> +		}
>
> Can we please move all these aio_complete calls to user context?  Having
> AIO contexts completing from irq context is a major pain for complex
> filesystems like XFS.

Can you help me understand why this is a pain?  I'm having trouble
making the connection.

Thanks!

Jeff
