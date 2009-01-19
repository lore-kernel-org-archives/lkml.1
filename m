Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZASHEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZASHEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 02:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZASHEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 02:04:34 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:54793 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZASHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 02:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lsu51G1A4QcEINAftudqsz/Vv3GrSB4CF+TDkdyrrMJiZUoChYvVyoZpaHF5Qnjvzg
         k3EMT33UfLz4zNtf0mS5f6znwR+PdV653zfJdORxEpSlB8LcFi40Kx71LsXNlfm4MUXT
         lKaevbuxKvW6Fom3KSqc/b6jDzvlPKRd+NJmQ=
Date: Mon, 19 Jan 2009 06:57:15 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ccaputo@alt.net, a.p.zijlstra@chello.nl, denys@visp.net.lb,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       slavon@bigtelecom.ru, tglx@linutronix.de
Subject: [PATCH] Re: deadlocks if use htb
Message-ID: <20090119065715.GA4197@ff.dom.local>
References: <1231937404.14825.4.camel@laptop> <Pine.LNX.4.64.0901141748300.17915@nacho.alt.net> <20090115065322.GA4190@ff.dom.local> <20090118.214604.221247372.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118.214604.221247372.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 09:46:04PM -0800, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Thu, 15 Jan 2009 06:53:22 +0000
> 
> > (resend testing patch #4 - for 2.6.27 or 2.6.28)
> 
> Jarek, if you deem that this is in fact what we should
> submit for -stable please give me a submission with
> a suitable commit message and signoffs, and I will queue
> it up for -stable.

It looks like this should be needed, but I think it's better to wait
2 or 3 days for "Tested-by" from Denys and/or maybe Vyacheslav yet.
(I hoped they would rather test some hrtimers patch, but it looks like
Peter was busy.)

Thanks,
Jarek P.
-----------------> (needed only for -stables: 2.6.28 and older)

pkt_sched: sch_htb: Fix deadlock in hrtimers triggered by HTB

Most probably there is a (still unproven) race in hrtimers (before
2.6.29 kernels), which causes a corruption of hrtimers rbtree. This
patch doesn't fix it, but should let HTB avoid triggering the bug.

Reported-by: Denys Fedoryschenko <denys@visp.net.lb>
Reported-by: Badalian Vyacheslav <slavon@bigtelecom.ru>
Reported-by: Chris Caputo <ccaputo@alt.net>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

diff -Nurp a2.6.27.7/net/sched/sch_htb.c b2.6.27.7/net/sched/sch_htb.c
--- a2.6.27.7/net/sched/sch_htb.c	2008-12-11 08:16:16.000000000 +0000
+++ b2.6.27.7/net/sched/sch_htb.c	2008-12-15 10:44:32.000000000 +0000
@@ -924,6 +924,7 @@ static struct sk_buff *htb_dequeue(struc
 		}
 	}
 	sch->qstats.overlimits++;
+	qdisc_watchdog_cancel(&q->watchdog);
 	qdisc_watchdog_schedule(&q->watchdog, next_event);
 fin:
 	return skb;
