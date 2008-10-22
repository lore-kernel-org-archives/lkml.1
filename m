Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYJVHC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYJVHC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYJVHCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:02:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:11535 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYJVHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ab2BoRE9fbS2lkS1OBBk9+A9Tzzv0aHX1kUFnJHvF6GS6sEYLkoGlL/FfYD3+u23LZ
         OnVR1dhdxpVwV/RKeKa2YWfispbgdC7ot4e0E+jFnhd5VpDC/JJauV8uq81ySDhHH41b
         P/tfuKpw8c4gDMgQPv+mzfyZosryonl0jTncA=
Date: Wed, 22 Oct 2008 07:02:00 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: deadlocks if use htb
Message-ID: <20081022070200.GB4178@ff.dom.local>
References: <20081010075640.GA5204@ff.dom.local> <48EF17EA.5020306@bigtelecom.ru> <20081010090426.GA6054@ff.dom.local> <20081010095129.GB6054@ff.dom.local> <48F6FB3E.7060903@bigtelecom.ru> <20081016084027.GA17632@ff.dom.local> <48FEC302.5090707@bigtelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FEC302.5090707@bigtelecom.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 10:06:58AM +0400, Badalian Vyacheslav wrote:
> Hello!
Hi!

> I get more information.
> 
> Statistics of PC:
> 1. 2.6.26.6 Dunamic Timer, HiResTimer, 1000HZ, htb_hysteresis=0 -
> crashed 1d 18h ago
> 2. 2.6.26.5 HZ300, NO Dunamic Timer, No HiResTimer, htb_hysteresis=0 -
> uptime 5d 17h (no crashes for now, but it crashed some time ago with
> htb_hysteresis=1)

So it looks like htb_hysteresis change could be not enough, and it's
a pity because this could be easiest to "reverse" in the kernel.

> 3. 2.6.27, 1000HZ, NO Dunamic Timer, No HiResTimer, htb_hysteresis=0 +
> PATCH - uptime 5d 17h (no crashes for now, but it crashed some time ago
> without patch)

So I guess this patch seems to make some difference, but it also could
be hard to convince people to fix it this way, because it makes
scheduling less exact.

Alas I have still no idea of the real reason. IMHO this should be 
rather debugged by hrtimers/NMI people, but there were no respose last
time I Cc-ed them - anyway I added linux-kernel to Cc again here.

I attach below a slightly modified version of the previous patch,
which lets for more exact scheduling, but could be more vulnerable for
this bug. Alas, even if it works, it still could be not the final
solution of this problem.

> Also attach crash log of lash crash PC 1:
> 
> [10610.110729] BUG: NMI Watchdog detected LOCKUP on CPU1, ip c01fd939,
> registers:
> [10610.110729] Modules linked in: netconsole e1000e i2c_i801 i2c_core e1000
> [10610.110729]
> [10610.110729] Pid: 0, comm: swapper Not tainted (2.6.26.6-fw #1)
> [10610.110729] EIP: 0060:[<c01fd939>] EFLAGS: 00000082 CPU: 1
> [10610.110729] EIP is at rb_insert_color+0x19/0xc0

Thanks,
Jarek P.

--- (testing patch #2)

 net/sched/sch_htb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 30c999c..ff9e965 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -162,6 +162,7 @@ struct htb_sched {
 
 	int rate2quantum;	/* quant = rate / rate2quantum */
 	psched_time_t now;	/* cached dequeue time */
+	psched_time_t next_watchdog;
 	struct qdisc_watchdog watchdog;
 
 	/* non shaped skbs; let them go directly thru */
@@ -920,7 +921,11 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
 		}
 	}
 	sch->qstats.overlimits++;
-	qdisc_watchdog_schedule(&q->watchdog, next_event);
+	if (q->next_watchdog < q->now || next_event <=
+	     q->next_watchdog - PSCHED_TICKS_PER_SEC / (10 * HZ)) {
+		qdisc_watchdog_schedule(&q->watchdog, next_event);
+		q->next_watchdog = next_event;
+	}
 fin:
 	return skb;
 }
@@ -973,6 +978,7 @@ static void htb_reset(struct Qdisc *sch)
 		}
 	}
 	qdisc_watchdog_cancel(&q->watchdog);
+	q->next_watchdog = 0;
 	__skb_queue_purge(&q->direct_queue);
 	sch->q.qlen = 0;
 	memset(q->row, 0, sizeof(q->row));
