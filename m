Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXDCHFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXDCHFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXDCHFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:05:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbXDCHFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:05:34 -0400
Date: Tue, 3 Apr 2007 09:05:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ayaz Abdulla <AAbdulla@nvidia.com>
Cc: akpm@linux-foundation.org, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: [bug] forcedeth: hung interface under load
Message-ID: <20070403070514.GA22940@elte.hu>
References: <20070402115325.GA945@elte.hu> <DBFABB80F7FD3143A911F9E6CFD477B0189CB20B@hqemmail02.nvidia.com> <20070403062629.GA13210@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403062629.GA13210@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> > I had responded eariler to the thread asking you to try out the patch
> > found in bug 8058:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8058
> > 
> > I believe that is the caush of the NULL skb dereference issue.
> 
> there's a different type of regression now: under high load i dont get 
> a crash, i get a hung interface instead. No error packets or other 
> weird interface state - just a hung interface. [...]

the interface stats do not change from that point on:

eth1      Link encap:Ethernet  HWaddr 00:13:D4:DC:41:12
          inet addr:10.0.1.12  Bcast:10.0.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:14976 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3928743 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1028544 (1004.4 KiB)  TX bytes:4126766510 (3.8 GiB)
          Interrupt:16 Base address:0xa000

and the irq count does not change either:

 16:        816    3463148   IO-APIC-fasteoi   eth1

no matter what i do to the interface. So it's completely stuck. 
No kernel messages either - apparently nv_tx_timeout() never triggered.

note, the hang occurs faster if you set max_interrupt_work to a really 
low value (such as 0). [ The hang occurs _much_ faster if you apply the 
-rt patch and enable PREEMPT_RT - but the hang occurs on mainline too. ]

	Ingo
