Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYCZCiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYCZCiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYCZCio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:38:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:65186 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYCZCin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:38:43 -0400
Message-ID: <47E9B72C.9030809@windriver.com>
Date: Wed, 26 Mar 2008 10:38:36 +0800
From: yshi <yang.shi@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B115.9060109@windriver.com> <47E9B39C.5010502@pobox.com>
In-Reply-To: <47E9B39C.5010502@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Mar 2008 02:38:31.0449 (UTC) FILETIME=[7AD77090:01C88EEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Thanks for the comment. According your suggestion, I added 
local_irq_save()/local_irq_restore() in rtl8139_netpoll_controller().
Move the burden to netpoll layer. The following is the modified patch:

Replaced disable_irq()/enable_irq() with
local_irq_save()/local_irq_restore() to improve
netconsole/netpoll support on RTL8139 NIC driver.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
---
 b/drivers/net/8139too.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
---

--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -2199,9 +2199,11 @@ static irqreturn_t rtl8139_interrupt (in
  */
 static void rtl8139_poll_controller(struct net_device *dev)
 {
-       disable_irq(dev->irq);
+       unsigned long flags;
+
+       local_irq_save(flags);
        rtl8139_interrupt(dev->irq, dev);
-       enable_irq(dev->irq);
+       local_irq_restore(flags);
 }
 #endif

Thanks.

Yang
Jeff Garzik 写道:
> yshi wrote:
>> In current RTL8139 NIC driver, spin_lock()/spin_unlock() is used
>> for irq handler. But for netconsole/netpoll, it prefers
>> spin_lock_irqsave()/spin_unlcok_irqrestore(). So this patch fixed
>> this problem to improve netconsole/netpoll support.
>>
>> Signed-off-by: Yang Shi <yang.shi@windriver.com>
>> ---
>> b/drivers/net/8139too.c |    9 +++++++++
>> 1 file changed, 9 insertions(+)
>> ---
>>
>> --- a/drivers/net/8139too.c
>> +++ b/drivers/net/8139too.c
>> @@ -2136,8 +2136,13 @@ static irqreturn_t rtl8139_interrupt (in
>>        u16 status, ackstat;
>>        int link_changed = 0; /* avoid bogus "uninit" warning */
>>        int handled = 0;
>> +#ifdef CONFIG_NET_POLL_CONTROLLER
>> +       unsigned long flags;
>>
>> +       spin_lock_irqsave (&tp->lock, flags);
>> +#else
>>        spin_lock (&tp->lock);
>> +#endif
>>        status = RTL_R16 (IntrStatus);
>>
>>        /* shared irq? */
>> @@ -2185,7 +2190,11 @@ static irqreturn_t rtl8139_interrupt (in
>>                        RTL_W16 (IntrStatus, TxErr);
>>        }
>>  out:
>> +#ifdef CONFIG_NET_POLL_CONTROLLER
>> +       spin_unlock_irqrestore (&tp->lock, flags);
>> +#else
>>        spin_unlock (&tp->lock);
>> +#endif
>
> This is bogus -- you should never need to slow down the hot path in 
> such a way.
>
> Add a local_irq_save()/restore() to rtl8139_poll_controller() or a 
> similar solution, putting the burden on the netpoll/netconsole layer.
>
>     Jeff
>
>
>
>

