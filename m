Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbZL1JCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbZL1JCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZL1JCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:02:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63138 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZL1JCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IPVpzYbvLDxf7yUUQgmqf+mPk/AaxqVcLcGFg7cQq5pC2VhHeAyWGQaEB0E6nLE20d
         9QWxUxa/4Uj0dgzlf5vmaHhHwNJyAEAl1rrVzNXpBfKuASC7RLyUmbwrSxYyOibWDOBS
         ozdNxLszMgE87qsc0O0F+x349l9osAC1v1oow=
MIME-Version: 1.0
In-Reply-To: <20091228033554.GB15242@sli10-desk.sh.intel.com>
References: <20091225091030.GA28365@sli10-desk.sh.intel.com>
	 <4e5e476b0912250144l96c4d34v300910216e5c7a08@mail.gmail.com>
	 <20091228033554.GB15242@sli10-desk.sh.intel.com>
Date: Mon, 28 Dec 2009 10:02:06 +0100
Message-ID: <4e5e476b0912280102t2278d7a5ld3e8784f52f2be31@mail.gmail.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,
On Mon, Dec 28, 2009 at 4:35 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Fri, Dec 25, 2009 at 05:44:40PM +0800, Corrado Zoccolo wrote:
>> On Fri, Dec 25, 2009 at 10:10 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > Currently a queue can only dispatch up to 4 requests if there are other queues.
>> > This isn't optimal, device can handle more requests, for example, AHCI can
>> > handle 31 requests. I can understand the limit is for fairness, but we could
>> > do some tweaks:
>> > 1. if the queue still has a lot of slice left, sounds we could ignore the limit
>> ok. You can even scale the limit proportionally to the remaining slice
>> (see below).
> I can't understand the meaning of below scale. cfq_slice_used_soon() means
> dispatched requests can finish before slice is used, so other queues will not be
> impacted. I thought/hope a cfq_slice_idle time is enough to finish the
> dispatched requests.
cfq_slice_idle is 8ms, that is the average time to complete 1 request
on most disks. If you have more requests dispatched on a
NCQ-rotational disk (non-RAID), it will take more time. Probably a
linear formula is not the most accurate, but still more accurate than
taking just 1 cfq_slice_idle. If you can experiment a bit, you could
also try:
 cfq_slice_idle * ilog2(nr_dispatched+1)
 cfq_slice_idle * (1<<(ilog2(nr_dispatched+1)>>1))

>
>> > 2. we could keep the check only when cfq_latency is on. For uses who don't care
>> > about latency should be happy to have device fully piped on.
>> I wouldn't overload low_latency with this meaning. You can obtain the
>> same by setting the quantum to 32.
> As this impact fairness, so natually thought we could use low_latency. I'll remove
> the check in next post.
Great.
>> > I have a test of random direct io of two threads, each has 32 requests one time
>> > without patch: 78m/s
>> > with tweak 1: 138m/s
>> > with two tweaks and disable latency: 156m/s
>>
>> Please, test also with competing seq/random(depth1)/async workloads,
>> and measure also introduced latencies.
> depth1 should be ok, as if device can only send one request, it should not require
> more requests from ioscheduler.
I mean have a run with, at the same time:
* one seq reader,
* h random readers with depth 1 (non-aio)
* one async seq writer
* k random readers with large depth.
In this way, you can see if the changes you introduce to boost your
workload affect more realistic scenarios, in which various workloads
are mixed.
I explicitly add the depth1 random readers, since they are sceduled
differently than the large (>4) depth ones.

> I'll do more checks. The time is hard to choose (I choose cfq_slice-idle here) to
> balance thoughput and latency. Do we have creteria to measure this? See the patch
> passes some tests, so it's ok for latency.

Max latency should be near 300ms (compare with and without the patch),
for a reasonable number of concurrent processes (300ms/#proc <
2*idle_slice).

Thanks,
Corrado

>
> Thanks,
> Shaohua
>
