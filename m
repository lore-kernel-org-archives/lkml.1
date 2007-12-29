Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXL2MLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXL2MLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXL2MLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:11:14 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:26167 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbXL2MLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:11:13 -0500
X-Trace: 647134876/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.80
X-SBRS: None
X-RemoteIP: 81.1.89.80
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAOfHdUdRAVlQ/2dsb2JhbACBV49ImxU
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1198929826.6278.11.camel@localhost.localdomain>
References: <1198774339.6170.11.camel@localhost.localdomain>
	 <1198796281.4833.31.camel@localhost>  <1198801142.5354.67.camel@odie>
	 <1198893469.4861.9.camel@localhost>
	 <1198929826.6278.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 12:10:47 +0000
Message-Id: <1198930247.6278.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 12:03 +0000, Adrian McMenamin wrote:
> On Fri, 2007-12-28 at 17:57 -0800, Joe Perches wrote:
> 
> > 
> > Perhaps (uncompiled/untested):
> > 
> >     Remove unnecessary parenthesis
> >     Remove GDROM: prefix from sense_texts
> >     Add function gdrom_data_request
> >     Check sense_key against sense_text array size
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/cdrom/gdrom.c |   53 ++++++++++++++++++++++++++----------------------
> >  1 files changed, 29 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> > index 59d26e0..ab95438 100644
> > --- a/drivers/cdrom/gdrom.c
> > +++ b/drivers/cdrom/gdrom.c
> > @@ -80,16 +80,15 @@ static const struct {
> >  	int sense_key;
> >  	const char * const text;
> >  } sense_texts[] = {
> > -	{NO_SENSE, "GDROM: OK"},
> > -	{RECOVERED_ERROR, "GDROM: Recovered from error"},
> > -	{NOT_READY, "GDROM: Device not ready"},
> > -	{MEDIUM_ERROR, "GDROM: Disk not ready"},
> > -	{HARDWARE_ERROR, "GDROM: Hardware error"},
> > -	{ILLEGAL_REQUEST, "GDROM: Command has failed"},
> > -	{UNIT_ATTENTION, "GDROM: Device needs attention - "
> > -			 "disk may have been changed"},
> > -	{DATA_PROTECT, "GDROM: Data protection error"},
> > -	{ABORTED_COMMAND, "GDROM: Command aborted"},
> > +	{NO_SENSE, "OK"},
> > +	{RECOVERED_ERROR, "Recovered from error"},
> > +	{NOT_READY, "Device not ready"},
> > +	{MEDIUM_ERROR, "Disk not ready"},
> > +	{HARDWARE_ERROR, "Hardware error"},
> > +	{ILLEGAL_REQUEST, "Command has failed"},
> > +	{UNIT_ATTENTION, "Device needs attention - disk may have been changed"},
> > +	{DATA_PROTECT, "Data protection error"},
> > +	{ABORTED_COMMAND, "Command aborted"},
> >  };
> 
> >  
> >  /* reset the G1 bus */
> > @@ -412,11 +416,13 @@ static int gdrom_getsense(short *bufstring)
> >  		return -EIO;
> >  	}
> >  	sense_key = sense[1] & 0x0F;
> > -	printk(KERN_INFO "%s\n", sense_texts[sense_key].text);
> > +	if (sense_key < ARRAY_SIZE(sense_texts))
> > +		printk(KERN_INFO "GDROM: %s\n", sense_texts[sense_key].text);
> > +	else
> > +		printk(KERN_ERR "GDROM: Unknown sense key: %d\n", sense_key);
> >  
> > -	if (bufstring)
> > +	if (bufstring)			/* return additional sense data */
> >  		memcpy(bufstring, &sense[4], 2);
> > -					/* return additional sense data */
> >  
> >  	if (sense_key < 2)
> >  		return 0;
> > @@ -550,19 +556,18 @@ static void gdrom_readdisk_dma(struct work_struct *work)
> >  		ctrl_outb(0, GDROM_INTSEC_REG);
> >  		/* In multiple DMA transfers need to wait */
> >  		timeout = jiffies + HZ / 2;
> > -		while (gdrom_is_busy() && (time_before(jiffies, timeout)))
> > +		while (gdrom_is_busy() && time_before(jiffies, timeout))
> >  			cpu_relax();
> >  		ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> >  		timeout = jiffies + HZ / 2;
> > -		while (((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8) &&
> > -		       (time_before(jiffies, timeout)))
> > -			cpu_relax(); /* wait for DRQ to be set to 1 */
> > +		while (!gdrom_data_request() && time_before(jiffies, timeout))
> > +			cpu_relax();
> >  		gd.pending = 1;
> >  		gd.transfer = 1;
> >  		outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
> >  		timeout = jiffies + HZ / 2;
> > -		while ((ctrl_inb(GDROM_DMA_STATUS_REG)) &&
> > -		       (time_before(jiffies, timeout)))
> > +		while (ctrl_inb(GDROM_DMA_STATUS_REG) &&
> > +		       time_before(jiffies, timeout))
> >  			cpu_relax();
> >  		ctrl_outb(1, GDROM_DMA_STATUS_REG);
> >  		/* 5 second error margin here seems more reasonable */
> > 
> > 
> > -
> 
> 
> This won't work see include/scsi/scsi.h
> 
> 
> /*
> *  SENSE KEYS
> */
> 
> #define NO_SENSE            0x00
> #define RECOVERED_ERROR     0x01
> #define NOT_READY           0x02
> #define MEDIUM_ERROR        0x03
> #define HARDWARE_ERROR      0x04
> #define ILLEGAL_REQUEST     0x05
> #define UNIT_ATTENTION      0x06
> #define DATA_PROTECT        0x07
> #define BLANK_CHECK         0x08
> #define COPY_ABORTED        0x0a
> #define ABORTED_COMMAND     0x0b
> #define VOLUME_OVERFLOW     0x0d
> #define MISCOMPARE          0x0e
> 
> (The GD device specs says it supports 0, 1, 2, 3,4, 5, 6, 7 and 0xB)
> 
> ie we could get a sense key of 0x0B which would be greater than the
> array size. I think you'd have to hard code the limit.
> 
> 
Ignore that. Talking rubbish. As usual.

