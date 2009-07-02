Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZGBOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZGBOFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZGBOFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:05:20 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60325 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZGBOFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:05:19 -0400
Message-ID: <4A4CBE7D.2060603@gmail.com>
Date: Thu, 02 Jul 2009 16:04:45 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: [GIT]: Networking
References: <20090630.213927.180401151.davem@davemloft.net> <20090702075724.GA10608@elte.hu> <4A4C9125.8020705@gmail.com>
In-Reply-To: <4A4C9125.8020705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 02 Jul 2009 16:04:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Ingo Molnar a écrit :
>>> The following changes since commit 52989765629e7d182b4f146050ebba0abf2cb0b7:
>>>   Linus Torvalds (1):
>>>         Merge git://git.kernel.org/.../davem/net-2.6
>>>
>>> are available in the git repository at:
>>>
>>>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
>> Hm, something in this lot quickly wrecked networking here - see the 
>> tx timeout dump below. It starts with:
>>
>> [  351.004596] WARNING: at net/sched/sch_generic.c:246 dev_watchdog+0x10b/0x19c()
>> [  351.011815] Hardware name: System Product Name
>> [  351.016220] NETDEV WATCHDOG: eth0 (forcedeth): transmit queue 0 timed out
>>
>> Config attached. Unfortunately i've got no time to do bisection 
>> today.
> 
> 
> 
> forcedeth might have a problem, in its netif_wake_queue() logic, but
> I could not see why a recent patch could make this problem visible now.
> 
> CPU0/1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
> is not a new cpu either :)
> 
> forcedeth uses an internal tx_stop without appropriate barrier.
> 
> Could you try following patch ?
> 
> (random guess as I dont have much time right now)

Oh well this patch was soooo stupid, sorry Ingo.


We might have a race in napi_schedule(), leaving interrupts disabled forever.
I cannot test this patch, I dont have the hardware...

Thanks

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 1094d29..3b4e076 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -3514,11 +3514,13 @@ static irqreturn_t nv_nic_irq(int foo, void *data)
 	nv_msi_workaround(np);
 
 #ifdef CONFIG_FORCEDETH_NAPI
-	napi_schedule(&np->napi);
-
-	/* Disable furthur irq's
-	   (msix not enabled with napi) */
-	writel(0, base + NvRegIrqMask);
+	if (napi_schedule_prep(&np->napi)) {
+		/*
+		 * Disable further irq's (msix not enabled with napi)
+		 */
+		writel(0, base + NvRegIrqMask);
+		__napi_schedule(&np->napi);
+	}
 
 #else
 	do
@@ -3615,12 +3617,13 @@ static irqreturn_t nv_nic_irq_optimized(int foo, void *data)
 	nv_msi_workaround(np);
 
 #ifdef CONFIG_FORCEDETH_NAPI
-	napi_schedule(&np->napi);
-
-	/* Disable furthur irq's
-	   (msix not enabled with napi) */
-	writel(0, base + NvRegIrqMask);
-
+	if (napi_schedule_prep(&np->napi)) {
+		/*
+		 * Disable further irq's (msix not enabled with napi)
+		 */
+		writel(0, base + NvRegIrqMask);
+		__napi_schedule(&np->napi);
+	}
 #else
 	do
 	{
