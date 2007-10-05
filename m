Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXJEDhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXJEDhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 23:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXJEDg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 23:36:58 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48535 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755523AbXJEDg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 23:36:57 -0400
Message-ID: <391555416.09807@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 5 Oct 2007 11:36:52 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to
	indicate more io
Message-ID: <20071005033652.GA6448@mail.ustc.edu.cn>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn> <20071002214736.GJ995458@sgi.com> <20071003013439.GA6501@mail.ustc.edu.cn> <20071003024119.GL23367404@sgi.com> <20071004022133.GA6244@mail.ustc.edu.cn> <20071004050344.GF23367404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004050344.GF23367404@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 03:03:44PM +1000, David Chinner wrote:
> On Thu, Oct 04, 2007 at 10:21:33AM +0800, Fengguang Wu wrote:
> > On Wed, Oct 03, 2007 at 12:41:19PM +1000, David Chinner wrote:
> > > On Wed, Oct 03, 2007 at 09:34:39AM +0800, Fengguang Wu wrote:
> > > > On Wed, Oct 03, 2007 at 07:47:45AM +1000, David Chinner wrote:
> > > > > On Tue, Oct 02, 2007 at 04:41:48PM +0800, Fengguang Wu wrote:
> > > > > >  		wbc.pages_skipped = 0;
> > > > > > @@ -560,8 +561,9 @@ static void background_writeout(unsigned
> > > > > >  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> > > > > >  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > > > > >  			/* Wrote less than expected */
> > > > > > -			congestion_wait(WRITE, HZ/10);
> > > > > > -			if (!wbc.encountered_congestion)
> > > > > > +			if (wbc.encountered_congestion || wbc.more_io)
> > > > > > +				congestion_wait(WRITE, HZ/10);
> > > > > > +			else
> > > > > >  				break;
> > > > > >  		}
> > > > > 
> > > > > Why do you call congestion_wait() if there is more I/O to issue?  If
> > > > > we have a fast filesystem, this might cause the device queues to
> > > > > fill, then drain on congestion_wait(), then fill again, etc. i.e. we
> > > > > will have trouble keeping the queues full, right?
> > > > 
> > > > You mean slow writers and fast RAID? That would be exactly the case
> > > > these patches try to improve.
> > > 
> > > I mean any writers and a fast block device (raid or otherwise).
> > > 
> > > > This patchset makes kupdate/background writeback more responsible,
> > > > so that if (avg-write-speed < device-capabilities), the dirty data are
> > > > synced timely, and we don't have to go for balance_dirty_pages().
> > > 
> > > Sure, but I'm asking about the effect of the patches on the
> > > (avg-write-speed == device-capabilities) case. I agree that
> > > they are necessary for timely syncing of data but I'm trying
> > > to understand what effect they have on the normal write case
> > 
> > > (i.e. keeping the disk at full write throughput).
> > 
> > OK, I guess it is the focus of all your questions: Why should we sleep
> > in congestion_wait() and possibly hurt the write throughput? I'll try
> > to summary it:
> > 
> > - congestion_wait() is necessary
> > Besides device congestions, there may be other blockades we have to
> > wait on, e.g. temporary page locks, NFS/journal issues(I guess).
> 
> We skip locked pages in writeback, and if some filesystems have
> blocking issues that require non-blocking writeback waits for some
> I/O to complete before re-entering writeback, then perhaps they should be
> setting wbc->encountered_congestion to tell writeback to back off.

We have wbc->pages_skipped for that :-)

> The question I'm asking is that if more_io tells us we have more
> work to do, why do we have to sleep first if the block dev is
> able to take more I/O?

See below.

> > 
> > - congestion_wait() is called only when necessary
> > congestion_wait() will only be called we saw blockades:
> >         if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> >                 congestion_wait(WRITE, HZ/10);
> >         }
> > So in normal case, it may well write 128MB data without any waiting.
> 
> Sure, but wbc.more_io doesn't indicate a blockade - just that there
> is more work to do, right?
 
It's not wbc.more_io, but the context(wbc.pages_skipped > 0) indicates
a blockade:
        
if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {    /* all-written or blockade... */
        if (wbc.encountered_congestion || wbc.more_io) /* blockade! */
                congestion_wait(WRITE, HZ/10);
        else                                           /* all-written! */
                break;
}

We can also read the whole background_writeout() logic as

while (!done) {
        /* sync _all_ sync-able data */
        congestion_wait(100ms);
}

And an example run could be:

sync 1000MB, skipped 100MB
congestion_wait(100ms);
sync 100MB, skipped 10MB
congestion_wait(100ms);
sync 10MB, all done

Note that it's far from "wait 100ms for every 4MB" (which is merely
the worst possible case).

> > - congestion_wait() won't hurt write throughput
> > When not congested, congestion_wait() will be wake up on each write
> > completion.
> 
> What happens if the I/O we issued has already completed before we
> got back up to the congestion_wait() call? We'll spend 100ms
> sleeping when we shouldn't have and throughput goes down by 10% on
> every occurrence....

Ah, that was out of my imagination. Maybe we could do with

        if (wbc.more_io)
                congestion_wait(WRITE, 1);

It's at least 10 times better.

> if we've got more work to do, then we should do it without an
> arbitrary, non-deterministic delay being inserted. If the delay is
> needed to prevent he system from "going mad" (whatever tht means),
> then what's the explaination for the system "going mad"?

"going mad" means "busy waiting".

> > Note that MAX_WRITEBACK_PAGES=1024 and
> > /sys/block/sda/queue/max_sectors_kb=512(for me),
> > which means we are gave the chance to sync 4MB on every 512KB written,
> > which means we are able to submit write IOs 8 times faster than the
> > device capability. congestion_wait() is a magical timer :-)
> 
> So, with Jens Axboe's sglist chaining, that single I/O could now
> be up to 32MB on some hardware. IOWs, we push 1024 pages, and that
> could end up as a single I/O being issued to disk.
> 
> Your magic just broke. :/

Hmm, congestion_wait(WRITE, 1) could re-establish the balance ;-)
Which waits <10ms for HZ=100.
 
> > > > So for your question of queue depth, the answer is: the queue length
> > > > will not build up in the first place. 
> > > 
> > > Which queue are you talking about here? The block deivce queue?
> > 
> > Yes, the elevator's queues.
> 
> I think this is the wrong thing to be doing and is detrimental
> to I/o perfomrance because it wil reduce elevator efficiency.
> 
> The elevator can only work efficiently if we allow the queues to
> build up. The deeper the queue, the better the elevator can sort the
> I/o requests and keep the device at maximum efficiency.  If we don't
> push enough I/O into the queues the we miss opportunities to combine
> adjacent I/Os and reduce the seek load of writeback. Also, a shallow
> queue will run dry if we don't get back to it in time which is
> possible if we wait for I/o to complete before we go and flush
> more....

Sure, the queues should be filled as fast as possible.
How fast can we fill the queue? Let's measure it:

//generated by the patch below

[  871.430700] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 54289 global 29911 0 0 wc _M tw -12 sk 0
[  871.444718] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 53253 global 28857 0 0 wc _M tw -12 sk 0
[  871.458764] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 52217 global 27834 0 0 wc _M tw -12 sk 0
[  871.472797] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 51181 global 26780 0 0 wc _M tw -12 sk 0
[  871.486825] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 50145 global 25757 0 0 wc _M tw -12 sk 0
[  871.500857] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 49109 global 24734 0 0 wc _M tw -12 sk 0
[  871.514864] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 48073 global 23680 0 0 wc _M tw -12 sk 0
[  871.528889] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 47037 global 22657 0 0 wc _M tw -12 sk 0
[  871.542894] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 46001 global 21603 0 0 wc _M tw -12 sk 0
[  871.556927] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 44965 global 20580 0 0 wc _M tw -12 sk 0
[  871.570961] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 43929 global 19557 0 0 wc _M tw -12 sk 0
[  871.584992] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 42893 global 18503 0 0 wc _M tw -12 sk 0
[  871.599005] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 41857 global 17480 0 0 wc _M tw -12 sk 0
[  871.613027] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 40821 global 16426 0 0 wc _M tw -12 sk 0
[  871.628626] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 39785 global 15403 961 0 wc _M tw -12 sk 0
[  871.644439] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 38749 global 14380 1550 0 wc _M tw -12 sk 0
[  871.660267] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 37713 global 13326 2573 0 wc _M tw -12 sk 0
[  871.676236] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 36677 global 12303 3224 0 wc _M tw -12 sk 0
[  871.692021] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 35641 global 11280 4154 0 wc _M tw -12 sk 0
[  871.707824] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 34605 global 10226 4929 0 wc _M tw -12 sk 0
[  871.723638] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 33569 global 9203 5735 0 wc _M tw -12 sk 0
[  871.739708] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 32533 global 8149 6603 0 wc _M tw -12 sk 0
[  871.756407] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 31497 global 7126 7409 0 wc _M tw -12 sk 0
[  871.772165] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 30461 global 6103 8246 0 wc _M tw -12 sk 0
[  871.788035] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 29425 global 5049 9052 0 wc _M tw -12 sk 0
[  871.803896] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 28389 global 4026 9982 0 wc _M tw -12 sk 0
[  871.820427] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 27353 global 2972 10757 0 wc _M tw -12 sk 0
[  871.836728] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 26317 global 1949 11656 0 wc _M tw -12 sk 0
[  871.853286] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 25281 global 895 12431 0 wc _M tw -12 sk 0
[  871.868762] mm/page-writeback.c 668 wb_kupdate: pdflush(202) 24245 global 58 13051 0 wc __ tw 168 sk 0

It's an Intel Core 2 2.93GHz CPU and a SATA disk.
The trace shows that
- there's no congestion_wait() called in wb_kupdate()
- it takes wb_kupdate() ~15ms to sync every 4MB 

So I guess congestion_wait(WRITE, 1) will be more than enough.

However, wb_kupdate() is syncing the data a bit slow(4*1000/15=266MB/s),
could it be because of a lot of cond_resched()?


Fengguang
---
 mm/page-writeback.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- linux-2.6.23-rc8-mm2.orig/mm/page-writeback.c
+++ linux-2.6.23-rc8-mm2/mm/page-writeback.c
@@ -98,6 +98,26 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+#define writeback_debug_report(n, wbc) do {                               \
+	__writeback_debug_report(n, wbc, __FILE__, __LINE__, __FUNCTION__); \
+} while (0)
+
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func)
+{
+	printk("%s %d %s: %s(%d) %ld "
+			"global %lu %lu %lu "
+			"wc %c%c tw %ld sk %ld\n",
+			file, line, func,
+			current->comm, current->pid, n,
+			global_page_state(NR_FILE_DIRTY),
+			global_page_state(NR_WRITEBACK),
+			global_page_state(NR_UNSTABLE_NFS),
+			wbc->encountered_congestion ? 'C':'_',
+			wbc->more_io ? 'M':'_',
+			wbc->nr_to_write,
+			wbc->pages_skipped);
+}
 
 static void background_writeout(unsigned long _min_pages);
 
@@ -404,6 +424,7 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
 
 		/*
@@ -568,6 +589,7 @@ static void background_writeout(unsigned
 		wbc.pages_skipped = 0;
 		writeback_inodes(&wbc);
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		writeback_debug_report(min_pages, &wbc);
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
 			if (wbc.encountered_congestion)
@@ -643,6 +665,7 @@ static void wb_kupdate(unsigned long arg
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
+		writeback_debug_report(nr_to_write, &wbc);
 		if (wbc.nr_to_write > 0) {
 			if (wbc.encountered_congestion)
 				congestion_wait(WRITE, HZ/10);

