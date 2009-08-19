Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbZHSQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbZHSQ6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZHSQ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:58:19 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:42435 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZHSQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=m3GQd5sr0hml/xUEaa27EhpzN6NM35F5qdY9VsffSjg9VNld662SJ9gbKBcs43s5/g
         VAzx9iS34GBUr1Jg/2MUDVAfOpFDJAGfnPp+4bQXdIGvYuz+j4pnURhNezk9eQ1R4k43
         moE7ZSohSvD+o/tbxy7jKnj6pEyG+1eRuR6Oo=
Message-ID: <4A8C2F27.5010104@gmail.com>
Date: Thu, 20 Aug 2009 01:58:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk>	<4A8BE932.5090300@garzik.org>	<20090819120458.GZ12579@kernel.dk>	<4A8BECC2.2060607@rtr.ca>	<20090819122320.GA12579@kernel.dk>	<4A8BFC79.1000004@garzik.org>	<4A8BFDE2.1010904@garzik.org>	<4A8C0820.8060200@gmail.com>	<20090819162147.16aeb2db@lxorguk.ukuu.org.uk>	<4A8C2012.6090809@gmail.com> <20090819171510.68bef78f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090819171510.68bef78f@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Are work threads per workqueue?  Combined with per-cpu binding,
>> dynamic thread pool per workqueue can get quite messy.  All three
>> factors end up getting multiplied - ie. #cpus * pool_size which can be
>> enlarged by the same work hopping around * #workqueues.
> 
> Stop a moment. Exactly how many work queue users need per cpu binding
> wizardry ?

It's not about needing per-cpu binding but if works can be executed on
the same cpu they were issued, it's almost always beneficial.  The
only reason why we have single threaded workqueue now is to limit the
number of threads.

>> Another problem is that if we apply this to the existing default
>> workqueue which is used by many different supposed-to-be-short works
>> in essentially batch mode, we might end up enlarging cache footprint
>> by scheduling unnecessarily many threads, which, in tight situations,
>> might show up as small but noticeable performance regression.
> 
> Only if you make the default assumed max wait time for the work too low -
> its a tunable behaviour in fact.

If the default workqueue is made to manage concurrency well, most
works should be able to just use it, so the queue will contain both
long running ones and short running ones which can disturb the current
batch like processing of the default workqueue which is assumed to
have only short ones.

If we maintain separate workqueues for different purposes, a tuning
knob could be enough.  If we try to manage the whole thing in uniform
manner, a good tune might not exist.

I'm not sure either way yet.  One of the reasons the current situation
is messy is because there are too many segregations among different
thread pools (different workqueues, async thread pool, other private
kthreads).  It would be great if a single work API is exported and
concurrency is managed automatically so that no one else has to worry
about concurrency but achieving that requires much more intelligence
on the workqueue implementation as the basic concurrency policies
which used to be imposed by those segregations need to be handled
automatically.  Maybe it's better trade-off to leave those
segregations as-are and just add another workqueue type with dynamic
thread pool.

Thanks.

-- 
tejun
