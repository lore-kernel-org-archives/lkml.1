Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZHXSQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZHXSQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZHXSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:15:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59635 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZHXSP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:15:59 -0400
Date: Mon, 24 Aug 2009 20:16:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 4/7] libata: use lazy workqueues for the pio task
Message-ID: <20090824181600.GR12579@kernel.dk>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com> <1251100616-28604-5-git-send-email-jens.axboe@oracle.com> <4A92C081.50207@garzik.org> <20090824164214.GO12579@kernel.dk> <4A92C500.4030109@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A92C500.4030109@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24 2009, Jeff Garzik wrote:
> On 08/24/2009 12:42 PM, Jens Axboe wrote:
>> On Mon, Aug 24 2009, Jeff Garzik wrote:
>>> No objections to the code, operationally...
>>>
>>> But it is disappointing that the "1 thread on UP" problem is not solved
>>> while changing this libata area.  Is there no way to specify a minimum
>>> lazy-thread count?
>>>
>>> A key problem continues to be tying to the number of CPUs, which is
>>> quite inappropriate for libata.
>>
>> We'll solve that next, the first problem is reducing the per-cpu
>> threads. Lots of places use per-cpu workqueues because that is what is
>> available, not necessarily because it's an appropriate choice. Like the
>> ata_wq above, it's not even a good fit.
>
> Agreed + sounds great.
>
> Thanks -- both for hacking libata for this, and more generally, for  
> attacking the too-many-kthreads problem!  :)  It's just sad how many  
> unused workqueue threads hang about, on every modern Linux box.

It is, it's one of those problems that's gotten totally out of hand. A
handful of wasted threads is easily ignored, but once you are safely
into the three digits it's just too much.

I took a quick look at converting libata to slow-work, and it's an easy
fit (and would solve the UP problem too). The remaining piece is a
slow_work_enqueue_delayed(), since we do use pio task queue with a small
delay from one path.

So I hope that we can get by with slow-work with a few tweaks here and
there, and just retain workqueues for the true performance (or
persistent) case. The lazy workqueues is still a nice addition I think,
since they don't hang around forever when things go idle.

-- 
Jens Axboe

