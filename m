Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYDHX5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYDHX5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbYDHX4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:56:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34254
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbYDHX4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:56:52 -0400
Date: Tue, 08 Apr 2008 16:56:53 -0700 (PDT)
Message-Id: <20080408.165653.224963340.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, marcus@better.se
Subject: Re: [Bug #10326] inconsistent lock state in net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <SvnMeM-aZi.A.YKF.D__-HB@albercik>
References: <SvnMeM-aZi.A.YKF.D__-HB@albercik>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed,  9 Apr 2008 01:02:09 +0200 (CEST)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
> Subject		: inconsistent lock state in net_rx_action
> Submitter	: Marcus Better <marcus@better.se>
> Date		: 2008-03-25 13:21 (15 days old)
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20

This is already fixed by:

commit 50fd4407b8bfbde7c1a0bfe4f24de7df37164342
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Mar 27 17:42:50 2008 -0700

    [NET]: Use local_irq_{save,restore}() in napi_complete().
    
    Based upon a lockdep report.
    
    Since ->poll() can be invoked from netpoll with interrupts
    disabled, we must not unconditionally enable interrupts
    in napi_complete().
    
    Instead we must use local_irq_{save,restore}().
    
    Noticed by Peter Zijlstra:
    
    <irqs disabled>
    
      netpoll_poll()
        poll_napi()
          spin_trylock(&napi->poll_lock)
          poll_one_napi()
            napi->poll() := sky2_poll()
              napi_complete()
                local_irq_disable()
                local_irq_enable() <--- *BUG*
    
      <irq>
        irq_exit()
          do_softirq()
            net_rx_action()
              spin_lock(&napi->poll_lock) <--- Deadlock!
    
    Because we still hold the lock....
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a2f0032..fae6a7e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -383,9 +383,11 @@ static inline void __napi_complete(struct napi_struct *n)
 
 static inline void napi_complete(struct napi_struct *n)
 {
-	local_irq_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__napi_complete(n);
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 /**
