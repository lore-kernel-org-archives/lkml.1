Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbXIVNTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbXIVNTC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 09:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXIVNSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 09:18:53 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59674 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXIVNSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 09:18:52 -0400
Date: Sat, 22 Sep 2007 15:16:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Hugh Dickins <hugh@veritas.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070922151622.711178e2@lappy>
In-Reply-To: <390426111.11400@ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919164348.GC2519@shadowen.org>
	<Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com>
	<20070919224409.24baa75b@lappy>
	<Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
	<390426111.11400@ustc.edu.cn>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_LPixtcsObN9i5j0k7+jOowO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_LPixtcsObN9i5j0k7+jOowO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 22 Sep 2007 09:55:09 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn>
wrote:

> --- linux-2.6.22.orig/mm/page-writeback.c
> +++ linux-2.6.22/mm/page-writeback.c
> @@ -426,6 +426,14 @@ static void balance_dirty_pages(struct a
>  			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
>  		}
>  
> +		printk(KERN_DEBUG "balance_dirty_pages written %lu %lu congested %d limits %lu %lu %lu %lu %lu %ld\n",
> +				pages_written,
> +				write_chunk - wbc.nr_to_write,
> +				bdi_write_congested(bdi),
> +				background_thresh, dirty_thresh,
> +				bdi_thresh, bdi_nr_reclaimable, bdi_nr_writeback,
> +				bdi_thresh - bdi_nr_reclaimable - bdi_nr_writeback);
> +
>  		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
>  			break;
>  		if (pages_written >= write_chunk)
> 

> [ 1305.361511] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247

<snip long series of mostly identical lines>

Most peculiar. It seems writeback_inodes() doesn't even attempt to
write out stuff. Nor are outstanding writeback pages completed.

Could you perhaps instrument the writeback_inodes() path to see why
nothing is written out? - the attached patch would be a nice start.

> Here are some messages when doing large dds:

> [  511.733791] balance_dirty_pages written 1540 1540 congested 0 limits 49728 198913 10999 18288 0 -7289
> [  511.735048] balance_dirty_pages written 1540 1540 congested 0 limits 49728 198913 12012 16752 0 -4740
> [  511.736506] balance_dirty_pages written 1540 1540 congested 0 limits 49728 198913 12306 15192 1056 -3942
> [  512.002169] balance_dirty_pages written 1547 1547 congested 2 limits 49726 198905 13471 12624 1848 -1001
> [  512.003795] balance_dirty_pages written 1540 1540 congested 2 limits 49723 198892 13470 11088 3384 -1002
> [  512.083517] balance_dirty_pages written 1540 1540 congested 2 limits 49712 198850 13572 9336 4992 -756
> [  512.085145] balance_dirty_pages written 1540 1540 congested 2 limits 49706 198825 13569 7800 6528 -759
> [  512.086773] balance_dirty_pages written 1540 1540 congested 2 limits 49702 198808 13568 6240 8064 -736
> [  512.184267] balance_dirty_pages written 1539 1539 congested 2 limits 49697 198791 13649 5592 8592 -535
> [  512.185903] balance_dirty_pages written 1540 1540 congested 2 limits 49694 198778 13649 4056 10152 -559
> [  512.187506] balance_dirty_pages written 1540 1540 congested 2 limits 49688 198753 13647 2496 11688 -537
> [  512.259848] balance_dirty_pages written 1546 1546 congested 2 limits 49682 198728 13769 744 13248 -223
> [  512.554646] balance_dirty_pages written 618 618 congested 2 limits 49678 198712 14242 1 13368 873
> [  512.585204] balance_dirty_pages written 794 794 congested 2 limits 49657 198630 14500 1 12936 1563
> [  527.714294] balance_dirty_pages written 1540 1540 congested 0 limits 49608 198432 29502 28080 0 1422

This looks like a sane series, we have a surplus of reclaimable pages,
start writeout, which increases writeback pages, and congests the
device, and eventually all subsides and we finish congestion and quit.

> [  529.298022] balance_dirty_pages written 1540 1540 congested 0 limits 49579 198318 30307 34704 0 -4397
> [  529.304975] balance_dirty_pages written 1539 1539 congested 0 limits 49575 198302 32451 30600 0 1851
> [  529.305205] balance_dirty_pages written 1538 1538 congested 0 limits 49576 198306 32571 30384 0 2187
> [  529.306988] balance_dirty_pages written 1537 1537 congested 0 limits 49580 198320 32702 30120 0 2582
> [  530.893830] balance_dirty_pages written 1541 1541 congested 0 limits 49553 198214 34216 35352 0 -1136
> [  530.893970] balance_dirty_pages written 1538 1538 congested 0 limits 49553 198214 34290 35160 0 -870
> [  530.899873] balance_dirty_pages written 1546 1546 congested 0 limits 49556 198227 36248 31248 0 5000
> [  530.900282] balance_dirty_pages written 1546 1546 congested 0 limits 49557 198231 36442 30864 0 5578
> [  530.900586] balance_dirty_pages written 1539 1539 congested 0 limits 49558 198235 36601 30552 0 6049
> [  532.343097] balance_dirty_pages written 1541 1541 congested 0 limits 49530 198120 37862 36072 0 1790
> [  532.343595] balance_dirty_pages written 1547 1547 congested 0 limits 49533 198132 38081 35640 0 2441
> [  533.872355] balance_dirty_pages written 1540 1540 congested 0 limits 49502 198009 41148 37224 0 3924
> [  542.566083] balance_dirty_pages written 1542 1542 congested 0 limits 49367 197469 51948 52680 0 -732
> [  542.567093] balance_dirty_pages written 1537 1537 congested 0 limits 49370 197482 52663 50952 0 1711
> [  542.586552] balance_dirty_pages written 1540 1540 congested 0 limits 49352 197410 54545 46032 0 8513
> [  542.606002] balance_dirty_pages written 1540 1540 congested 0 limits 49337 197350 55132 44520 0 10612

More stuff that doesn't look funny.




--MP_LPixtcsObN9i5j0k7+jOowO
Content-Type: text/x-patch; name=plop.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=plop.patch

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5705c51..5e1f806 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -580,11 +580,11 @@ restart:
 						ret = err;
 				}
 				up_read(&sb->s_umount);
-			}
+			} else count_vm_event(NR_SB_LOCKED);
 			spin_lock(&sb_lock);
 			if (__put_super_and_need_restart(sb))
 				goto restart;
-		}
+		} else count_vm_event(NR_SB_EMPTY);
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 75370ec..f9d19f0 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -37,6 +37,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		NR_SB_LOCKED,
+		NR_SB_EMPTY,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8e185f1..611f9d6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -735,6 +735,9 @@ static const char * const vmstat_text[] = {
 	"allocstall",
 
 	"pgrotated",
+
+	"sb_locked",
+	"sb_empty",
 #endif
 };
 

--MP_LPixtcsObN9i5j0k7+jOowO--
