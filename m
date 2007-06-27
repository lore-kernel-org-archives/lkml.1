Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbXF0HQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbXF0HQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXF0HQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:16:09 -0400
Received: from mx12.go2.pl ([193.17.41.142]:45017 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751973AbXF0HQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:16:07 -0400
Date: Wed, 27 Jun 2007 09:24:15 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Wessel\, Jason" <jason.wessel@windriver.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       stable@kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Re: [2.6.21.1] soft lockup when removing netconsole module
Message-ID: <20070627072415.GA1899@ff.dom.local>
References: <20070626160753.f86d8803.akpm@linux-foundation.org> <7ED098B05D69FE41B380586BF1474DBA441F47@ala-mail08.corp.ad.wrs.com> <20070626180000.5974e942.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626180000.5974e942.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 06:00:00PM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2007 17:46:13 -0700 "Wessel, Jason" <jason.wessel@windriver.com> wrote:
...
> > > Everything went quiet?
> > > 
> > > If this patch has been tested and fixes the bug, can you 
> > > please send a version which is ready for merging?  (ie: add a 
> > > suitable description of what it does).
> > > 
> > > 
> > 
> > I mailed Jarek separately.
> > 
> > I had tested the patch with netconsole and kgdb and it does in fact fix
> > the problem that was reported.
> 
> OK, thanks.  Please don't mail people separately!
> 
> I queued this up with a null changelog for now.
> 

I pasted here this queued version - only the changelog is added.

Regards,
Jarek P.

------------------------------------------------------
Subject: netconsole: fix soft lockup (2.6.21) and memory leak when removing module
From: Jarek Poplawski <jarkao2@o2.pl>

#1
Until kernel ver. 2.6.21 (including) cancel_rearming_delayed_work()
required a work function should always (unconditionally) rearm with
delay > 0 - otherwise it would endlessly loop. This patch replaces
this function with cancel_delayed_work(). Later kernel versions don't
require this, so here it's only for uniformity.

#2
After deleting a timer in cancel_[rearming_]delayed_work() there could
stay a last skb queued in npinfo->txq causing a memory leak after
kfree(npinfo).

Initial patch & testing by: Jason Wessel <jason.wessel@windriver.com>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN net/core/netpoll.c~netconsole-fix-soft-lockup-when-removing-module net/core/netpoll.c
--- a/net/core/netpoll.c~netconsole-fix-soft-lockup-when-removing-module
+++ a/net/core/netpoll.c
@@ -72,7 +72,8 @@ static void queue_process(struct work_st
 			netif_tx_unlock(dev);
 			local_irq_restore(flags);
 
-			schedule_delayed_work(&npinfo->tx_work, HZ/10);
+			if (atomic_read(&npinfo->refcnt))
+				schedule_delayed_work(&npinfo->tx_work, HZ/10);
 			return;
 		}
 		netif_tx_unlock(dev);
@@ -785,9 +786,15 @@ void netpoll_cleanup(struct netpoll *np)
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
-				cancel_rearming_delayed_work(&npinfo->tx_work);
+				cancel_delayed_work(&npinfo->tx_work);
 				flush_scheduled_work();
 
+				/* clean after last, unfinished work */
+				if (!skb_queue_empty(&npinfo->txq)) {
+					struct sk_buff *skb;
+					skb = __skb_dequeue(&npinfo->txq);
+					kfree_skb(skb);
+				}
 				kfree(npinfo);
 			}
 		}
