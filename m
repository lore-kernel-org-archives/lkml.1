Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbYJJRNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbYJJRNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbYJJRNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:13:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56352 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbYJJRNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:13:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 10 Oct 2008 19:13:34 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch amendment] ieee1394: survive a few seconds connection loss
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.51d4828de9d3aee3@s5r6.in-berlin.de>
Message-ID: <tkrat.8c2b7db60bf8ee9c@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
 <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
 <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
 <tkrat.3829f18186b21759@s5r6.in-berlin.de>
 <tkrat.a7680a3ca1cdeb42@s5r6.in-berlin.de>
 <tkrat.51d4828de9d3aee3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Aug, Stefan Richter wrote:
> There are situations when nodes vanish from the bus and come back in
> quickly thereafter:
>   - When certain bus-powered hubs are plugged in,
>   - when certain disk enclosures are switched from self-power to bus
>     power or vice versa and break the daisy chain during the transition,
>   - when the user plugs a cable out and quickly plugs it back in, e.g.
>     to reorder a daisy chain (works on Mac OS X if done quickly enough),
>   - when certain hubs temporarily malfunction during high bus traffic.
> 
> The ieee1394 driver's nodemgr already contained a function to set
> vanished nodes aside into "limbo"; i.e. they wouldn't actually be
> deleted right away.  (In fact, only unloading the driver or writing into
> an obscure sysfs attribute would delete them eventually.)  If nodes
> reappeared later, they would be resurrected out of limbo.
> 
> Moving nodes into and out of limbo was accompanied with calling the
> .suspend() and .resume() driver methods of the drivers which were bound
> to a respective node's unit directories.  Not only is this somewhat
> strange due to the primary use of these drivers for power management,
> also the sbp2 driver in particular does not implement .suspend() and
> .resume().
> 
> Hence sbp2 would be disconnected from devices in situations as listed
> above.
> 
> We now:
>   - leave drivers bound when nodes go into limbo,
>   - call the drivers' .update() when nodes come out of limbo,
>   - automatically delete in-limbo nodes 5 seconds after the last
>     bus reset and bus rescan.
>   - Because of the automatic removal, the now obsolete bus attribute
>     /sys/bus/ieee1394/destroy_node is removed.
> 
> This especially lets sbp2 survive brief disconnections.  You can for
> example yank a disk's cable and plug it back in while reading the
> respective disk with dd, but dd will happily continue as if nothing
> happened.

Amendment:  Reduce timeout from 5 to 3 seconds.  This is enough because
the timeout is restarted if another bus reset happened during the
timeout.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -1726,18 +1726,17 @@ static int nodemgr_host_thread(void *dat
 		/* Update some of our sysfs symlinks */
 		nodemgr_update_host_dev_links(host);
 
-		/* Sleep 5 seconds */
-		for (i = 0; i < 5000/100 ; i++) {
-			msleep_interruptible(100);
+		/* Sleep 3 seconds */
+		for (i = 3000/200; i; i--) {
+			msleep_interruptible(200);
 			if (kthread_should_stop())
 				goto exit;
 
 			if (generation != get_hpsb_generation(host))
 				break;
 		}
-
 		/* Remove nodes which are gone, unless a bus reset happened */
-		if (i == 5000/100)
+		if (!i)
 			nodemgr_remove_nodes_in_limbo(host);
 	}
 exit:


-- 
Stefan Richter
-=====-==--- =-=- -=-=-
http://arcgraph.de/sr/

