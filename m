Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbXDCG0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbXDCG0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXDCG0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:26:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXDCG0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:26:43 -0400
Date: Tue, 3 Apr 2007 08:26:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ayaz Abdulla <AAbdulla@nvidia.com>
Cc: akpm@linux-foundation.org, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] forcedeth: work around NULL skb dereference crash
Message-ID: <20070403062629.GA13210@elte.hu>
References: <20070402115325.GA945@elte.hu> <DBFABB80F7FD3143A911F9E6CFD477B0189CB20B@hqemmail02.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBFABB80F7FD3143A911F9E6CFD477B0189CB20B@hqemmail02.nvidia.com>
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


* Ayaz Abdulla <AAbdulla@nvidia.com> wrote:

> I had responded eariler to the thread asking you to try out the patch
> found in bug 8058:
> http://bugzilla.kernel.org/show_bug.cgi?id=8058
> 
> I believe that is the caush of the NULL skb dereference issue.

there's a different type of regression now: under high load i dont get a 
crash, i get a hung interface instead. No error packets or other weird 
interface state - just a hung interface. The condition happens after a 
stream of:

 eth1: too many iterations (6) in nv_nic_irq.
 eth1: too many iterations (6) in nv_nic_irq.
 eth1: too many iterations (6) in nv_nic_irq.
 eth1: too many iterations (6) in nv_nic_irq.
 eth1: too many iterations (6) in nv_nic_irq.

If i increase max_interrupt_work from 5 to 50 to paper over this 
condition then the hangs go away. So i suspect there might still be a 
queue-wakeup problem in one of these paths - or that a filled up tx ring 
somehow gets stuck. (and i've got commits 3ba4d093fe8a26f and 
fcc5f2665c81e08, so all the latest stuff that is upstream at the moment)

	Ingo
