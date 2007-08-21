Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbXHUG4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbXHUG4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761275AbXHUGyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:54:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44263 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991AbXHUGya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:54:30 -0400
Date: Mon, 20 Aug 2007 23:55:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Timo Jantunen <jeti@iki.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/20] forcedeth: fix random hang in forcedeth driver when
	using netconsole
Message-ID: <20070821065527.GM5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-fix-random-hang-in-forcedeth-driver-when-using-netconsole.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Timo Jantunen <jeti@iki.fi>

If the forcedeth driver receives too much work in an interrupt, it
assumes it has a broken hardware with stuck IRQ. It works around the
problem by disabling interrupts on the nic but makes a printk while
holding device spinlog - which isn't smart thing to do if you have
netconsole on the same nic.

This patch moves the printk's out of the spinlock protected area.


Without this patch the machine hangs hard. With this patch everything
still works even when there is significant increase on CPU usage while
using the nic.

Signed-off-by: Timo Jantunen <jeti@iki.fi>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/forcedeth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
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
 

-- 
