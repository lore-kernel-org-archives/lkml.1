Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXH1JX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXH1JX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXH1JXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:23:13 -0400
Received: from s36.avahost.net ([74.53.95.194]:42053 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbXH1JXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:23:11 -0400
Message-ID: <46D3E971.4010909@katalix.com>
Date: Tue, 28 Aug 2007 10:22:57 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: shemminger@linux-foundation.org, ossthema@de.ibm.com, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
References: <46D2F301.7050105@katalix.com>	<20070827.140251.95055210.davem@davemloft.net>	<46D34517.4010505@katalix.com> <20070827.145600.102570576.davem@davemloft.net>
In-Reply-To: <20070827.145600.102570576.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: James Chapman <jchapman@katalix.com>
> Date: Mon, 27 Aug 2007 22:41:43 +0100
> 
>> I don't recall saying anything in previous posts about this. Are you 
>> confusing my posts with Jan-Bernd's?
> 
> Yes, my bad.
> 
>> Jan-Bernd has been talking about using hrtimers to _reschedule_
>> NAPI. My posts are suggesting an alternative mechanism that keeps
>> NAPI active (with interrupts disabled) for a jiffy or two after it
>> would otherwise have gone idle in order to avoid too many interrupts
>> when the packet rate is such that NAPI thrashes between poll-on and
>> poll-off.
> 
> So in this scheme what runs ->poll() to process incoming packets?
> The hrtimer?

No, the regular NAPI networking core calls ->poll() as usual; no timers 
are involved. This scheme simply delays the napi_complete() from the 
driver so the device stays in the poll list longer. It means that its 
->poll() will be called when there is no work to do for 1-2 jiffies, 
hence the optimization at the top of ->poll() to efficiently handle that 
case. The device's ->poll() is called by the NAPI core until it has 
continuously done no work for 1-2 jiffies, at which point it finally 
does the netif_rx_complete() and re-enables its interrupts.

If people feel that holding the device in the poll list for 1-2 jiffies 
is too long (because there are too many wasted polls), a counter could 
be used to to delay the netif_rx_complete() by N polls instead. N would 
be a value depending on CPU speed. I use the jiffy sampling method 
because it results in some natural randomization of the actual delay 
depending on when the jiffy value was sampled in relation to the jiffy tick.

Here is the tg3 patch again that illustrates the idea. The patch changes 
only the ->poll() routine; note how the netif_rx_complete() call is delayed.

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 710dccc..59e151b 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -3473,6 +3473,24 @@ static int tg3_poll(struct napi_struct *napi,
      struct tg3_hw_status *sblk = tp->hw_status;
      int work_done = 0;

+    /* fastpath having no work while we're holding ourself in
+     * polled mode
+     */
+    if ((tp->exit_poll_time) && (!tg3_has_work(tp))) {
+        if (time_after(jiffies, tp->exit_poll_time)) {
+            tp->exit_poll_time = 0;
+            /* tell net stack and NIC we're done */
+            netif_rx_complete(netdev, napi);
+            tg3_restart_ints(tp);
+        }
+        return 0;
+    }
+
+    /* if we get here, there might be work to do so disable the
+     * poll hold fastpath above
+     */
+    tp->exit_poll_time = 0;
+
      /* handle link change and other phy events */
      if (!(tp->tg3_flags &
            (TG3_FLAG_USE_LINKCHG_REG |
@@ -3511,11 +3529,11 @@ static int tg3_poll(struct napi_struct *napi,
      } else
          sblk->status &= ~SD_STATUS_UPDATED;

-    /* if no more work, tell net stack and NIC we're done */
-    if (!tg3_has_work(tp)) {
-        netif_rx_complete(netdev, napi);
-        tg3_restart_ints(tp);
-    }
+    /* if no more work, set the time in jiffies when we should
+     * exit polled mode
+     */
+    if (!tg3_has_work(tp))
+        tp->exit_poll_time = jiffies + 2;

      return work_done;
  }
diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index a6a23bb..a0d24d3 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2163,6 +2163,7 @@ struct tg3 {
      u32                last_tag;

      u32                msg_enable;
+    unsigned long            exit_poll_time;

      /* begin "tx thread" cacheline section */
      void                (*write32_tx_mbox) (struct tg3 *, u32,


-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

