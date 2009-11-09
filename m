Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZKIVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZKIVro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZKIVro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:47:44 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:56295 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbZKIVrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:47:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QhsQl2AwMvIURmgiTy1Gx9tOubnHN9RYCddAZiQm7xX/9/m+nXXz9R20oTb5at9mrR
         5BneUJWOAdIp7puer1hFXASkU+8t7Cfgnze7Uc3npGVY7paHiiV84OQ7jT0vmipEFKWR
         5HvGFCY363e0Ka92mY2no+jnlZZlkphz5k1+Q=
MIME-Version: 1.0
In-Reply-To: <20091106222257.GB2969@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091106222257.GB2969@redhat.com>
Date: Mon, 9 Nov 2009 22:47:48 +0100
Message-ID: <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 11:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi All,
>
> I am now rebasing my patches to for-2.6.33 branch. There are significant
> number of changes in that branch, especially changes from corrado bring
> in an interesting question.
>
> Currently corrado has introduced the functinality of kind of grouping the
> cfq queues based on workload type and gives the time slots to these sub
> groups (sync-idle, sync-noidle, async).
>
> I was thinking of placing groups on top of this model, so that we select
> the group first and then select the type of workload and then finally
> the queue to run.
>
> Corrodo came up with an interesting suggestion (in a private mail), that
> what if we implement workload type at top and divide the share among
> groups with-in workoad type.
>
> So one would first select the workload to run and then select group
> with-in workload and then cfq queue with-in group.
>
> The advantage of this approach are.
>
> - for sync-noidle group, we will not idle per group. We will idle only
>  only at root level. (Well if we don't idle on the group once it becomes
>  empty, we will not see fairness for group. So it will be fairness vs
>  throughput call).
>
> - It allows us to limit system wide share of workload type. So for
>  example, one can kind of fix system wide share of async queues.
>  Generally it might not be very prudent to allocate a group 50% of
>  disk share and then that group decides to just do async IO and sync
>  IO in rest of the groups suffer.
>
> Disadvantage
>
> - The definition of fairness becomes bit murkier. Now fairness will be
>  achieved for a group with-in the workload type. So if a group is doing
>  IO of type sync-idle as well as sync-noidle and other group is doing
>  IO of type only sync-noidle, then first group will get overall more
>  disk time even if both the groups have same weight.

The fairness definition was always debated (disk time vs data transferred).
I think that the two have both some reason to exist.
Namely, disk time is good for sync-idle workloads, like sequential readers,
while data transferred is good for sync-noidle workloads, like random readers.
Unfortunately, the two measures seems not comparable, so we seem
obliged to schedule independently the two kinds of workloads.
Actually, I think we can compute a feedback from each scheduling turn,
that can be used to temporary alter weights in next turn, in order to
reach long term fairness.

Thanks,
Corrado

>
> Looking for some feedback about which appraoch makes more sense before I
> write patches.
>
> Thanks
> Vivek
>
