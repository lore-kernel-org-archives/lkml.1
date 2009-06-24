Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbZFXTaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbZFXTaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761090AbZFXTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:30:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42721 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZFXTaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:30:07 -0400
Message-ID: <4A427EE0.8050901@garzik.org>
Date: Wed, 24 Jun 2009 15:30:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the
 IRQ context
References: <200906240336.25263.bzolnier@gmail.com> <20090624.025518.75726622.davem@davemloft.net> <200906241248.21173.bzolnier@gmail.com> <200906241304.14926.bzolnier@gmail.com>
In-Reply-To: <200906241304.14926.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 24 June 2009 12:48:20 Bartlomiej Zolnierkiewicz wrote:
> 
>>> 1) You want the device to be quiescent anyways when you do this
>>>    SET_XFER command.  What better way than to plug the queue
>>>    and make sure all currently outstanding requests complete?
>>>
>>>    And as already discussed, we even already have logic to support
>>>    this kind of thing for the sake of power-management.
>> Power management requests are kind of special and need block layer support.
>>
>> Please take a look at REQ_DEVSET_EXEC special requests from ide-devsets.c
>> instead if you would like to investigate possibility of a cleaner (although
>> more invasive) solution.
>>
>>> 2) All commands going into the device do so from a context from
>>>    which we could take a sleeping lock such as a mutex.  It's
>>>    therefore the most natural way to synchonize things.
>> The fact is that we need to synchronize against all commands going into
>> the device and they are synchronized using block queue (which is protected
>> with spinlock by block layer). Adding an extra mutex (even if possible)
> 
> We need to also take the synchronization between block queues of all devices
> on the port and the serialized ports into account..  This is quite complex
> and fragile code (vide cmd64x screaming IRQ issue ;)..
> 
> I would personally try going with 1) and avoid 2) at all costs..

FWIW, on Promise chipsets, SETFEATURES_XFER requires synchronization 
across all ports on the controller, otherwise SETFEATURES_XFER on port M 
can potentially cause data corruption on unrelated port N.

This has to do with the snooping of ATA commands performed by the 
Promise PATA and SATA chips.  The chip sees SETFEATURES_XFER, and does a 
bit of internal programming.

Silicon Image (siimage or sata_sil) also snoops ATA commands such as 
SETFEATURES_XFER; ditto a few other chipsets.

SETFEATURES_XFER has always required very, very careful, often 
chipset-specific handling.

	Jeff



