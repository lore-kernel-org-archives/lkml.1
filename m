Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbYDPWZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbYDPWZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYDPWY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:24:59 -0400
Received: from nebensachen.de ([195.34.83.29]:59550 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYDPWY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:24:59 -0400
X-Hashcash: 1:20:080416:jens.axboe@oracle.com::5iPDbO7+h77zXLpt:00000000000000000000000000000000000000002MLB
X-Hashcash: 1:20:080416:linux-kernel@vger.kernel.org::rDn48XDowSZS++BB:00000000000000000000000000000000069j7
X-Hashcash: 1:20:080416:stable@kernel.org::9psNHIFozTl+DeU9:000000000000000000000000000000000000000000000VUG
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Block: Prevent busy looping
References: <20080416151305.8788.63912.stgit@denkblock.local>
	<20080416163152.GK12774@kernel.dk>
Date: Thu, 17 Apr 2008 00:24:32 +0200
In-Reply-To: <20080416163152.GK12774@kernel.dk> (Jens Axboe's message of "Wed,
	16 Apr 2008 18:31:54 +0200")
Message-ID: <87r6d5l9pb.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Apr 16 2008, Elias Oltmanns wrote:
>> blk_run_queue() as well as blk_start_queue() plug the device on reentry
>> and schedule blk_unplug_work() right afterwards. However,
>> blk_plug_device() takes care of that already and makes sure that there is
>> a short delay before blk_unplug_work() is scheduled. This is important
>> to prevent busy looping and possibly system lockups as observed here:
>> <http://permalink.gmane.org/gmane.linux.ide/28351>.
>
> If you call blk_start_queue() and blk_run_queue(), you better mean it.
> There should be no delay. The only reason it does blk_plug_device() is
> so that the work queue function will actually do some work.

Well, I'm mainly concerned with blk_run_queue(). In a comment it says
that it should recurse only once so as not to overrun the stack. On my
machine, however, immediate rescheduling may have exactly as disastrous
consequences as an overrunning stack would have since the system locks
up completely.

Just to get this straight: Are low level drivers allowed to rely on
blk_run_queue() that there will be no loops or do they have to make sure
that this function is not called from the request_fn() of the same
queue?

> In the newer kernels we just do:
>
>         set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
>         kblockd_schedule_work(q, &q->unplug_work);
>
> instead, which is much better.

Only as long as it doesn't get called from the request_fn() of the same
queue. Otherwise, there may be no chance for other threads to clear the
condition that caused blk_run_queue() to be called in the first place.

Regards,

Elias
