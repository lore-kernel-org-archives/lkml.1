Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYBYUfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYBYUfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYBYUfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:35:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:35839 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754077AbYBYUfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:35:44 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+Ad/AAlX2Aj61bezQQDTvIQ/lHSeYVZY0Blcy3lr
	msDIp9VU7tCWLQ
Date: Mon, 25 Feb 2008 21:35:41 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Message-ID: <20080225203541.GA24200@atjola.homenet>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47C32043.6090809@pobox.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.02.25 15:08:35 -0500, Jeff Garzik wrote:
> Björn Steinbrink wrote:
>> Hm, do you have lockdep enabled? If not, does lockdep make this go away?
>> Because lockdep will set IRQF_DISABLED for all interrupt handlers, and
>> unless that flag is set, handle_IRQ_event will reenable interrupts while
>> the handler is running. And ahci_interrupt only uses a plain spin_lock,
>> so interrupts keep being enabled. The patch below should help with that.
>>
>> Hmhm, maybe that also solves the deadlock you saw? Dunno...
>>
>> I can't come up with an useful commit message right now, but I'll resend
>> in suitable form for submission if that thing actually works.
>>
>> Björn
>>
>>
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index 1db93b6..ae3dbc8 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -1739,6 +1739,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
>>  	unsigned int i, handled = 0;
>>  	void __iomem *mmio;
>>  	u32 irq_stat, irq_ack = 0;
>> +	unsigned long flags;
>>   	VPRINTK("ENTER\n");
>>  @@ -1751,7 +1752,7 @@ static irqreturn_t ahci_interrupt(int irq, void 
>> *dev_instance)
>>  	if (!irq_stat)
>>  		return IRQ_NONE;
>>  -	spin_lock(&host->lock);
>> +	spin_lock_irqsave(&host->lock, flags);
>>   	for (i = 0; i < host->n_ports; i++) {
>>  		struct ata_port *ap;
>> @@ -1778,7 +1779,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
>>  		handled = 1;
>>  	}
>>  -	spin_unlock(&host->lock);
>> +	spin_unlock_irqrestore(&host->lock, flags);
>
> If this truly fixes the problem, then lockdep is definitely the problem  
> source.

Hm, lockdep keeps the interrupts _disabled_. The code that reenables the
interrupts was already in the first revision of Linus' git tree. So
lockdep would actually just hide the problem, not cause it.

Björn
