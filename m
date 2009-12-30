Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZL3Uuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZL3Uuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZL3Uug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:50:36 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:51653 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbZL3Uuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qphZ0xLvjtVYUgQ/I2r8KeSbYPvBaP9FVkTUQF9vKu6xkwo/TRitbPVMrhrq/ql2ES
         Dpp4tyQlBevO0XerM/WUjfgYZpOgP6AziNC2JHWIpYyv4H3EA2c/+tiuDiTzFLYIOIWb
         QLj1DvEnmVGIoVL1tKQNgm7Pka/ihlkCY+Z/k=
MIME-Version: 1.0
In-Reply-To: <20091230184748.GF4489@kernel.dk>
References: <1262185738-11942-1-git-send-email-czoccolo@gmail.com>
	 <20091230184748.GF4489@kernel.dk>
Date: Wed, 30 Dec 2009 21:50:34 +0100
Message-ID: <4e5e476b0912301250x4a0de523v8c1d0a03720c8fa8@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: replace sync_flight by rq_in_driver[BLK_RW_SYNC]
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 7:47 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Dec 30 2009, Corrado Zoccolo wrote:
>> According to my intuition (and brief testing), sync_flight is always
>> equal to rq_in_driver[BLK_RW_SYNC] at the point of usage, so it can
>> be removed and replaced by the other.
>
> They are not fully identical. ->sync_flight is incremented on insertion
> on the dispatch list, ->rq_in_driver not until the request is activated
> (eg the driver has retrieved it and wants to dispatch to the hardware).
Usually (only exceptions are forced dispatch, or when a conflict in the
rb tree is found), a request is activated as soon as cfq returns from
cfq_dispatch_requests.

> They will usually be identical, but that may not be true for requeues
> for instance.

For our purpose, it is sufficient that in cfq_may_dispatch, they are either
both 0 or both non-0.
Since we have sync_flight >= rq_in_driver[1], the only question is:
can the number of requests in the driver drop to 0 with requests still
in flight?

I'm asking because to drain async requests, we are using the rq_in_driver
counter instead. Maybe they need the same treatment.

Thanks
Corrado

>
> --
> Jens Axboe
>
>
