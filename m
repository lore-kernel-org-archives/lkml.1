Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZHSRXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZHSRXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZHSRXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:23:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52752 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbZHSRXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:23:12 -0400
Date: Wed, 19 Aug 2009 18:23:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
Message-ID: <20090819182314.6fe6b081@lxorguk.ukuu.org.uk>
In-Reply-To: <4A8C2F27.5010104@gmail.com>
References: <20090819112554.GY12579@kernel.dk>
	<4A8BE932.5090300@garzik.org>
	<20090819120458.GZ12579@kernel.dk>
	<4A8BECC2.2060607@rtr.ca>
	<20090819122320.GA12579@kernel.dk>
	<4A8BFC79.1000004@garzik.org>
	<4A8BFDE2.1010904@garzik.org>
	<4A8C0820.8060200@gmail.com>
	<20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
	<4A8C2012.6090809@gmail.com>
	<20090819171510.68bef78f@lxorguk.ukuu.org.uk>
	<4A8C2F27.5010104@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not about needing per-cpu binding but if works can be executed on
> the same cpu they were issued, it's almost always beneficial.  The
> only reason why we have single threaded workqueue now is to limit the
> number of threads.

That would argue very strongly for putting all the logic in one place so
everything shares queues.

> > Only if you make the default assumed max wait time for the work too low -
> > its a tunable behaviour in fact.
> 
> If the default workqueue is made to manage concurrency well, most
> works should be able to just use it, so the queue will contain both
> long running ones and short running ones which can disturb the current
> batch like processing of the default workqueue which is assumed to
> have only short ones.

Not sure why it matters - the short ones will instead end up being
processed serially in parallel to the hog.

> kthreads).  It would be great if a single work API is exported and
> concurrency is managed automatically so that no one else has to worry
> about concurrency but achieving that requires much more intelligence
> on the workqueue implementation as the basic concurrency policies
> which used to be imposed by those segregations need to be handled
> automatically.  Maybe it's better trade-off to leave those
> segregations as-are and just add another workqueue type with dynamic
> thread pool.

The more intelligence in the workqueue logic, the less in the drivers and
the more it can be adjusted and adapt itself. Consider things like power
management which might argue for breaking the cpu affinity to avoid
waking up a sleeping CPU in preference to jumping work between processors

