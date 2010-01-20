Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755Ab0ATBTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0ATBTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 20:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690Ab0ATBTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 20:19:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:59234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0ATBS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 20:18:59 -0500
Message-ID: <4B565B26.3060709@kernel.org>
Date: Wed, 20 Jan 2010 10:23:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH 38/40] cifs: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-39-git-send-email-tj@kernel.org>	<20100119072000.247ac894@tlielax.poochiereds.net>	<4B564B12.7020909@kernel.org> <20100119195641.7b6a17e4@tlielax.poochiereds.net>
In-Reply-To: <20100119195641.7b6a17e4@tlielax.poochiereds.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 01:17:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 09:56 AM, Jeff Layton wrote:
>> Hmmm... Why is locking GlobalSMBSeslock necessary?
>> cifs_oplock_break_get() can never fail and it seems that
>> is_valid_oplock_break() should be holding valid reference by the time
>> it enqueues the work, so wouldn't the following be sufficient?
>>
>> 	if (queue_work(system_single_wq, &netfile->oplock_break))
>> 		cifs_oplock_break_get(netfile);
>>
> 
> I guess I wasn't sure I could count on that. It seems unlikely that the
> work would run before you did the "get", but unlikely races are even
> harder to troubleshoot when they do get hit.
> 
> FWIW, it's not a terribly hot codepath, so taking and dropping the
> spinlock shouldn't be too bad for performance. If you're certain that
> we don't need to worry about it though, then maybe we can just skip
> doing that.

Oooh, I don't know the code very well and can't guarantee any of that.
Ah, okay, I was confused.  Work can run and finish before the
reference is incremented.  So, yeap, I'll add the spinlocking in the
work function.

>>> Also, this change seems to have changed the logic a bit. The
>>> oplock_break_cancelled flag is being set to false unconditionally, and
>>> the printk was dropped. Not a big deal on the last part, but we can't
>>> really do much with errors in this codepath so it might be helpful to
>>> have some indication that there are problems here.
>>
>> The thing is that slow_work_enqueue() can only fail if getting a
>> reference fails.  In cifs' case, it always succeeds so there's no
>> failure case to handle there.
>>
> 
> Ok, but here we're changing this to queue_work. Is that also guaranteed
> to succeed here? If so, then dropping the printk is fine. If not, then
> I think we should keep it in.

Yeap, queue_work() is guaranteed to succeed.  The only possible
outcomes are 1. queued or 2. is already queued.

> It's been a while since I overhauled this code, so I'll need to look
> again at the semantics for the oplock_break_cancelled flag. It may be
> ok to just set it unconditionally like this, but I'll need to check
> and be sure.

Thanks.

-- 
tejun
