Return-Path: <linux-kernel-owner+w=401wt.eu-S1762455AbXEUVap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455AbXEUVap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXEUVai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:30:38 -0400
Received: from stinky.trash.net ([213.144.137.162]:64429 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbXEUVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:30:37 -0400
Message-ID: <46520F77.5000408@trash.net>
Date: Mon, 21 May 2007 23:30:31 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Anant Nitya <kernel@prachanda.info>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
References: <20070517174533.GA538@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu> <200705220110.14175.kernel@prachanda.hub> <20070521204606.GA4354@elte.hu> <465208D2.6070409@trash.net>
In-Reply-To: <465208D2.6070409@trash.net>
X-Enigmail-Version: 0.93.0.0
Content-Type: multipart/mixed;
 boundary="------------080900000505070604030108"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080900000505070604030108
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Ingo Molnar wrote:
> 
>>* Anant Nitya <kernel@prachanda.info> wrote:
>>
>>>I am posting links to the information you asked for. One more thing, 
>>>after digging a bit more I found its QoS shaping that is making the 
>>>box crawl. Once I disabled the traffic shaping everything comes back 
>>>to smooth and normal. Shaping being done on very low speed residential 
>>>ADSL 256/64 Kbps connection. If you want me to post shaping rules, 
>>>please free to ask. BTW its a simple HTB/SFQ rules.
>>
>>[...]
>>
>>
>>>http://cybertek.info/taitai/trace-to-ingo.txt.bz2
>>
>>
>>thanks! This trace indeed includes the smoking gun, htb_dequeue() and 
>>__qdisc_run():
>>
>>[..]
> 
> This looks like fallout from the switch to hrtimers. Anant, please
> send me your HTB script, I'll try to reproduce it.


I think I already found the bug, please try if this patch helps.


--------------080900000505070604030108
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NET_SCHED]: sch_htb: fix event cache time calculation

The event cache time must be an absolute value, when no event exists it is
incorrectly set to 1s instead of 1s in the future.

Should fix excessive load reported by Anant Nitya <kernel@prachanda.info>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 49d1023ea0ea8377e740123d5954e88a00f78b7c
tree 031c210f1b5e37ade5a4fa519f5808cd49225b89
parent 637fc540b0ad22bf7971929e906e704236af06cd
author Patrick McHardy <kaber@trash.net> Mon, 21 May 2007 23:24:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 May 2007 23:25:51 +0200

 net/sched/sch_htb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 99bcec8..035788c 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -976,8 +976,9 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
 
 		if (q->now >= q->near_ev_cache[level]) {
 			event = htb_do_events(q, level);
-			q->near_ev_cache[level] = event ? event :
-							  PSCHED_TICKS_PER_SEC;
+			if (!event)
+				event = q->now + PSCHED_TICKS_PER_SEC;
+			q->near_ev_cache[level] = event;
 		} else
 			event = q->near_ev_cache[level];
 

--------------080900000505070604030108--
