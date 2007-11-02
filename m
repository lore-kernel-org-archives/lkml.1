Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbXKBCV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbXKBCV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbXKBCVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:21:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40626 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754812AbXKBCVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:21:46 -0400
Message-ID: <393970108.15915@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 2 Nov 2007 10:21:42 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221421.21439.maximlevitsky@gmail.com> <393056632.00561@ustc.edu.cn> <200710221505.35397.maximlevitsky@gmail.com> <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn> <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com> <393903856.06449@ustc.edu.cn> <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1InmAI-0003ME-2i@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 01, 2007 at 08:00:10PM +0100, Torsten Kaiser wrote:
> On 11/1/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > On 11/1/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > > Thank you. Maybe we can start by the applied debug patch :-)
> >
> > Will applied it and try to recreate this.
> 
> Patch applied, used emerge to install a 2.6.24-rc1 kernel.
> 
> I had no complete stalls, but three times during the move from tmpfs
> to the main xfs the emerge got noticeable slower. There still was
> writeout happening, but as emerge prints out every file it has written
> during the pause not one file was processed.
> 
> vmstat 10:
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  0  1      0 3146424    332 614768    0    0   134  1849  438 2515  3  4 91  2
>  0  0      0 3146644    332 614784    0    0     2  1628  507  646  0  2 85 13
>  0  0      0 3146868    332 614868    0    0     5  2359  527 1076  0  3 97  0
>  1  0      0 3144372    332 616148    0    0    96  2829  607 2666  2  5 92  0
> -> normal writeout
>  0  0      0 3140560    332 618144    0    0   152  2764  633 3308  3  6 91  0
>  0  0      0 3137332    332 619908    0    0   114  1801  588 2858  3  4 93  0
>  0  0      0 3136912    332 620136    0    0    20   827  393 1605  1  2 98  0
> -> first stall

'stall': vmstat's output stalls for some time, or emerge stalls for
the next several vmstat lines?

>  0  0      0 3137088    332 620136    0    0     0   557  339 1437  0  1 99  0
>  0  0      0 3137160    332 620136    0    0     0   642  310 1400  0  1 99  0
>  0  0      0 3136588    332 620172    0    0     6  2972  527 1195  0  3 80 16
>  0  0      0 3136276    332 620348    0    0    10  2668  558 1195  0  3 96  0
>  0  0      0 3135228    332 620424    0    0     8  2712  522 1311  0  4 96  0
>  0  0      0 3131740    332 621524    0    0    75  2935  559 2457  2  5 93  0
>  0  0      0 3128348    332 622972    0    0    85  1470  490 2607  3  4 93  0
>  0  0      0 3129292    332 622972    0    0     0   527  353 1398  0  1 99  0
> -> second longer stall
>  0  0      0 3128520    332 623028    0    0     6   488  249 1390  0  1 99  0
>  0  0      0 3128236    332 623028    0    0     0   482  222 1222  0  1 99  0
>  0  0      0 3128408    332 623028    0    0     0   585  269 1301  0  0 99  0
>  0  0      0 3128532    332 623028    0    0     0   610  262 1278  0  0 99  0
>  0  0      0 3128568    332 623028    0    0     0   636  345 1639  0  1 99  0
>  0  0      0 3129032    332 623040    0    0     1   664  337 1466  0  1 99  0
>  0  0      0 3129484    332 623040    0    0     0   658  300 1508  0  0 100  0
>  0  0      0 3129576    332 623040    0    0     0   562  271 1454  0  1 99  0
>  0  0      0 3129736    332 623040    0    0     0   627  278 1406  0  1 99  0
>  0  0      0 3129368    332 623040    0    0     0   507  274 1301  0  1 99  0
>  0  0      0 3129004    332 623040    0    0     0   444  211 1213  0  0 99  0
>  0  1      0 3127260    332 623040    0    0     0  1036  305 1242  0  1 95  4
>  0  0      0 3126280    332 623128    0    0     7  4241  555 1575  1  5 84 10
>  0  0      0 3124948    332 623232    0    0     6  4194  529 1505  1  4 95  0
>  0  0      0 3125228    332 624168    0    0    58  1966  586 1964  2  4 94  0
> -> emerge resumed to normal speed, without any intervention from my side
>  0  0      0 3120932    332 625904    0    0   112  1546  546 2565  3  4 93  0
>  0  0      0 3118012    332 627568    0    0   128  1542  612 2705  3  4 93  0

Interesting, the 'bo' never falls to zero.

> 
> >From syslog:
> first stall:
> [  575.050000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 47259 > global 610 0 0 wc __ tw 1023 sk 0
> [  586.350000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 50465 > global 6117 0 0 wc _M tw 967 sk 0
> [  586.360000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 50408 > global 6117 0 0 wc __ tw 1022 sk 0
> [  599.900000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 53523 > global 11141 0 0 wc __ tw 1009 sk 0
> [  635.780000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 59397 > global 12757 124 0 wc __ tw 0 sk 0
> [  638.470000] mm/page-writeback.c 418 balance_dirty_pages: > emerge(6113) 1536 global 11405 51 0 wc __ tw 0 sk 0
> [  638.820000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 58373 > global 11276 48 0 wc __ tw -1 sk 0
> [  641.260000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 57348 > global 10565 100 0 wc __ tw 0 sk 0
> [  643.980000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 56324 > global 9788 103 0 wc __ tw -1 sk 0
> [  646.120000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 55299 > global 8912 6 0 wc __ tw 0 sk 0
> 
> second stall:
> [  664.040000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 48117 > global 2864 81 0 wc _M tw -13 sk 0
> [  664.400000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 47080 > global 1995 137 0 wc _M tw 176 sk 0
> [  664.510000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 46232 > global 1929 267 0 wc __ tw 880 sk 0
> cron[6927]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
> [  809.560000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 49422 > global 19166 217 0 wc _M tw 380 sk 0
> [  811.720000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 48778 > global 17969 407 0 wc _M tw -4 sk 0
> [  813.880000] mm/page-writeback.c 418 balance_dirty_pages: > emerge(6113) 1537 global 16592 233 0 wc _M tw -1 sk 0
> [  814.710000] mm/page-writeback.c 418 balance_dirty_pages: find(6931) > 1537 global 16132 179 0 wc __ tw -1 sk 0
> [  814.720000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 47750 > global 16040 271 0 wc _M tw -1 sk 0
> [  815.040000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 46725 > global 15403 779 0 wc CM tw 324 sk 0
>
> the third stall happend after the emerge was finished. There still was
> ~120Mb of dirty data, but its writeout got much slower over several
> seconds.
> vmstat 10:
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  1  0      0 3096152    332 630424    0    0    81  1503  640 2771  5  4 91  0
>  0  0      0 3101024    332 631588    0    0   279   473  510 1281  5  2 92  1
> -> stall / slowdown starts
>  0  0      0 3147924    332 632384    0    0    78   626  449 1384  0  1 99  0
>  1  0      0 3147940    332 632384    0    0     0   611  388 1387  0  1 99  0
>  0  1      0 3147576    332 632384    0    0     0   939  449 1432  0  1 99  0
>  0  0      0 3145476    332 632384    0    0     0  3592  644  925  0  4 93  3
> -> writeout resumes full speed
>  0  0      0 3147232    332 632480    0    0     0  3108  678 1053  0  3 97  0
>  0  0      0 3146860    332 632480    0    0     0  2497  677  859  0  3 97  0
>  0  0      0 3146720    332 632480    0    0     0  2433  648  839  0  3 97  0
>  0  0      0 3147844    332 632484    0    0     0  2394  625  889  0  3 97  0
>  0  0      0 3148128    332 632484    0    0     0  2204  671  848  0  2 97  0
> 
> from syslog:
> [  848.070000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 48084 > global 13805 0 0 wc _M tw 1008 sk 0
> [  848.080000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 48068 > global 13805 0 0 wc __ tw 1020 sk 0
> [  884.090000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 61811 > global 30297 2 0 wc __ tw 862 sk 0
> [  921.760000] mm/page-writeback.c 418 balance_dirty_pages: cat(7170) > 1541 global 28113 391 0 wc __ tw -5 sk 0
> -> that cat was probably my watch cat /proc/meminfo
> -> during the stall there where no updates visible there
> [  922.190000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 76871 > global 27735 0 0 wc __ tw -5 sk 0
> [  923.550000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 75842 > global 26688 106 0 wc _M tw -1 sk 0
> [  924.940000] mm/page-writeback.c 655 wb_kupdate: pdflush(285) 74817 > global 25698 195 0 wc _M tw 0 sk 0
> 
> Apart from my normal kde desktop (no compiz) and the emerge the system was idle.

Interestingly, no background_writeout() appears, but only
balance_dirty_pages() and wb_kupdate.  Obviously wb_kupdate won't
block the process.

> If I see the complete stall again, I will post that too.
 
Thank you, could you run it with the attached new debug patch?

Fengguang

--KsGdsel6WgEHnImy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-debug.patch"

---
 mm/page-writeback.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- linux-2.6.24-git17.orig/mm/page-writeback.c
+++ linux-2.6.24-git17/mm/page-writeback.c
@@ -98,6 +98,26 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+#define writeback_debug_report(n, wbc) do {                               \
+	__writeback_debug_report(n, wbc, __FILE__, __LINE__, __FUNCTION__); \
+} while (0)
+
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func)
+{
+	printk(KERN_DEBUG "%s %d %s: %s(%d) %ld "
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
 
@@ -395,6 +415,7 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
 
 		/*
@@ -421,6 +442,7 @@ static void balance_dirty_pages(struct a
 			break;		/* We've done our duty */
 
 		congestion_wait(WRITE, HZ/10);
+		writeback_debug_report(-pages_written, &wbc);
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
@@ -515,6 +537,11 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(WRITE, HZ/10);
+		printk(KERN_DEBUG "throttle_vm_writeout: "
+				"congestion_wait on %lu+%lu > %lu\n",
+				global_page_state(NR_UNSTABLE_NFS),
+				global_page_state(NR_WRITEBACK),
+				dirty_thresh);
 
 		/*
 		 * The caller might hold locks which can prevent IO completion
@@ -557,6 +584,7 @@ static void background_writeout(unsigned
 		wbc.pages_skipped = 0;
 		writeback_inodes(&wbc);
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		writeback_debug_report(min_pages, &wbc);
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
 			if (wbc.encountered_congestion || wbc.more_io)
@@ -630,6 +658,7 @@ static void wb_kupdate(unsigned long arg
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
+		writeback_debug_report(nr_to_write, &wbc);
 		if (wbc.nr_to_write > 0) {
 			if (wbc.encountered_congestion || wbc.more_io)
 				congestion_wait(WRITE, HZ/10);

--KsGdsel6WgEHnImy--

