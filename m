Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZLaKeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZLaKeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 05:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZLaKef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 05:34:35 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:55921 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZLaKee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 05:34:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RgLO/tQxAnTITirzcx17Wlio1jk7R9omXdTiWcOrBSqV6TErPe4NCjCFyHMpZsKaFB
         wrgyZChgX8xmM/Rn1xFuoNbvwnQZmoa6f6/UUVCepJTqvdm91yEUVsFKoR0cbBqfoGTs
         sEkkcOlK7dvckfWoujblpiyuy8n6tiE7XB6/0=
MIME-Version: 1.0
In-Reply-To: <1262250960.1819.68.camel@localhost>
References: <1262250960.1819.68.camel@localhost>
Date: Thu, 31 Dec 2009 11:34:32 +0100
Message-ID: <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanmin,
On Thu, Dec 31, 2009 at 10:16 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> Comparing with kernel 2.6.32, fio mmap randread 64k has more than 40% regression with
> 2.6.33-rc1.

Can you compare the performance also with 2.6.31?
I think I understand what causes your problem.
2.6.32, with default settings, handled even random readers as
sequential ones to provide fairness. This has benefits on single disks
and JBODs, but causes harm on raids.
For 2.6.33, we changed the way in which this is handled, restoring the
enable_idle = 0 for seeky queues as it was in 2.6.31:
@@ -2218,13 +2352,10 @@ cfq_update_idle_window(struct cfq_data *cfqd,
struct cfq_queue *cfqq,
       enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);

       if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-           (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
+           (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
               enable_idle = 0;
(compare with 2.6.31:
        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
            (cfqd->hw_tag && CIC_SEEKY(cic)))
                enable_idle = 0;
excluding the sample_valid check, it should be equivalent for you (I
assume you have NCQ disks))
and we provide fairness for them by servicing all seeky queues
together, and then idling before switching to other ones.

The mmap 64k randreader will have a large seek_mean, resulting in
being marked seeky, but will send 16 * 4k sequential requests one
after the other, so alternating between those seeky queues will cause
harm.

I'm working on a new way to compute seekiness of queues, that should
fix your issue, correctly identifying those queues as non-seeky (for
me, a queue should be considered seeky only if it submits more than 1
seeky requests for 8 sequential ones).

>
> The test scenario: 1 JBOD has 12 disks and every disk has 2 partitions. Create
> 8 1-GB files per partition and start 8 processes to do rand read on the 8 files
> per partitions. There are 8*24 processes totally. randread block size is 64K.
>
> We found the regression on 2 machines. One machine has 8GB memory and the other has
> 6GB.
>
> Bisect is very unstable. The related patches are many instead of just one.
>
>
> 1) commit 8e550632cccae34e265cb066691945515eaa7fb5
> Author: Corrado Zoccolo <czoccolo@gmail.com>
> Date:   Thu Nov 26 10:02:58 2009 +0100
>
>    cfq-iosched: fix corner cases in idling logic
>
>
> This patch introduces about less than 20% regression. I just reverted below section
> and this part regression disappear. It shows this regression is stable and not impacted
> by other patches.
>
> @@ -1253,9 +1254,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>                return;
>
>        /*
> -        * still requests with the driver, don't idle
> +        * still active requests from this queue, don't idle
>         */
> -       if (rq_in_driver(cfqd))
> +       if (cfqq->dispatched)
>                return;
>
This shouldn't affect you if all queues are marked as idle. Does just
your patch:
> -           (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
> -            && CFQQ_SEEKY(cfqq)))
> +           (!cfqd->cfq_latency && !cfq_cfqq_deep(cfqq) &&
> +               sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
fix most of the regression without touching arm_slice_timer?

I guess
> 5db5d64277bf390056b1a87d0bb288c8b8553f96.
will still introduce a 10% regression, but this is needed to improve
latency, and you can just disable low_latency to avoid it.

Thanks,
Corrado
