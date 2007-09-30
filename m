Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbXI3XCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbXI3XCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXI3XCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:02:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46141 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbXI3XCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:02:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 30 Sep 2007 16:02:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
In-Reply-To: <20070930163102.GA374@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0709301549160.19355@alien.or.mcafeemobile.com>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
 <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru>
 <20070924001509.GG11123@linux.vnet.ibm.com> <20070926151351.GA328@tv-sign.ru>
 <20070927154652.GE16652@linux.vnet.ibm.com> <20070928144714.GA397@tv-sign.ru>
 <20070928185759.GC9153@linux.vnet.ibm.com> <20070930163102.GA374@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007, Oleg Nesterov wrote:

> Ah, but I asked the different question. We must see CPU 1's stores by
> definition, but what about CPU 0's stores (which could be seen by CPU 1)?
> 
> Let's take a "real life" example,
> 
>                 A = B = X = 0;
>                 P = Q = &A;
> 
> CPU_0           CPU_1           CPU_2
> 
> P = &B;         *P = 1;         if (X) {
>                 wmb();                  rmb();
>                 X = 1;                  BUG_ON(*P != 1 && *Q != 1);
>                                 }
> 
> So, is it possible that CPU_1 sees P == &B, but CPU_2 sees P == &A ?

That can't be. CPU_2 sees X=1, that happened after (or same time at most - 
from a cache inv. POV) to *P=1, that must have happened after P=&B (in 
order for *P to assign B). So P=&B happened, from a pure time POV, before 
the rmb(), and the rmb() should guarantee that CPU_2 sees P=&B too.



- Davide


