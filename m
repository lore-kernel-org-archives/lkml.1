Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZK3QBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZK3QBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZK3QBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:01:22 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:39171 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZK3QBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WoMQEmYizToL1qn11/1j69WuXrh5GkCfid3M8Q5+4jH03kjCdhNG9FotJ20X4A91+3
         hyv+UzF/4Mp5bnSUJ3dgEI3w/htValahIU21LiFphzbw5D030goOAuvI+uv8ZLmskqFi
         WybvbN5AqpO+NiFgWXXVCGg1+8NSJ3kNesSto=
MIME-Version: 1.0
In-Reply-To: <20091130153604.GB11670@redhat.com>
References: <4B0E1E2F.9080604@cn.fujitsu.com>
	 <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
	 <20091130153604.GB11670@redhat.com>
Date: Mon, 30 Nov 2009 17:01:28 +0100
Message-ID: <4e5e476b0911300801n57078c8eicd80bdc0f4cb2a87@mail.gmail.com>
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key 
	offset
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 4:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Corrado,
>
> currently rb_key seems to be combination of two things. busy_queues and
> jiffies.
>
> In new scheme, where we decide the share of a workload and then switch to
> new workload, dependence on busy_queues does not seem to make much sense.
>
> Assume, a bunch of sequential readers get backlogged and then few random
> readers gets backlogged. Now random reader will get higher rb_key because
> there are 8 sequential reders on sync-idle tree.
Even if we didn't have busy_queues, we would have the same situation,
e.g. we have the 8 seq readers at time t (jiffies), and the seeky
readers at time t+1.
busy_queues really doesn't add anything when all queues have the same priority.
>
> IIUC, with above logic, even if we expire the sync-idle workload duration
> once, we might not switch to sync-noidle workload and start running the
> sync-idle workload again. (Because minimum slice length restrictions or
> if low_latency is not set).
Yes.
>
> So instead of relying on rb_keys to switch the workload type, why not do
> it in round robin manner across the workload types? So rb_key will be
> significant only with-in service tree and not across service tree?
This is a good option. I have also tested it, and it works quite well
(you can even have an async penalization like in deadline, so you do
few rounds between seq and seeky, and then one of async). Besides a
more complex code, I felt it was against the spirit of CFQ, since in
that way, you are not providing fairness across workloads (especially
if you don't want low_latency).

BTW, my idea how to improve the rb_key computation is:
* for NCQ SSD (or when sched_idle = 0):
  rb_key = jiffies - function(priority)
* for others:
  rb_key = jiffies - sched_resid

Currently, sched_resid is meaningless for NCQ SSD, since we always
expire the queue immediately. Subtracting sched_resid would just give
an advantage to a queue that already dispatched over the ones that
didn't.
Priority, instead, should be used only for NCQ SSD. For the others,
priority already affects time slice, so having it here would cause
over-prioritization.

Thanks,
Corrado

> Thanks
> Vivek
