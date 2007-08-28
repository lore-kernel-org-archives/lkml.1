Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbXH1U0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbXH1U0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXH1UZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:25:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbXH1UZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:25:55 -0400
Date: Tue, 28 Aug 2007 13:25:42 -0700 (PDT)
Message-Id: <20070828.132542.35016161.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708281321.10679.ossthema@de.ibm.com>
References: <46D2F301.7050105@katalix.com>
	<20070827.140251.95055210.davem@davemloft.net>
	<200708281321.10679.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Tue, 28 Aug 2007 13:21:09 +0200

> Problem for multi queue driver with interrupt distribution scheme set to
> round robin for this simple example:
> Assuming we have 2 SLOW CPUs. CPU_1 is under heavy load (applications). CPU_2
> is not under heavy load. Now we receive a lot of packets (high load situation).
> Receive queue 1 (RQ1) is scheduled on CPU_1. NAPI-Poll does not manage to empty
> RQ1 ever, so it stays on CPU_1. The second receive queue (RQ2) is scheduled on
> CPU_2. As that CPU is not under heavy load, RQ2 can be emptied, and the next IRQ
> for RQ2 will go to CPU_1. Then both RQs are on CPU_1 and will stay there if
> no IRQ is forced at some time as both RQs are never emptied completely.

Why would RQ2's IRQ move over to CPU_1?  That's stupid.

If you lock the IRQs to specific cpus, the load adjusts automatically.
Because packet work, in high load situations, will be processed via
ksoftirqd daemons even if the packet is not for a user application's
socket.

In such a case the scheduler will move the user applications that are
now not able to get their timeslices over to a less busy cpu.

If you keep moving the interrupts around, the scheduler cannot react
properly and it makes the situation worse.
