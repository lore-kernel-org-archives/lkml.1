Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZAaSEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZAaSEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZAaSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:03:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:45584 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZAaSDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kHOjWyIit9eoSgSFDA1MlaecEW6ZTEB+3EMyFBcmQL678Nn3xf9/qsgQ+V+mHUBXKv
         SVW4hniFvMh/amxrYOWOLygvdlA/x7bHo7NcxB0Zq0e2D4c9bxqhlLMQRU2idDD3Wf84
         9Vw6GvtSxMv1RMRJTn7jZgsa1H4ak7uGfpawo=
Date: Sat, 31 Jan 2009 19:03:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090131180347.GC5884@nowhere>
References: <20090127001708.GA4815@nowhere> <20090126163015.7f879b18@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126163015.7f879b18@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 04:30:15PM -0800, Arjan van de Ven wrote:
> On Tue, 27 Jan 2009 01:17:11 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > While looking at the statistics from the workqueue tracer, I've been
> > suprised by the number of useless workqueues I had:
> > 
> >  CPU  INSERTED  EXECUTED   NAME
> >  |      |         |          |
> > 
> >   *      0          0       kpsmoused
> >   *      0          0       ata_aux
> >   *      0          0       cqueue
> >   *      0          0       kacpi_notify
> >   *      0          0       kacpid
> >   *    998        998       khelper
> >   *      0          0       cpuset
> > 
> >   1      0          0       hda0/1
> >   1     42         42       reiserfs/1
> >   1      0          0       scsi_tgtd/1
> >   1      0          0       aio/1
> >   1      0          0       ata/1
> >   1    193        193       kblockd/1
> >   1      0          0       kintegrityd/1
> >   1      4          4       work_on_cpu/1
> >   1   1244       1244       events/1
> > 
> >   0      0          0       hda0/0
> >   0     63         63       reiserfs/0
> >   0      0          0       scsi_tgtd/0
> >   0      0          0       aio/0
> >   0      0          0       ata/0
> >   0    188        188       kblockd/0
> >   0      0          0       kintegrityd/0
> >   0     16         16       work_on_cpu/0
> >   0   1360       1360       events/0
> > 
> > 
> > All of the workqueues with 0 work inserted do nothing. 
> > For several reasons:
> > 
> > _ Unneeded built drivers for my system that create workqueue(s) when
> > they init _ Services which need their own workqueue, for several
> > reasons, but who receive very rare jobs (often never)
> > _ ...?
> > 
> > And the result of git-grep create_singlethread_workqueue is even more
> > surprising.
> > 
> > So I've started a patch which creates the workqueues by default
> > without thread except the kevents one.
> > They will have their thread created and started only when these
> > workqueues will receive a first work to do. This is performed by
> > submitting a task's creation work to the kevent workqueues which are
> > always there, and are the only one which have their thread started on
> > creation.
> > 
> > The result after this patch:
> > 
> > # CPU  INSERTED  EXECUTED   NAME
> > # |      |         |          |
> > 
> >   *    999       1000       khelper
> > 
> >   1      5          6       reiserfs/1
> >   1      0          2       work_on_cpu/1
> >   1     86         87       kblockd/1
> >   1     14         16       work_on_cpu/1
> >   1    149        149       events/1
> > 
> >   0     15         16       reiserfs/0
> >   0     85         86       kblockd/0
> >   0    146        146       events/0
> > 
> > 
> > Dropping 16 useless kernel threads in my system.
> > (Yes the inserted values are not synced with the executed one because
> > the tracers looses the first events. I just rewrote some parts to
> > make it work with this patch) .
> > I guess I will update this tracer to display the "shadow workqueues"
> > which have no threads too.
> > 
> > I hadn't any problems until now with this patch but I think it needs
> > more testing, like with cpu hotplug, and some renaming for its
> > functions and structures... And I would like to receive some comments
> > and feelings before continuing. So this is just an RFC :-)
> > 
> 
> one thing to look at for work queues that never get work is to see if
> they are appropriate for the async function call interface
> (the only requirement for that is that they need to cope with calling
> inline in exceptional cases)
> 


Hi Arjan,

There is one thing that make it hard to replace workqueues in such cases,
there is not guarantee the function will run in user context because of this
condition:

if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK)

I wanted to replace kpsmoused with an async function but I want to schedule
a slow work that can't be done from irq...

