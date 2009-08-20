Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZHTMqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZHTMqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZHTMp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:45:59 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:33519 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZHTMp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q6LOrEnxynNCoYz16VogSIPzygRG+WH8fNARWcaTNArQqCuX0uuaR4X55XMoQtnSGj
         aoAGJi7C213qzVyNpO2qCP2GcUwJd0HTPxzPrhV5bMeMjiemPun1r6p/B8tCYt2bKoOd
         tqOedlG+RSWQRfsvBSR+ehjIkcCUGLd4FNCOQ=
Message-ID: <4A8D458B.6020208@gmail.com>
Date: Thu, 20 Aug 2009 21:46:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk>	<4A8BE932.5090300@garzik.org>	<20090819120458.GZ12579@kernel.dk>	<4A8BECC2.2060607@rtr.ca>	<20090819122320.GA12579@kernel.dk>	<4A8BFC79.1000004@garzik.org>	<4A8BFDE2.1010904@garzik.org>	<4A8C0820.8060200@gmail.com>	<20090819162147.16aeb2db@lxorguk.ukuu.org.uk>	<4A8C2012.6090809@gmail.com>	<20090819171510.68bef78f@lxorguk.ukuu.org.uk>	<4A8C2F27.5010104@gmail.com> <20090819182314.6fe6b081@lxorguk.ukuu.org.uk>
In-Reply-To: <20090819182314.6fe6b081@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
>> It's not about needing per-cpu binding but if works can be executed on
>> the same cpu they were issued, it's almost always beneficial.  The
>> only reason why we have single threaded workqueue now is to limit the
>> number of threads.
> 
> That would argue very strongly for putting all the logic in one place so
> everything shares queues.

Yes, it does.

>>> Only if you make the default assumed max wait time for the work too low -
>>> its a tunable behaviour in fact.
>> If the default workqueue is made to manage concurrency well, most
>> works should be able to just use it, so the queue will contain both
>> long running ones and short running ones which can disturb the current
>> batch like processing of the default workqueue which is assumed to
>> have only short ones.
> 
> Not sure why it matters - the short ones will instead end up being
> processed serially in parallel to the hog.

The problem is how to assign works to workers.  With long running
works, workqueue will definitely need some reserves in the worker
pool.  When short works are consecutively queued, without special
provision, they'll end up served by different workers increasing cache
foot print and execution overhead.  The special provision could be
something timer based but modding timer for each work is a bit
expensive.  I think it needs to be more mechanical rather than depend
on heuristics or timing.

>> kthreads).  It would be great if a single work API is exported and
>> concurrency is managed automatically so that no one else has to worry
>> about concurrency but achieving that requires much more intelligence
>> on the workqueue implementation as the basic concurrency policies
>> which used to be imposed by those segregations need to be handled
>> automatically.  Maybe it's better trade-off to leave those
>> segregations as-are and just add another workqueue type with dynamic
>> thread pool.
> 
> The more intelligence in the workqueue logic, the less in the drivers and
> the more it can be adjusted and adapt itself.

Yeap, sure.

> Consider things like power management which might argue for breaking
> the cpu affinity to avoid waking up a sleeping CPU in preference to
> jumping work between processors

Yeah, that's one thing to consider too but works being scheduled on a
particular cpu usually is the result of other activities going on the
cpu.  I don't think workqueue needs to be modified for that.  If other
things move, workqueue will automatically follow.

Thanks.

-- 
tejun
