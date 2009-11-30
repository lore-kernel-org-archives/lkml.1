Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZK3S62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZK3S62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZK3S61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:58:27 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62099 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZK3S60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wTqcJJCPhWcryMy5MTI4YIfZDSzZ2+NYNF6O5yQmbpSllQi/NXUDJbioioV21Hnb3m
         hIS9EcEQnt5YRdv9mevkM6kAvjECITX5ftnLdSySQnNXazi4FXWe4PjLK4CzIOaz2GA4
         Gh+DB/D4C08J2KGq/xppsURScKZch9Tq9AH2s=
MIME-Version: 1.0
In-Reply-To: <20091130170657.GG11670@redhat.com>
References: <200911261710.40719.czoccolo@gmail.com>
	 <20091127082316.GY8742@kernel.dk>
	 <4e5e476b0911270103u61ed5a95t3997e28ae79bac82@mail.gmail.com>
	 <20091130170657.GG11670@redhat.com>
Date: Mon, 30 Nov 2009 19:58:32 +0100
Message-ID: <4e5e476b0911301058u1916e8b9ie07bcdb24002e4b3@mail.gmail.com>
Subject: Re: [RFC,PATCH] cfq-iosched: improve async queue ramp up formula
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, mel@csn.ul.ie, efault@gmx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Mon, Nov 30, 2009 at 6:06 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Got a query. Here assumption is that async queues are not being preempted.
> So driving shallower queue depths at the end of slice will help in terms
> of max latencies and driving deeper queue depths at the beginning of slice
> will help in getting more out of disk, without increasing max latencies.
>
> But if we allow deeper queue depths at the beginning of the async slice,
> and then async queue is preempted, then we are back to the old problem of
> first request taking more time to complete.
The problem should be solved, nevertheless.
First, the deeper queue will start after the first 100ms.
Moreover, we will still dispatch less requests than before, and the
max delay is now limited by the time slice.
Since the async time slice is also reduced according to competing sync
processes, it will not hurt the latency seen by the other processes.

> But I guess that problem will be less severe this time as for sync-noidle
> workload we will idle. So ideally we will experience the higher delays
> only for first request and not on subsequent request. Previously, we did
> not enable idling on random seeky queues and after one dispatch from the
> queue, we will again run async queue and there was high delay after every
> read request.
Yes.
> This is assuming if upon preemption, we started running
> sync-noidle workload and did not continue to dispatch from async workload.
>
> Corrodo, you can clear up the air here. What's the policy w.r.t to
> preemption of async queues and workload slice.
Ok. The workload slice works as follows (this is not only for async,
but for all workloads).
A new slice in the workload can be started if the workload slice did
not expire, and there is a ready queue.
When a queue is active, even if the workload expires, it will still
finish its complete slice, unless it has no requests and times out.

Now, preemption of sync vs async:
* if sync comes when the async workload slice is not expired, it will
just change the rb_key of the preempting queue (and workload),
ensuring that the next selected workload will be the preempting one,
but the preemption will be actually delayed until the workload slice
ends
* if sync comes after the workload slice expired, but the async queue
still has some remaining slice, it will preempt it immediately.

Basically, we protect the async to do some work, even if minimal (the
workload slices can become very small since in async workload there is
usually only 1 queue, and this is scaled against all the queues in the
other workloads).
This has shown to improve the situation when memory pressure is high,
and we need writeback to free some of it.

Thanks,
Corrado
