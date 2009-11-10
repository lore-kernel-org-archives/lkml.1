Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZKJL30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZKJL30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZKJL3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:29:25 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34575 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZKJL3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jXgN2373rf9mpD1bN4wMzzesw+SH1H7opoTg3B9PBMvOODsvu5qYOC/4BCHgcpDZ3o
         7CNXSE7K8BtHi2+GUNdkK5DFBVGF0OmJZZIg0zZX1QxXoCs6MdFwl6bYQ8/wR9gENU+v
         YR24oV0ivWd9Hd4/eVRJlLIDen1tNqC1WR7Wg=
MIME-Version: 1.0
In-Reply-To: <20091109231257.GG22860@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091106222257.GB2969@redhat.com>
	 <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com>
	 <20091109231257.GG22860@redhat.com>
Date: Tue, 10 Nov 2009 12:29:30 +0100
Message-ID: <4e5e476b0911100329v5da70aedj4a943c4b0220cee8@mail.gmail.com>
Subject: Re: [RFC] Workload type Vs Groups (Was: Re: [PATCH 02/20] blkio: 
	Change CFQ to use CFS like queue time stamps)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 12:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> I thought it was reverse. For sync-noidle workoads (typically seeky), we
> do lot less IO and size of IO is not the right measure otherwise most of
> the disk time we will be giving to this sync-noidle queue/group and
> sync-idle queues will be heavily punished in other groups.

This happens only if you try to measure both sequential and seeky with
the same metric.
But as soon as you can have a specific metric for each, then it
becomes more natural to measure disk time for sequential (since in
order to keep the sequential pattern, you have to devote contiguous
disk time to each queue).
And for seeky workloads, data transferred is viable, since here you
don't have the contiguous time restriction.
Moreover, it is not affected by the amplitude of seek, that is mostly
dependent on how you schedule the requests from multiple queues, so it
cannot be imputed to the single queue. And it works also if you
schedule multiple requests in parallel with NCQ.

>
> time based fairness generally should work better on seeky media. As the
> seek cost starts to come down, size of IO also starts making sense.
>
> In fact on SSD, we do queue switching so fast and don't idle on the queue,
> doing time accounting and providing fairness in terms of time is hard, for
> the groups which are not continuously backlogged.
The mechanism in place still gives fairness in terms of I/Os for SSDs.
One queue is not even nearly backlogged, then there is no point in
enforcing fairness for it so that the backlogged one gets lower
bandwidth, but the not backlogged one doesn't get higher (since it is
limited by its think time).

For me fairness for SSDs should happen only when the total BW required
by all the queues is more than the one the disk can deliver, or the
total number of active queues is more than NCQ depth. Otherwise, each
queue will get exactly the bandwidth it wants, without affecting the
others, so no idling should happen. In the mentioned cases, instead,
no idling needs to be added, since the contention for resource will
already introduce delays.

>
>> Unfortunately, the two measures seems not comparable, so we seem
>> obliged to schedule independently the two kinds of workloads.
>> Actually, I think we can compute a feedback from each scheduling turn,
>> that can be used to temporary alter weights in next turn, in order to
>> reach long term fairness.
>
> As one simple solution, I thought that on SSDs, one can think of using
> higher level IO controlling policy instead of CFQ group scheduling.
>
> Or, we bring in some measuer in CFQ for fairness based on size/amount of
> IO.
It is already working at the I/O scheduler level, when the conditions
above are met, so if you build on top of CFQ, it should work for
groups as well.

Corrado
>
> Thanks
> Vivek
>
