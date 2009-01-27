Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZA0Aaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZA0Aaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZA0AaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:30:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:44356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbZA0AaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:30:19 -0500
Date: Mon, 26 Jan 2009 16:30:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090126163015.7f879b18@infradead.org>
In-Reply-To: <20090127001708.GA4815@nowhere>
References: <20090127001708.GA4815@nowhere>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 01:17:11 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> While looking at the statistics from the workqueue tracer, I've been
> suprised by the number of useless workqueues I had:
> 
>  CPU  INSERTED  EXECUTED   NAME
>  |      |         |          |
> 
>   *      0          0       kpsmoused
>   *      0          0       ata_aux
>   *      0          0       cqueue
>   *      0          0       kacpi_notify
>   *      0          0       kacpid
>   *    998        998       khelper
>   *      0          0       cpuset
> 
>   1      0          0       hda0/1
>   1     42         42       reiserfs/1
>   1      0          0       scsi_tgtd/1
>   1      0          0       aio/1
>   1      0          0       ata/1
>   1    193        193       kblockd/1
>   1      0          0       kintegrityd/1
>   1      4          4       work_on_cpu/1
>   1   1244       1244       events/1
> 
>   0      0          0       hda0/0
>   0     63         63       reiserfs/0
>   0      0          0       scsi_tgtd/0
>   0      0          0       aio/0
>   0      0          0       ata/0
>   0    188        188       kblockd/0
>   0      0          0       kintegrityd/0
>   0     16         16       work_on_cpu/0
>   0   1360       1360       events/0
> 
> 
> All of the workqueues with 0 work inserted do nothing. 
> For several reasons:
> 
> _ Unneeded built drivers for my system that create workqueue(s) when
> they init _ Services which need their own workqueue, for several
> reasons, but who receive very rare jobs (often never)
> _ ...?
> 
> And the result of git-grep create_singlethread_workqueue is even more
> surprising.
> 
> So I've started a patch which creates the workqueues by default
> without thread except the kevents one.
> They will have their thread created and started only when these
> workqueues will receive a first work to do. This is performed by
> submitting a task's creation work to the kevent workqueues which are
> always there, and are the only one which have their thread started on
> creation.
> 
> The result after this patch:
> 
> # CPU  INSERTED  EXECUTED   NAME
> # |      |         |          |
> 
>   *    999       1000       khelper
> 
>   1      5          6       reiserfs/1
>   1      0          2       work_on_cpu/1
>   1     86         87       kblockd/1
>   1     14         16       work_on_cpu/1
>   1    149        149       events/1
> 
>   0     15         16       reiserfs/0
>   0     85         86       kblockd/0
>   0    146        146       events/0
> 
> 
> Dropping 16 useless kernel threads in my system.
> (Yes the inserted values are not synced with the executed one because
> the tracers looses the first events. I just rewrote some parts to
> make it work with this patch) .
> I guess I will update this tracer to display the "shadow workqueues"
> which have no threads too.
> 
> I hadn't any problems until now with this patch but I think it needs
> more testing, like with cpu hotplug, and some renaming for its
> functions and structures... And I would like to receive some comments
> and feelings before continuing. So this is just an RFC :-)
> 

one thing to look at for work queues that never get work is to see if
they are appropriate for the async function call interface
(the only requirement for that is that they need to cope with calling
inline in exceptional cases)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
