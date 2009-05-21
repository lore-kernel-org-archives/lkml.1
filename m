Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZEUGul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZEUGul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZEUGud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:50:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:42961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZEUGud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:50:33 -0400
From: Neil Brown <neilb@suse.de>
To: paulmck@linux.vnet.ibm.com
Date: Thu, 21 May 2009 16:50:23 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18964.63919.206864.619147@notabene.brown>
Cc: Janos Haar <janos.haar@netcenter.hu>, linux-kernel@vger.kernel.org
Subject: Re: Fw: RCU detected CPU 1 stall (t=4295904002/751 jiffies)
	Pid:902, comm: md1_raid5
In-Reply-To: message from Paul E. McKenney on Wednesday May 20
References: <030101c9d92f$d0668600$0400a8c0@dcccs>
	<20090521025037.GD6839@linux.vnet.ibm.com>
	<013501c9d9cf$161a74a0$0400a8c0@dcccs>
	<20090521051658.GE6839@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday May 20, paulmck@linux.vnet.ibm.com wrote:
> On Thu, May 21, 2009 at 06:46:15AM +0200, Janos Haar wrote:
> > Paul,
> >
> > Thank you for your attention.
> > Yes, the PC makes 2-3 second "pauses" and drop this message again and 
> > again.
> > If i remove the RCU debugging, the message disappears, but the pauses still 
> > here, and makes 2-3 load on the idle system.
> > Can i do something?
> > You suggest to use PREEMPT? (This is a server.)
> 
> One possibility is that the lock that bitmap_daemon_work() acquires is
> being held for too long.  Another possibility is the list traversal in
> md_check_recovery() that might loop for a long time if the list were
> excessively long or could be temporarily tied in a knot.
> 
> Neil, thoughts?
> 

I would be surprised if any of these things take as long as 3 seconds
(or even 1 second) but I cannot completely rule it out.

I assume that you mean 3 seconds of continuous running with no
sleeping, so it cannot be a slow kmalloc that is causing the delay?

bitmap_daemon_work is the most likely candidate as bitmap->chunks
can be very large (thousands, probably not millions though).
Taking and dropping the lock every time around that loop doesn't
really make much sense, does it....
And it looks like it could actually be optimised quite a bit to skip a
lot of the iterations in most cases - there are two places where we
can accelerate 'j' quite a lot.

Janos: Can you try this and see if it makes a difference?
Thanks.

NeilBrown

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 47c68bc..56df1ce 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1097,14 +1097,12 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 	}
 	bitmap->allclean = 1;
 
+	spin_lock_irqsave(&bitmap->lock, flags);
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
-		spin_lock_irqsave(&bitmap->lock, flags);
-		if (!bitmap->filemap) {
+		if (!bitmap->filemap)
 			/* error or shutdown */
-			spin_unlock_irqrestore(&bitmap->lock, flags);
 			break;
-		}
 
 		page = filemap_get_page(bitmap, j);
 
@@ -1121,6 +1119,8 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 					write_page(bitmap, page, 0);
 					bitmap->allclean = 0;
 				}
+				spin_lock_irqsave(&bitmap->lock, flags);
+				j |= (PAGE_BITS - 1);
 				continue;
 			}
 
@@ -1181,9 +1181,10 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 					ext2_clear_bit(file_page_offset(j), paddr);
 				kunmap_atomic(paddr, KM_USER0);
 			}
-		}
-		spin_unlock_irqrestore(&bitmap->lock, flags);
+		} else
+			j |= PAGE_COUNTER_MASK;
 	}
+	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	/* now sync the final page */
 	if (lastpage != NULL) {
