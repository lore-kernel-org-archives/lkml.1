Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZHSPyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZHSPyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZHSPyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:54:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:60556 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZHSPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AUW280VOl1Ls4NEjuNU+eLBz7fnfMQm6uHwuH9yX30vJCvKkza02Y1bwt6xcRqtu5H
         MT6anZQD4OZ3QJVCdG7UyV/dC1ccV2Xn1HGEqtVyRlpn46S6Fx+q54aw8IGiC6w9U6q2
         9haxj3ROTi1zTAetns641qed4zzEWgxhe891Q=
Message-ID: <4A8C2012.6090809@gmail.com>
Date: Thu, 20 Aug 2009 00:53:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk>	<4A8BE932.5090300@garzik.org>	<20090819120458.GZ12579@kernel.dk>	<4A8BECC2.2060607@rtr.ca>	<20090819122320.GA12579@kernel.dk>	<4A8BFC79.1000004@garzik.org>	<4A8BFDE2.1010904@garzik.org>	<4A8C0820.8060200@gmail.com> <20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
In-Reply-To: <20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
> Somewhat simpler for the general case would be to implement

Yeah, it would be great if there's a much simpler solution.  Latency
based one could be a good compromise.

> create_workqueue(min_threads,max_threads, max_thread_idle_time);
> queue_work_within();
> 
> at which point you can queue work to the workqueue but with a per
> workqueue timing running so you know when you might need to create a new
> thread if the current work hasn't finished. Idle threads would then sleep
> and either expire or pick up new work - so that under load we don't keep
> destructing threads.

Are work threads per workqueue?  Combined with per-cpu binding,
dynamic thread pool per workqueue can get quite messy.  All three
factors end up getting multiplied - ie. #cpus * pool_size which can be
enlarged by the same work hopping around * #workqueues.

> That might need a single thread (for the system) that does nothing but
> create workqueue threads to order. It could manage the "next workqueue
> deadline" timer and thread creation.

Another problem is that if we apply this to the existing default
workqueue which is used by many different supposed-to-be-short works
in essentially batch mode, we might end up enlarging cache footprint
by scheduling unnecessarily many threads, which, in tight situations,
might show up as small but noticeable performance regression.

> The threads would then pick up their work queue work. There is an
> intrinsic race where if we are just on the limit we might create a
> thread just as there is no work to be done - but it would be rare
> and would just then go away.

Agreed.  As long as the pool size is reduced gradually maybe with some
buffer, I don't think this would be an issue.

> I see no point tring to fix ata when applying sanity to the workqueue
> logic would sort a lot of other cases out nicely.

About the same problem exists for in-kernel media presence polling.
Currently, I'm thinking about creating a worker thread per any device
which requires polling.  It isn't too bad but it would still be far
better if I can just schedule a work and don't have to worry about
managing concurrency.

Thanks.

-- 
tejun
