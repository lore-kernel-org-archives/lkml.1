Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZH2KMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZH2KMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZH2KMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:12:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:37988 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZH2KMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="181849408"
Date: Sat, 29 Aug 2009 18:12:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I/O and pdflush
Message-ID: <20090829101247.GA20786@localhost>
References: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com> <20090712080410.GA8512@localhost> <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Aug 29, 2009 at 05:48:40AM +0800, Fernando Silveira wrote:
> On Sun, Jul 12, 2009 at 05:04, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Sat, Jul 11, 2009 at 02:27:25PM -0300, Fernando Silveira wrote:
> >> I'm having a hard time with an application that writes sequentially
> >> 250GB of non-stop data directly to a solid state disk (OCZ SSD CORE
> >> v2) device and I hope you can help me. The command "dd if=/dev/zero
> >> of=/dev/sdc bs=4M" reproduces the same symptoms I'm having and writes
> >> exactly as that application does.
> >
> > What's your kernel version?  Can the following patch help?
> 
> Sorry for the delay, but I could not test it before.
> 
> Unfortunately it did not help or change any symptoms at all. The
> kernel version I tested was a non-patched 2.6.30.1 version.
> 
> Do you have any other hint?

Sure. Attached is a writeback debug patch. It will generate lots of
kernel messages. You can just stop your klogd, start your workload
and monitor the SSD writeback throughput via tools like iostat/dstat.
When it goes into the suboptimal 25MB/s state for several seconds, run
        dmesg > dmesg-writeback
and send me the log.

And it is advised to turn on the kconfig option CONFIG_PRINTK_TIME=y.

Thanks,
Fengguang

--a8Wt8u1KmwUX3Y2C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-debug.patch"

 mm/page-writeback.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- mm.orig/mm/page-writeback.c
+++ mm/mm/page-writeback.c
@@ -116,6 +116,33 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+#define writeback_debug_report(n, wbc) do {                               \
+	__writeback_debug_report(n, wbc, __FILE__, __LINE__, __FUNCTION__); \
+} while (0)
+
+void print_writeback_control(struct writeback_control *wbc)
+{
+	printk(KERN_DEBUG
+			"global dirty %lu writeback %lu nfs %lu "
+			"flags %c%c towrite %ld skipped %ld\n",
+			global_page_state(NR_FILE_DIRTY),
+			global_page_state(NR_WRITEBACK),
+			global_page_state(NR_UNSTABLE_NFS),
+			wbc->encountered_congestion ? 'C':'_',
+			wbc->more_io ? 'M':'_',
+			wbc->nr_to_write,
+			wbc->pages_skipped);
+}
+
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func)
+{
+	printk(KERN_DEBUG "%s %d %s: %s(%d) %ld\n",
+			file, line, func,
+			current->comm, current->pid,
+			n);
+	print_writeback_control(wbc);
+}
 
 static void background_writeout(unsigned long _min_pages);
 
@@ -546,6 +573,7 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
 
 		/*
@@ -572,6 +600,7 @@ static void balance_dirty_pages(struct a
 			break;		/* We've done our duty */
 
 		congestion_wait(WRITE, HZ/10);
+		writeback_debug_report(-pages_written, &wbc);
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
@@ -666,6 +695,11 @@ void throttle_vm_writeout(gfp_t gfp_mask
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
@@ -715,7 +749,9 @@ static void background_writeout(unsigned
 			else
 				break;
 		}
+		writeback_debug_report(min_pages, &wbc);
 	}
+	writeback_debug_report(min_pages, &wbc);
 }
 
 /*
@@ -788,7 +824,9 @@ static void wb_kupdate(unsigned long arg
 				break;	/* All the old data is written */
 		}
 		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		writeback_debug_report(nr_to_write, &wbc);
 	}
+	writeback_debug_report(nr_to_write, &wbc);
 	if (time_before(next_jif, jiffies + HZ))
 		next_jif = jiffies + HZ;
 	if (dirty_writeback_interval)

--a8Wt8u1KmwUX3Y2C--
