Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZAFAdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZAFAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbZAFAdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:33:09 -0500
Received: from main.gmane.org ([80.91.229.2]:45358 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZAFAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:33:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
Date: Mon, 05 Jan 2009 18:32:52 -0600
Message-ID: <4962A6B4.7060309@shaw.ca>
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com> <49628964.806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <49628964.806@gmail.com>
Cc: orinoco-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 01/05/2009 09:32 PM, Dave wrote:
>> --- a/drivers/net/wireless/orinoco/orinoco.c
>> +++ b/drivers/net/wireless/orinoco/orinoco.c
>> @@ -1616,9 +1616,15 @@ static void orinoco_rx_isr_tasklet(unsigned long
>> data)
>>
>>         /* extract desc and skb from queue */
>>         list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
>> +               unsigned long flags;
>> +
>>                 desc = rx_data->desc;
>>                 skb = rx_data->skb;
>> +
>> +               local_irq_save(flags);
>>                 list_del(&rx_data->list);
>> +               local_irq_restore(flags);
>> +
> 
> Hi,
> 
> another processor still can see inconsistent state, spinlock should be taken.
> Or, am I missing something?

Think you're right, this should be spin_lock_irq or spin_lock_irqsave on 
some lock. Otherwise the interrupt could still occur on some other CPU 
and hit the race.

