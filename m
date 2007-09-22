Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbXIVBz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbXIVBz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 21:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXIVBzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 21:55:19 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44254 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755621AbXIVBzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 21:55:15 -0400
Message-ID: <390426111.11400@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 22 Sep 2007 09:55:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070922015509.GA5332@mail.ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919164348.GC2519@shadowen.org> <Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com> <20070919224409.24baa75b@lappy> <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 12:31:39PM +0100, Hugh Dickins wrote:
> On Wed, 19 Sep 2007, Peter Zijlstra wrote:
> > On Wed, 19 Sep 2007 21:03:19 +0100 (BST) Hugh Dickins
> > <hugh@veritas.com> wrote:
> > 
> > > On Wed, 19 Sep 2007, Andy Whitcroft wrote:
> > > > Seems I have a case of a largish i386 NUMA (NUMA-Q) which has a mkfs
> > > > stuck in a 'D' wait:
> > > > 
> > > >  =======================
> > > > mkfs.ext2     D c10220f4     0  6233   6222
> > > >  [<c12194da>] io_schedule_timeout+0x1e/0x28
> > > >  [<c10454b4>] congestion_wait+0x62/0x7a
> > > >  [<c10402af>] get_dirty_limits+0x16a/0x172
> > > >  [<c104040b>] balance_dirty_pages+0x154/0x1be
> > > >  [<c103bda3>] generic_perform_write+0x168/0x18a
> > > >  [<c103be38>] generic_file_buffered_write+0x73/0x107
> > > >  [<c103c346>] __generic_file_aio_write_nolock+0x47a/0x4a5
> > > >  [<c103c3b9>] generic_file_aio_write_nolock+0x48/0x9b
> > > >  [<c105d2d6>] do_sync_write+0xbf/0xfc
> > > >  [<c105d3a0>] vfs_write+0x8d/0x108
> > > >  [<c105d4c3>] sys_write+0x41/0x67
> > > >  [<c100260a>] syscall_call+0x7/0xb
> > > >  =======================
> > > 
> > > [edited out some bogus lines from stale stack]
> > > 
> > > > This machine and others have run numerous test runs on this kernel and
> > > > this is the first time I've see a hang like this.
> > > 
> > > I've been seeing something like that on 4-way PPC64: in my case I've
> > > shells hanging in D state trying to append to kernel build log on ext3
> > > (the builds themselves going on elsewhere, in tmpfs): one of the shells
> > > holding i_mutex and stuck doing congestion_waits from balance_dirty_pages.
> > > 
> > > > I wonder if this is the ultimate cause of the couple of mainline hangs
> > > > which were seen, but not diagnosed.
> > > 
> > > My *guess* is that this is peculiar to 2.6.23-rc6-mm1, and from Peter's
> > > mm-per-device-dirty-threshold.patch.  printks showed bdi_nr_reclaimable
> > > 0, bdi_nr_writeback 24, bdi_thresh 1 in balance_dirty_pages (though I've
> > > not done enough to check if those really correlate with the hangs),
> > > and I'm wondering if the bdi_stat_sum business is needed on the
> > > !nr_reclaimable path.
> > 
> > FWIW my tired brain seems to think it the !nr_reclaimable path needs it
> > just the same. So this change seems to make sense for now :-)
> 
> Thanks.
> 
> > > So I'm running now with the patch below, good so far, but can't judge
> > > until tomorrow whether it has actually addressed the problem seen.
> 
> Last night's run went well: that patch does indeed seem to have fixed it.
> Looking at the timings (some variance but _very_ much less than the night
> before), there does appear to be some other occasional slight slowdown -
> but I've no reason to suspect your patch for it, nor to suppose it's
> something new: it may just be an artifact of my heavy swap thrashing.
> 
> 
> [PATCH mm] mm per-device dirty threshold fix
> 
> Fix occasional hang when a task couldn't get out of balance_dirty_pages:
> mm-per-device-dirty-threshold.patch needs to reevaluate bdi_nr_writeback
> across all cpus when bdi_thresh is low, even in the case when there was
> no bdi_nr_reclaimable.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Thank you Hugh. I ran into similar problems with many dd(large file)
operations.  This patch seems to fix it.

But now my desktop was locked up again when writing a lot of small
files. The problem is repeatable with the command
         $ ketchup 2.6.23-rc6-mm1

I writeup two debug patches:

---
 mm/page-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-2.6.22.orig/mm/page-writeback.c
+++ linux-2.6.22/mm/page-writeback.c
@@ -426,6 +426,14 @@ static void balance_dirty_pages(struct a
 			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
+		printk(KERN_DEBUG "balance_dirty_pages written %lu %lu congested %d limits %lu %lu %lu %lu %lu %ld\n",
+				pages_written,
+				write_chunk - wbc.nr_to_write,
+				bdi_write_congested(bdi),
+				background_thresh, dirty_thresh,
+				bdi_thresh, bdi_nr_reclaimable, bdi_nr_writeback,
+				bdi_thresh - bdi_nr_reclaimable - bdi_nr_writeback);
+
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 			break;
 		if (pages_written >= write_chunk)

---
 mm/page-writeback.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.22.orig/mm/page-writeback.c
+++ linux-2.6.22/mm/page-writeback.c
@@ -373,6 +373,7 @@ static void balance_dirty_pages(struct a
 	long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
+	int i = 0;
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
@@ -434,6 +435,10 @@ static void balance_dirty_pages(struct a
 				bdi_thresh, bdi_nr_reclaimable, bdi_nr_writeback,
 				bdi_thresh - bdi_nr_reclaimable - bdi_nr_writeback);
 
+		if (i++ > 200) {
+			printk(KERN_WARNING "balance_dirty_pages force break\n");
+			break;
+		}
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 			break;
 		if (pages_written >= write_chunk)


Here are the output messages:
[ 1305.361511] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.361519] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.361526] balance_dirty_pages written 3 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.461889] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.461922] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.461930] balance_dirty_pages written 3 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.562267] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.562275] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.562283] balance_dirty_pages written 3 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.662719] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.662797] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.662816] balance_dirty_pages written 3 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.662818] balance_dirty_pages force break
[ 1305.667031] balance_dirty_pages written 1 1 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.682925] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.682929] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.682934] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.783100] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.783132] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.783140] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.883478] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.883509] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.883517] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.983896] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.983904] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1305.983912] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.006108] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.006116] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.006123] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.007122] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.007129] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.007136] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.024303] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.024307] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.024311] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.124486] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.124516] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.124524] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.224742] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.224750] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.224758] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.247682] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.247690] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.247697] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.248682] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.248689] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.248697] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.344993] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.345001] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.345008] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.445220] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.445257] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.445265] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.545628] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.545636] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.545644] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.646110] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.646200] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.646205] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.746427] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.746458] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.746466] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.846845] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.846880] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.846888] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.947430] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.947439] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1306.947446] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.047803] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.047837] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.047845] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.148199] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.148208] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.148215] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.248577] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.248607] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.248615] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.348996] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.349026] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.349034] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.449380] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.449410] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.449418] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.549751] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.549759] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.549767] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.650149] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.650183] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.650190] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.750530] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.750538] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.750546] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.850927] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.850962] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.850969] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.951391] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.951424] balance_dirty_pages written 2 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1307.951432] balance_dirty_pages written 1 0 congested 0 limits 48869 195477 5801 5760 288 -247
[ 1308.051824] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.051886] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.051894] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.152223] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.152256] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.152264] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.252599] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.252607] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.252615] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.352997] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.353005] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.353013] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.453382] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.453412] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.453420] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.553754] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.553761] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.553769] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.654103] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.654147] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.654155] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.754209] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.754248] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.754255] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.844406] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.844444] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.844448] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.944852] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.944860] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.944867] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.995227] balance_dirty_pages written 0 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.995231] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1308.995235] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.005342] balance_dirty_pages written 2 2 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.005350] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.005358] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.015297] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.015301] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.015305] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.015412] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.015419] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.015427] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.115487] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.115518] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.115526] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.215864] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.215872] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.215879] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.316242] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.316250] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.316257] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.416642] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.416672] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.416680] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.517019] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.517027] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.517034] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.617417] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.617425] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.617432] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.717936] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.717978] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.717984] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.818175] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.818182] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.818190] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.918592] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.918599] balance_dirty_pages written 2 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1309.918607] balance_dirty_pages written 1 0 congested 0 limits 48869 195478 5801 5760 288 -247
[ 1310.019012] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.019043] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.019051] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.119388] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.119396] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.119403] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.219766] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.219774] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.219781] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.320205] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.320239] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.320246] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.420603] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.420611] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.420618] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.520981] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.520988] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.520996] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.621359] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.621367] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.621374] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.721914] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.721947] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.721961] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.822156] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.822191] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.822199] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.922554] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.922585] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1310.922592] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.022993] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.023002] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.023009] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.123330] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.123364] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.123372] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.223506] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.223514] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.223521] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.313664] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.313672] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.313679] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.413853] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.413862] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.413870] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.514198] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.514230] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.514238] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.614576] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.614584] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.614591] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.715096] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.715105] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.715113] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.815333] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.815364] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.815372] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.915751] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.915759] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1311.915767] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.016129] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.016138] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.016145] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.116529] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.116563] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.116571] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.216904] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.216912] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.216919] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.317384] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.317392] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.317399] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.417763] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.417794] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.417802] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.518140] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.518148] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.518155] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.618538] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.618545] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.618553] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.719060] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.719100] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.719104] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.819315] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.819324] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.819331] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.919692] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.919700] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1312.919707] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.020193] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.020226] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.020233] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.120590] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.120620] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.120628] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.221008] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.221039] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.221047] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.321386] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.321416] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.321424] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.421764] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.421771] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.421779] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.522162] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.522196] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.522204] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.622581] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.622588] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.622596] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.722943] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.722987] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.723002] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.812976] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.823016] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.823024] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.913212] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.923271] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1313.923279] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.013607] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.023626] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.023634] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.113967] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.124031] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.124039] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.214366] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.224404] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.224412] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.314764] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.324823] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.324831] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.415182] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.425242] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.425250] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.515601] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.525660] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.525667] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.615999] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.626036] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.626043] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.716378] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.726591] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.726596] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.816777] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.826814] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.826822] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.917174] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.927233] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1314.927241] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1315.017674] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1315.027734] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1315.027742] balance_dirty_pages written 1 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1315.118091] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1315.128150] balance_dirty_pages written 2 0 congested 0 limits 48869 195479 5801 5760 288 -247
[ 1315.128153] balance_dirty_pages force break

Here are some messages when doing large dds:

[  508.251270] balance_dirty_pages written 599 599 congested 0 limits 49798 199193 6816 1 0 6815
[  509.170366] balance_dirty_pages written 1540 1540 congested 0 limits 49733 198933 6806 6528 1536 -1258
[  509.370627] balance_dirty_pages written 1544 1544 congested 2 limits 49733 198933 7976 4584 1824 1568
[  509.371882] balance_dirty_pages written 1544 1544 congested 2 limits 49733 198933 7999 3456 2904 1639
[  511.733791] balance_dirty_pages written 1540 1540 congested 0 limits 49728 198913 10999 18288 0 -7289
[  511.735048] balance_dirty_pages written 1540 1540 congested 0 limits 49728 198913 12012 16752 0 -4740
[  511.736506] balance_dirty_pages written 1540 1540 congested 0 limits 49728 198913 12306 15192 1056 -3942
[  512.002169] balance_dirty_pages written 1547 1547 congested 2 limits 49726 198905 13471 12624 1848 -1001
[  512.003795] balance_dirty_pages written 1540 1540 congested 2 limits 49723 198892 13470 11088 3384 -1002
[  512.083517] balance_dirty_pages written 1540 1540 congested 2 limits 49712 198850 13572 9336 4992 -756
[  512.085145] balance_dirty_pages written 1540 1540 congested 2 limits 49706 198825 13569 7800 6528 -759
[  512.086773] balance_dirty_pages written 1540 1540 congested 2 limits 49702 198808 13568 6240 8064 -736
[  512.184267] balance_dirty_pages written 1539 1539 congested 2 limits 49697 198791 13649 5592 8592 -535
[  512.185903] balance_dirty_pages written 1540 1540 congested 2 limits 49694 198778 13649 4056 10152 -559
[  512.187506] balance_dirty_pages written 1540 1540 congested 2 limits 49688 198753 13647 2496 11688 -537
[  512.259848] balance_dirty_pages written 1546 1546 congested 2 limits 49682 198728 13769 744 13248 -223
[  512.554646] balance_dirty_pages written 618 618 congested 2 limits 49678 198712 14242 1 13368 873
[  512.585204] balance_dirty_pages written 794 794 congested 2 limits 49657 198630 14500 1 12936 1563
[  527.714294] balance_dirty_pages written 1540 1540 congested 0 limits 49608 198432 29502 28080 0 1422
[  529.298022] balance_dirty_pages written 1540 1540 congested 0 limits 49579 198318 30307 34704 0 -4397
[  529.304975] balance_dirty_pages written 1539 1539 congested 0 limits 49575 198302 32451 30600 0 1851
[  529.305205] balance_dirty_pages written 1538 1538 congested 0 limits 49576 198306 32571 30384 0 2187
[  529.306988] balance_dirty_pages written 1537 1537 congested 0 limits 49580 198320 32702 30120 0 2582
[  530.893830] balance_dirty_pages written 1541 1541 congested 0 limits 49553 198214 34216 35352 0 -1136
[  530.893970] balance_dirty_pages written 1538 1538 congested 0 limits 49553 198214 34290 35160 0 -870
[  530.899873] balance_dirty_pages written 1546 1546 congested 0 limits 49556 198227 36248 31248 0 5000
[  530.900282] balance_dirty_pages written 1546 1546 congested 0 limits 49557 198231 36442 30864 0 5578
[  530.900586] balance_dirty_pages written 1539 1539 congested 0 limits 49558 198235 36601 30552 0 6049
[  532.343097] balance_dirty_pages written 1541 1541 congested 0 limits 49530 198120 37862 36072 0 1790
[  532.343595] balance_dirty_pages written 1547 1547 congested 0 limits 49533 198132 38081 35640 0 2441
[  533.872355] balance_dirty_pages written 1540 1540 congested 0 limits 49502 198009 41148 37224 0 3924
[  542.566083] balance_dirty_pages written 1542 1542 congested 0 limits 49367 197469 51948 52680 0 -732
[  542.567093] balance_dirty_pages written 1537 1537 congested 0 limits 49370 197482 52663 50952 0 1711
[  542.586552] balance_dirty_pages written 1540 1540 congested 0 limits 49352 197410 54545 46032 0 8513
[  542.606002] balance_dirty_pages written 1540 1540 congested 0 limits 49337 197350 55132 44520 0 10612

