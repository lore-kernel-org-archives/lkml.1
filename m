Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZJBKzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZJBKzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZJBKzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:55:23 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37184 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582AbZJBKzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:from:date:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=pDWn45J+tEhTu8iY0vIRyJMALn4vinAE/2guvUL9ytnJzol0jXTsPchE6KKDk3UgE1
         IoFH93mPNsyKLIlCxU0/KQ4vG7LNWClyazjGh/nzHsyynR4J40QDAdsujZNIa1ApoqLK
         Tt5RxtOgzILioIkYiviTdQmpSU06fbhJeAKPI=
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
From: Corrado Zoccolo <czoccolo@gmail.com>
Date: Fri, 2 Oct 2009 12:55:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910021255.27689.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
On Fri, Oct 2, 2009 at 11:28 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Oct 02 2009, Ingo Molnar wrote:
>>
>> * Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>
> It's really not that simple, if we go and do easy latency bits, then
> throughput drops 30% or more. You can't say it's black and white latency
> vs throughput issue, that's just not how the real world works. The
> server folks would be most unpleased.
Could we be more selective when the latency optimization is introduced?

The code that is currently touched by Vivek's patch is:
        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
            (cfqd->hw_tag && CIC_SEEKY(cic)))
                enable_idle = 0;
basically, when fairness=1, it becomes just:
        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle)
                enable_idle = 0;

Note that, even if we enable idling here, the cfq_arm_slice_timer will use
a different idle window for seeky (2ms) than for normal I/O.

I think that the 2ms idle window is good for a single rotational SATA disk scenario,
even if it supports NCQ. Realistic access times for those disks are still around 8ms
(but it is proportional to seek lenght), and waiting 2ms to see if we get a nearby
request may pay off, not only in latency and fairness, but also in throughput.

What we don't want to do is to enable idling for NCQ enabled SSDs
(and this is already taken care in cfq_arm_slice_timer) or for hardware RAIDs.
If we agree that hardware RAIDs should be marked as non-rotational, then that
code could become:

        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
            (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag && CIC_SEEKY(cic)))
                enable_idle = 0;
        else if (sample_valid(cic->ttime_samples)) {
		unsigned idle_time = CIC_SEEKY(cic) ? CFQ_MIN_TT : cfqd->cfq_slice_idle;
		if (cic->ttime_mean > idle_time)
                        enable_idle = 0;
                else
                        enable_idle = 1;
        }

Thanks,
Corrado

>
> --
> Jens Axboe
>

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

