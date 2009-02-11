Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbZBKNWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbZBKNWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZBKNWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:22:23 -0500
Received: from homer.mvista.com ([63.81.120.155]:5989 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750760AbZBKNWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:22:22 -0500
Message-ID: <4992D108.2070709@ru.mvista.com>
Date: Wed, 11 Feb 2009 16:22:16 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] ide: remove ide_execute_pkt_cmd()
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090209232019.32406.98822.sendpatchset@localhost.localdomain> <20090211065535.GC937@gollum.tnic>
In-Reply-To: <20090211065535.GC937@gollum.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Subject: [PATCH] ide: remove ide_execute_pkt_cmd()
>>
>> * Pass command structure to ide_execute_command() and skip
>>   __ide_set_handler() for ATAPI protocols.
>>
>> * Convert ide_issue_pc() to always use ide_execute_command()
>>   and remove no longer needed ide_execute_pkt_cmd().
>>
>> There should be no functional changes caused by this patch.
>>
>> Cc: Borislav Petkov <petkovbb@gmail.com>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> ---
>>  drivers/ide/ide-atapi.c    |   15 +++++++--------
>>  drivers/ide/ide-iops.c     |   23 ++++++-----------------
>>  drivers/ide/ide-taskfile.c |    6 ++----
>>  include/linux/ide.h        |    5 ++---
>>  4 files changed, 17 insertions(+), 32 deletions(-)
>>
>> Index: b/drivers/ide/ide-atapi.c
>> ===================================================================
>> --- a/drivers/ide/ide-atapi.c
>> +++ b/drivers/ide/ide-atapi.c
>> @@ -481,6 +481,7 @@ static void ide_init_packet_cmd(struct i
>>  	cmd->protocol  = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
>>  	cmd->tf_flags |= IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
>>  			 IDE_TFLAG_OUT_FEATURE | tf_flags;
>> +	cmd->tf.command = ATA_CMD_PACKET;
>>  	cmd->tf.feature = dma;		/* Use PIO/DMA */
>>  	cmd->tf.lbam    = bcount & 0xff;
>>  	cmd->tf.lbah    = (bcount >> 8) & 0xff;
>> @@ -626,6 +627,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>>  	unsigned int timeout;
>>  	u32 tf_flags;
>>  	u16 bcount;
>> +	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
>>     
>
> How about we finally add those check macros in block layer fashion like
> blk_pc_request et al and do
>
> #define drv_can_drq_interrupt(drive)	((drive)->atapi_flags &	IDE_AFLAG_DRQ_INTERRUPT)
>   

   I suppose it's for the devices that interrupt on packet DRQ? Then 
it's hardly a good name because it's not like this is some optional 
capability.

> ...
>
>
> or similar instead of wasting stack space?

   It doesn't necessarily waste stack space. Haven't you heard about 
compiler putting local vairables into registers?

> It'll also read better in the if() check:
>
> if (drv_can_irq_interrupt(drive)) { ...
>   

   It's faster to checj a local variable than to dereference drv several 
times -- unless gcc optimizes that away (by creating an implicit local 
variable :-).

> If it's ok with you, I'll whip up patch(es) later.
>   

>>   	if (dev_is_idecd(drive)) {
>>  		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
>> @@ -675,17 +677,14 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>>     

   Don't leave uncommented fragment behind please.

MBR, Sergei


>>  
>>  	(void)do_rw_taskfile(drive, cmd);
>>  
>> -	/* Issue the packet command */
>> -	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
>> +	if (drq_int) {
>>  		if (drive->dma)
>>  			drive->waiting_for_dma = 0;
>>  		hwif->expiry = expiry;
>> -		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
>> -				    timeout);
>> -		return ide_started;
>> -	} else {
>> -		ide_execute_pkt_cmd(drive);
>> -		return ide_transfer_pc(drive);
>>  	}
>> +
>> +	ide_execute_command(drive, cmd, ide_transfer_pc, timeout);
>> +
>> +	return drq_int ? ide_started : ide_transfer_pc(drive);
>>  }
>>  EXPORT_SYMBOL_GPL(ide_issue_pc);
>> Index: b/drivers/ide/ide-iops.c
>> ===================================================================
>> --- a/drivers/ide/ide-iops.c
>> +++ b/drivers/ide/ide-iops.c
>> @@ -451,7 +451,7 @@ EXPORT_SYMBOL(ide_set_handler);
>>  /**
>>   *	ide_execute_command	-	execute an IDE command
>>   *	@drive: IDE drive to issue the command against
>> - *	@command: command byte to write
>> + *	@cmd: command
>>   *	@handler: handler for next phase
>>   *	@timeout: timeout for command
>>   *
>> @@ -461,15 +461,16 @@ EXPORT_SYMBOL(ide_set_handler);
>>   *	should go via this function or do equivalent locking.
>>   */
>>  
>> -void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
>> -			 unsigned timeout)
>> +void ide_execute_command(ide_drive_t *drive, struct ide_cmd *cmd,
>> +			 ide_handler_t *handler, unsigned timeout)
>>  {
>>  	ide_hwif_t *hwif = drive->hwif;
>>  	unsigned long flags;
>>  
>>  	spin_lock_irqsave(&hwif->lock, flags);
>> -	__ide_set_handler(drive, handler, timeout);
>> -	hwif->tp_ops->exec_command(hwif, cmd);
>> +	if (cmd->protocol != ATAPI_PROT_DMA && cmd->protocol != ATAPI_PROT_PIO)
>> +		__ide_set_handler(drive, handler, timeout);
>> +	hwif->tp_ops->exec_command(hwif, cmd->tf.command);
>>  	/*
>>  	 * Drive takes 400nS to respond, we must avoid the IRQ being
>>  	 * serviced before that.
>> @@ -480,18 +481,6 @@ void ide_execute_command(ide_drive_t *dr
>>  	spin_unlock_irqrestore(&hwif->lock, flags);
>>  }
>>  
>> -void ide_execute_pkt_cmd(ide_drive_t *drive)
>> -{
>> -	ide_hwif_t *hwif = drive->hwif;
>> -	unsigned long flags;
>> -
>> -	spin_lock_irqsave(&hwif->lock, flags);
>> -	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
>> -	ndelay(400);
>> -	spin_unlock_irqrestore(&hwif->lock, flags);
>> -}
>> -EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
>> -
>>  /*
>>   * ide_wait_not_busy() waits for the currently selected device on the hwif
>>   * to report a non-busy status, see comments in ide_probe_port().
>> Index: b/drivers/ide/ide-taskfile.c
>> ===================================================================
>> --- a/drivers/ide/ide-taskfile.c
>> +++ b/drivers/ide/ide-taskfile.c
>> @@ -97,8 +97,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
>>  	case ATA_PROT_NODATA:
>>  		if (handler == NULL)
>>  			handler = task_no_data_intr;
>> -		ide_execute_command(drive, tf->command, handler,
>> -				    WAIT_WORSTCASE);
>> +		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
>>  		return ide_started;
>>  	case ATA_PROT_DMA:
>>  		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
>> @@ -106,8 +105,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
>>  		    dma_ops->dma_setup(drive, cmd))
>>  			return ide_stopped;
>>  		hwif->expiry = dma_ops->dma_expiry;
>> -		ide_execute_command(drive, tf->command, ide_dma_intr,
>> -				    2 * WAIT_CMD);
>> +		ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD);
>>  		dma_ops->dma_start(drive);
>>  	default:
>>  		return ide_started;
>> Index: b/include/linux/ide.h
>> ===================================================================
>> --- a/include/linux/ide.h
>> +++ b/include/linux/ide.h
>> @@ -1135,9 +1135,8 @@ void ide_kill_rq(ide_drive_t *, struct r
>>  void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
>>  void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
>>  
>> -void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int);
>> -
>> -void ide_execute_pkt_cmd(ide_drive_t *);
>> +void ide_execute_command(ide_drive_t *, struct ide_cmd *, ide_handler_t *,
>> +			 unsigned int);
>>  
>>  void ide_pad_transfer(ide_drive_t *, int, int);
>>  
>>     
>
>   

