Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXDJHGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXDJHGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030457AbXDJHGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:06:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33236 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030456AbXDJHGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:06:45 -0400
Message-ID: <461B3754.9040107@garzik.org>
Date: Tue, 10 Apr 2007 03:05:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>	<4616CBF0.7090606@garzik.org>	<20070409172339.48d661d6.akpm@linux-foundation.org>	<20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org>
In-Reply-To: <20070409193056.6b52c354.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> : root         3  0.0  0.0      0     0 ?        S    18:51   0:00 [watchdog/0]
> 
> That's the softlockup detector.  Confusingly named to look like a, err,
> watchdog.  Could probably use keventd.

I would think this would run into the keventd "problem", where $N 
processes can lock out another?

IMO a lot of these could potentially be simply started as brand new 
threads, when an exception arises.


> : root         5  0.0  0.0      0     0 ?        S    18:51   0:00 [khelper]
> 
> That's there to parent the kthread_create()d threads.  Could presumably use
> khelper.
> 
> : root       152  0.0  0.0      0     0 ?        S    18:51   0:00 [ata/0]
> 
> Does it need to be per-cpu?

No, it does not.

It is used for PIO data transfer, so it merely has to respond quickly, 
which rules out keventd.  You also don't want PIO data xfer for port A 
blocked, sitting around waiting for PIO data xfer to complete on port C.

So, we merely need fast-reacting threads that keventd will not block. 
We do not need per-CPU threads.

Again, I think a model where threads are created on demand, and reaped 
after inactivity, would fit here.  As I feel it would fit with many 
other non-libata drivers.


> : root       153  0.0  0.0      0     0 ?        S    18:51   0:00 [ata_aux]
> 
> That's a single-threaded workqueue handler.  Perhaps could use keventd.

That is used by libata exception handler, for hotpug and such.  My main 
worry with keventd is that we might get stuck behind an unrelated 
process for an undefined length of time.

IMO the best model would be to create ata_aux thread on demand, and kill 
it if it hasn't been used recently.



> : root       299  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_0]
> : root       300  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_1]
> : root       305  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_2]
> : root       306  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_3]
> 
> This machine has one CPU, one sata disk and one DVD drive.  The above is
> hard to explain.

Nod.  I've never thought we needed this many threads.  At least it 
doesn't scale out of control for $BigNum-CPU boxen.

As the name implies, this is SCSI exception handling thread.  Although 
some synchronization is required, this could probably work with an 
on-demand thread creation model too.


> : root       319  0.0  0.0      0     0 ?        S    18:51   0:00 [pccardd]
> 
> hm.
> 
> : root       331  0.0  0.0      0     0 ?        S    18:51   0:00 [kpsmoused]
> 
> hm.

This kernel thread is used as a "bottom half" handler for the PS2 mouse 
interrupt.  This one is a bit more justifiable.


> : root       337  0.0  0.0      0     0 ?        S    18:51   0:00 [kedac]
> 
> hm.  I didn't know that the Vaio had EDAC.
> 
> : root      1173  0.0  0.0      0     0 ?        S    18:51   0:00 [khpsbpkt]
> 
> I can't even pronounce that.
> 
> : root      1354  0.0  0.0      0     0 ?        S    18:51   0:00 [knodemgrd_0]
> 
> OK, I do have 1394 hardware, but it hasn't been used.
> 
> : root      1636  0.0  0.0      0     0 ?        S    18:52   0:00 [kondemand/0]
> 
> I blame davej.
> 
>>  > otoh, a lot of these inefficeincies are probably down in scruffy drivers
>>  > rather than in core or top-level code.
>>
>> You say scruffy, but most of the proliferation of kthreads comes
>> from code written in the last few years.  Compare the explosion of kthreads
>> we see coming from 2.4 to 2.6. It's disturbing, and I don't see it
>> slowing down at all.
>>
>> On the 2-way box I grabbed the above ps output from, I end up with 69 kthreads.
>> It doesn't surprise me at all that bigger iron is starting to see issues.
>>
> 
> Sure.
> 
> I don't think it's completely silly to object to all this.  Sure, a kernel
> thread is worth 4k in the best case, but I bet they have associated unused
> resources and as we've seen, they can cause overhead.

Agreed.

	Jeff


