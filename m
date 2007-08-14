Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbXHNTX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbXHNTX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbXHNTWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:22:30 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37344 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760466AbXHNTW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:22:28 -0400
X-Greylist: delayed 1528 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 15:22:27 EDT
Date: Tue, 14 Aug 2007 21:56:57 +0300 (EEST)
From: Timo Jantunen <jeti@iki.fi>
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: stable@kernel.org
Subject: [PATCH] fix random hang in forcedeth driver when using netconsole
Message-ID: <Pine.LNX.4.64.0708142147130.6769@limbo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heip!

If the forcedeth driver receives too much work in an interrupt, it assumes
it has a broken hardware with stuck IRQ. It works around the problem by
disabling interrupts on the nic but makes a printk while holding device
spinlog - which isn't smart thing to do if you have netconsole on the
same nic.

This patch moves the printk's out of the spinlock protected area.


Without this patch the machine hangs hard. With this patch everything still 
works even when there is significant increase on CPU usage while using the 
nic.

//T


Signed-off-by: Timo Jantunen <jeti@iki.fi>


diff -uprN -X linux-2.6.22.2/Documentation/dontdiff linux-2.6.22.2.original/drivers/net/forcedeth.c linux-2.6.22.2/drivers/net/forcedeth.c
--- linux-2.6.22.2.original/drivers/net/forcedeth.c	2007-08-10 08:20:27.761813671 +0300
+++ linux-2.6.22.2/drivers/net/forcedeth.c	2007-08-14 21:03:14.109056661 +0300
@@ -3067,8 +3067,8 @@ static irqreturn_t nv_nic_irq(int foo, v
 				np->nic_poll_irq = np->irqmask;
 				mod_timer(&np->nic_poll, jiffies + POLL_WAIT);
 			}
-			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq.\n", dev->name, i);
 			spin_unlock(&np->lock);
+			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq.\n", dev->name, i);
 			break;
 		}
 
@@ -3185,8 +3185,8 @@ static irqreturn_t nv_nic_irq_optimized(
 				np->nic_poll_irq = np->irqmask;
 				mod_timer(&np->nic_poll, jiffies + POLL_WAIT);
 			}
-			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq.\n", dev->name, i);
 			spin_unlock(&np->lock);
+			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq.\n", dev->name, i);
 			break;
 		}
 
@@ -3232,8 +3232,8 @@ static irqreturn_t nv_nic_irq_tx(int foo
 				np->nic_poll_irq |= NVREG_IRQ_TX_ALL;
 				mod_timer(&np->nic_poll, jiffies + POLL_WAIT);
 			}
-			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq_tx.\n", dev->name, i);
 			spin_unlock_irqrestore(&np->lock, flags);
+			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq_tx.\n", dev->name, i);
 			break;
 		}
 
@@ -3347,8 +3347,8 @@ static irqreturn_t nv_nic_irq_rx(int foo
 				np->nic_poll_irq |= NVREG_IRQ_RX_ALL;
 				mod_timer(&np->nic_poll, jiffies + POLL_WAIT);
 			}
-			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq_rx.\n", dev->name, i);
 			spin_unlock_irqrestore(&np->lock, flags);
+			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq_rx.\n", dev->name, i);
 			break;
 		}
 	}
@@ -3420,8 +3420,8 @@ static irqreturn_t nv_nic_irq_other(int 
 				np->nic_poll_irq |= NVREG_IRQ_OTHER;
 				mod_timer(&np->nic_poll, jiffies + POLL_WAIT);
 			}
-			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq_other.\n", dev->name, i);
 			spin_unlock_irqrestore(&np->lock, flags);
+			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq_other.\n", dev->name, i);
 			break;
 		}
 

