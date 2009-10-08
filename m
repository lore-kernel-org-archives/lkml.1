Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbZJHRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbZJHRDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbZJHRDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:03:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39211 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752AbZJHRDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:03:40 -0400
Message-ID: <4ACE1B3E.6060402@us.ibm.com>
Date: Thu, 08 Oct 2009 10:02:54 -0700
From: Vernon Mauery <vernux@us.ibm.com>
Reply-To: vernux@us.ibm.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RT] kill the bnx2x pulse in the -rt tree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove pulse code from the bnx2x driver

We are still seeing pulse mismatch error messages while running
daEth on the receiver.  Here is another go that should fix it for
sure.  The pulse mismatch errors cause the interface to go out
to lunch until the machine is rebooted.

Reasoning for this is from the driver maintainer, Eilon Greenstein:
A possible work around is to remove the pulse section from the
timer - everything will work just fine without it. It is there
to allow the FW to take control over the link incase the driver
died unexpectedly, but since you are not using NCSI (or any other
management protocol on this interface) - you don't really need it.

Built and tested against 2.6.31.1-rt12 kernel.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>

diff -X dontdiff -Nuarp a/drivers/net/bnx2x_main.c b/drivers/net/bnx2x_main.c
--- a/drivers/net/bnx2x_main.c	2009-10-08 14:14:09.000000000 -0400
+++ b/drivers/net/bnx2x_main.c	2009-10-08 16:06:03.000000000 -0400
@@ -4188,6 +4188,7 @@ static void bnx2x_timer(unsigned long da
 		rc = bnx2x_rx_int(fp, 1000);
 	}

+#ifndef CONFIG_PREEMPT_RT
 	if (!BP_NOMCP(bp)) {
 		int func = BP_FUNC(bp);
 		u32 drv_pulse;
@@ -4211,6 +4212,7 @@ static void bnx2x_timer(unsigned long da
 				  drv_pulse, mcp_pulse);
 		}
 	}
+#endif /* CONFIG_PREEMPT_RT */

 	if ((bp->state == BNX2X_STATE_OPEN) ||
 	    (bp->state == BNX2X_STATE_DISABLED))
@@ -6118,6 +6120,7 @@ static int bnx2x_init_hw(struct bnx2x *b
 		break;
 	}

+#ifndef CONFIG_PREEMPT_RT
 	if (!BP_NOMCP(bp)) {
 		int func = BP_FUNC(bp);

@@ -6128,6 +6131,7 @@ static int bnx2x_init_hw(struct bnx2x *b
 		DP(BNX2X_MSG_MCP, "drv_pulse 0x%x  func_stx 0x%x\n",
 		   bp->fw_drv_pulse_wr_seq, bp->func_stx);
 	} else
+#endif /* CONFIG_PREEMPT_RT */
 		bp->func_stx = 0;

 	/* this needs to be done before gunzip end */
@@ -7196,8 +7200,10 @@ static int bnx2x_nic_unload(struct bnx2x
 	bnx2x_netif_stop(bp, 1);

 	del_timer_sync(&bp->timer);
+#ifndef CONFIG_PREEMPT_RT
 	SHMEM_WR(bp, func_mb[BP_FUNC(bp)].drv_pulse_mb,
 		 (DRV_PULSE_ALWAYS_ALIVE | bp->fw_drv_pulse_wr_seq));
+#endif /* CONFIG_PREEMPT_RT */
 	bnx2x_stats_handle(bp, STATS_EVENT_STOP);

 	/* Release IRQs */
