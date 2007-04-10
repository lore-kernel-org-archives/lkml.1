Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXDJCbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXDJCbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966056AbXDJCbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:31:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778AbXDJCbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:31:18 -0400
Date: Mon, 9 Apr 2007 19:30:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-Id: <20070409193056.6b52c354.akpm@linux-foundation.org>
In-Reply-To: <20070410015912.GE1994@redhat.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<4616CBF0.7090606@garzik.org>
	<20070409172339.48d661d6.akpm@linux-foundation.org>
	<20070410015912.GE1994@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 21:59:12 -0400 Dave Jones <davej@redhat.com> wrote:

> On Mon, Apr 09, 2007 at 05:23:39PM -0700, Andrew Morton wrote:
> 
>  > I suspect there are quite a few kernel threads which don't really need to
>  > be threads at all: the code would quite happily work if it was changed to
>  > use keventd, via schedule_work() and friends.  But kernel threads are
>  > somewhat easier to code for.
> 
> Perhaps too easy.  We have a bunch of kthreads sitting around that afaict,
> are there 'just in case', not because they're actually in use.

This is fun.

>    10 ?        S<     0:00 [khelper]

That one's needed to parent the call_usermodehelper() apps.  I don't think
it does anything else.  We used to use keventd for this but that had some
problem whcih I forget.  (Who went and misnamed keventd to "events", too? 
Nobody calls it "events", and with good reason)

> Why doesn't this get spawned when it needs to?
> 
>   164 ?        S<     0:00 [cqueue/0]
>   165 ?        S<     0:00 [cqueue/1]
> 
> I'm not even sure wth these are.

Me either.

> ...
>

: root         3  0.0  0.0      0     0 ?        S    18:51   0:00 [watchdog/0]

That's the softlockup detector.  Confusingly named to look like a, err,
watchdog.  Could probably use keventd.

: root         5  0.0  0.0      0     0 ?        S    18:51   0:00 [khelper]

That's there to parent the kthread_create()d threads.  Could presumably use
khelper.

: root       152  0.0  0.0      0     0 ?        S    18:51   0:00 [ata/0]

Does it need to be per-cpu?

: root       153  0.0  0.0      0     0 ?        S    18:51   0:00 [ata_aux]

That's a single-threaded workqueue handler.  Perhaps could use keventd.

: root       299  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_0]
: root       300  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_1]
: root       305  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_2]
: root       306  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_3]

This machine has one CPU, one sata disk and one DVD drive.  The above is
hard to explain.

: root       319  0.0  0.0      0     0 ?        S    18:51   0:00 [pccardd]

hm.

: root       331  0.0  0.0      0     0 ?        S    18:51   0:00 [kpsmoused]

hm.

: root       337  0.0  0.0      0     0 ?        S    18:51   0:00 [kedac]

hm.  I didn't know that the Vaio had EDAC.

: root      1173  0.0  0.0      0     0 ?        S    18:51   0:00 [khpsbpkt]

I can't even pronounce that.

: root      1354  0.0  0.0      0     0 ?        S    18:51   0:00 [knodemgrd_0]

OK, I do have 1394 hardware, but it hasn't been used.

: root      1636  0.0  0.0      0     0 ?        S    18:52   0:00 [kondemand/0]

I blame davej.

>  > otoh, a lot of these inefficeincies are probably down in scruffy drivers
>  > rather than in core or top-level code.
> 
> You say scruffy, but most of the proliferation of kthreads comes
> from code written in the last few years.  Compare the explosion of kthreads
> we see coming from 2.4 to 2.6. It's disturbing, and I don't see it
> slowing down at all.
> 
> On the 2-way box I grabbed the above ps output from, I end up with 69 kthreads.
> It doesn't surprise me at all that bigger iron is starting to see issues.
> 

Sure.

I don't think it's completely silly to object to all this.  Sure, a kernel
thread is worth 4k in the best case, but I bet they have associated unused
resources and as we've seen, they can cause overhead.

