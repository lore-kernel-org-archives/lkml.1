Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZKEIgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZKEIgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZKEIgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:36:24 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55018 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZKEIgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tX6EN8Pz8EHy8EEane/qPJzQjmNwPA9/0zy9NvdjL3ZLGi9APuxzCW1Xcv2PBioNiv
         F5NuPpcehKzOhfNaDVCiV9tnXqMtKAS3gZ0Qi7/C3JM1yOO8m2xuOVonb+qhBeatB6lp
         9her/bBeKcF9zlb0YaBaysxoltVMXZzfDa5Rs=
MIME-Version: 1.0
In-Reply-To: <20091104222529.GO2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091104222529.GO2870@redhat.com>
Date: Thu, 5 Nov 2009 09:36:28 +0100
Message-ID: <4e5e476b0911050036x3f9d47e7h965ee2416daae0f@mail.gmail.com>
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Wed, Nov 4, 2009 at 11:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Thanks. I am looking at your patches right now. Got one question about
> following commit.
>
> ****************************************************************
> commit a6d44e982d3734583b3b4e1d36921af8cfd61fc0
> Author: Corrado Zoccolo <czoccolo@gmail.com>
> Date:   Mon Oct 26 22:45:11 2009 +0100
>
>    cfq-iosched: enable idling for last queue on priority class
>
>    cfq can disable idling for queues in various circumstances.
>    When workloads of different priorities are competing, if the higher
>    priority queue has idling disabled, lower priority queues may steal
>    its disk share. For example, in a scenario with an RT process
>    performing seeky reads vs a BE process performing sequential reads,
>    on an NCQ enabled hardware, with low_latency unset,
>    the RT process will dispatch only the few pending requests every full
>    slice of service for the BE process.
>
>    The patch solves this issue by always performing idle on the last
>    queue at a given priority class > idle. If the same process, or one
>    that can pre-empt it (so at the same priority or higher), submits a
>    new request within the idle window, the lower priority queue won't
>    dispatch, saving the disk bandwidth for higher priority ones.
>
>    Note: this doesn't touch the non_rotational + NCQ case (no hardware
>    to test if this is a benefit in that case).
> *************************************************************************
>
[snipping questions I answered in the combo mail]
> On top of that, even if we don't idle for RT reader, we will always
> preempt BE reader immediately and get the disk. The only side affect
> is that on rotational media, disk head might have moved and bring the
> overall throughput down.
You bring down throughput, and also increase latency,  not only on
rotational media, so you may not want to enable it on servers.
Without low_latency, I saw this bug in current 'fairness' policy in
CFQ, so this patch fixes it.
>
> So my concern is that with this idling on last queue, we are targetting
> fairness issue for the random seeky readers with thinktime with-in 8ms.
> That can be easily solved by setting low_latency=1. Why are we going
> to this lenth then?
Maybe on the servers where you want to run RT tasks you don't want the
aforementioned drawbacks of low_latency.
Since I was going to change the implications of low_latency in
following patches, I fixed the 'bug' here, so I was free to change the
implementation in the following, without reintroducing this bug (it
was present for long, before being fixed by the introduction of
low_latency).

Thanks
Corrado
>
> Thanks
> Vivek
>
