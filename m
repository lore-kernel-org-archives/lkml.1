Return-Path: <linux-kernel-owner+w=401wt.eu-S1765734AbXGSM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765734AbXGSM4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760077AbXGSM4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:56:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49321 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbXGSM4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:56:30 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 14:54:52 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <20070716091236.GA10718@elte.hu> <20070719105816.GA15852@elte.hu> <200707191452.09609.olaf.kirch@oracle.com>
In-Reply-To: <200707191452.09609.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191454.53699.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 14:52, Olaf Kirch wrote:
> On Thursday 19 July 2007 12:58, Ingo Molnar wrote:
> > i.e. it's the classic 'eth0 got stuck somehow' tx/rx state machine 
> > hickup symptoms, with no other bad symptoms such as lockups or crashes.
> 
> Duh, I found it.

The following patch should confirm my theory. Can you give it a try,
please?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
---------
Index: build-2.6/drivers/net/e1000/e1000_main.c
===================================================================
--- build-2.6.orig/drivers/net/e1000/e1000_main.c
+++ build-2.6/drivers/net/e1000/e1000_main.c
@@ -358,6 +358,7 @@ e1000_irq_enable(struct e1000_adapter *a
 		E1000_WRITE_REG(&adapter->hw, IMS, IMS_ENABLE_MASK);
 		E1000_WRITE_FLUSH(&adapter->hw);
 	}
+	BUG_ON(atomic_read(&adapter->irq_sem) < 0);
 }
 
 static void

