Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbZHSPVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbZHSPVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZHSPVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:21:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48434 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbZHSPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:21:51 -0400
Date: Wed, 19 Aug 2009 16:21:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
Message-ID: <20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
In-Reply-To: <4A8C0820.8060200@gmail.com>
References: <20090819112554.GY12579@kernel.dk>
	<4A8BE932.5090300@garzik.org>
	<20090819120458.GZ12579@kernel.dk>
	<4A8BECC2.2060607@rtr.ca>
	<20090819122320.GA12579@kernel.dk>
	<4A8BFC79.1000004@garzik.org>
	<4A8BFDE2.1010904@garzik.org>
	<4A8C0820.8060200@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhat simpler for the general case would be to implement

create_workqueue(min_threads,max_threads, max_thread_idle_time);
queue_work_within();

at which point you can queue work to the workqueue but with a per
workqueue timing running so you know when you might need to create a new
thread if the current work hasn't finished. Idle threads would then sleep
and either expire or pick up new work - so that under load we don't keep
destructing threads.

That might need a single thread (for the system) that does nothing but
create workqueue threads to order. It could manage the "next workqueue
deadline" timer and thread creation. The threads would then pick up their
work queue work. There is an intrinsic race where if we are just on the
limit we might create a thread just as there is no work to be done - but
it would be rare and would just then go away.

I see no point tring to fix ata when applying sanity to the workqueue
logic would sort a lot of other cases out nicely.

