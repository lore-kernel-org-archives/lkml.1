Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZK3Ve2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZK3Ve2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZK3Ve1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:34:27 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65338 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZK3Ve0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lylb54d3iY3eMdph72JCxW6I1bAJWA9SEiPDqLkV+lmxWL59xcDopNlR79U0rkm1Wd
         1y6JaKnLcGPeob1o1/dzDjwtPUKg903kWSVoCwQCusvrhul0PoFPUJIXOpKd9MWIAxcx
         vwDb/OOXbKfFZzx/+ZkocDYxd6I0xENTwCxyM=
MIME-Version: 1.0
In-Reply-To: <20091130160024.GD11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com>
	 <20091130160024.GD11670@redhat.com>
Date: Mon, 30 Nov 2009 22:34:32 +0100
Message-ID: <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com>
Subject: Re: Block IO Controller V4
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Nov 30, 2009 at 04:34:36PM +0100, Corrado Zoccolo wrote:
>> Hi Vivek,
>> On Mon, Nov 30, 2009 at 3:59 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi Jens,
>> > [snip]
>> > TODO
>> > ====
>> > - Direct random writers seem to be very fickle in terms of workload
>> >  classification. They seem to be switching between sync-idle and sync-noidle
>> >  workload type in a little unpredictable manner. Debug and fix it.
>> >
>>
>> Are you still experiencing erratic behaviour after my patches were
>> integrated in for-2.6.33?
>
> Your patches helped with deep seeky queues. But if I am running a random
> writer with default iodepth of 1 (without libaio), I still see that idle
> 0/1 flipping happens so frequently during 30 seconds duration of
> execution.
Ok. This is probably because the average seek goes below the threshold.
You can try a larger file, or reducing the threshold.
>
> As per CFQ classification definition, a seeky random writer with shallow
> depth should be classified as sync-noidle and stay there until and unless
> workload changes its nature. But that does not seem to be happening.
>
> Just try two fio random writers and monitor the blktrace and see how
> freqently we enable and disable idle on the queues.
>
>>
>> > - Support async IO control (buffered writes).
>> I was thinking about this.
>> Currently, writeback can either be issued by a kernel daemon (when
>> actual dirty ratio is > background dirty ratio, but < dirty_ratio) or
>> from various processes, if the actual dirty ratio is > dirty ratio.
>
> - If dirty_ratio > background_dirty_ratio, then a process will be
>  throttled and it can do one of the following actions.
>
>        - Pick one inode and start flushing its dirty pages. Now these
>          pages could have been dirtied by another process in another
>          group.
>
>        - It might just wait for flusher threads to flush some pages and
>          sleep for that duration.
>
>> Could the writeback issued in the context of a process be marked as sync?
>> In this way:
>> * normal writeback when system is not under pressure will run in the
>> root group, without interferring with sync workload
>> * the writeback issued when we have high dirty ratio will have more
>> priority, so the system will return in a normal condition quicker.
>
> Marking async IO submitted in the context of processes and not kernel
> threads is interesting. We could try that, but in general the processes
> that are being throttled are doing buffered writes and generally these
> are not very latency sensitive.
If we have too much dirty memory, then allocations could depend on freeing
some pages, so this would become latency sensitive. In fact, it seems that
the 2.6.32 low_latency patch is hurting some workloads in low memory scenarios.
2.6.33 provides improvements for async writes, but if writeback could
become sync
when dirty ratio is too high, we could have a better response to such
extreme scenarios.

>
> Group stuff apart, I would rather think of providing consistent share to
> async workload. So that when there is lots of sync as well async IO is
> going on in the system, nobody starves and we provide access to disk in
> a deterministic manner.
>
> That's why I do like the idea of fixing a workload share of async
> workload so that async workload does not starve in the face of lot of sync
> IO going on. Not sure how effectively it is working though.
I described how the current patch work in an other mail.

Thanks
Corrado
