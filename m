Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbZFXTue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbZFXTue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZFXTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:50:25 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54772 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZFXTuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=n06lKrDZJtnxKa4SVGZH4Ba2FdLZcRatGzBL71NooRHBkSp2GHpWIKsILTtnw5ey3P
         R0pLhBSWw0SrMi2Hn4qO6I5weuvsDym0v/7INZyNnFcGCt31tOujU2NL+14+u1Gulb7B
         IXV22/6NZ37qBgj3RuCuLhAvXfsbn6ATGnYs4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Wed, 24 Jun 2009 21:55:56 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906240336.25263.bzolnier@gmail.com> <200906241304.14926.bzolnier@gmail.com> <4A427EE0.8050901@garzik.org>
In-Reply-To: <4A427EE0.8050901@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906242155.56769.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 21:30:40 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 24 June 2009 12:48:20 Bartlomiej Zolnierkiewicz wrote:
> > 
> >>> 1) You want the device to be quiescent anyways when you do this
> >>>    SET_XFER command.  What better way than to plug the queue
> >>>    and make sure all currently outstanding requests complete?
> >>>
> >>>    And as already discussed, we even already have logic to support
> >>>    this kind of thing for the sake of power-management.
> >> Power management requests are kind of special and need block layer support.
> >>
> >> Please take a look at REQ_DEVSET_EXEC special requests from ide-devsets.c
> >> instead if you would like to investigate possibility of a cleaner (although
> >> more invasive) solution.
> >>
> >>> 2) All commands going into the device do so from a context from
> >>>    which we could take a sleeping lock such as a mutex.  It's
> >>>    therefore the most natural way to synchonize things.
> >> The fact is that we need to synchronize against all commands going into
> >> the device and they are synchronized using block queue (which is protected
> >> with spinlock by block layer). Adding an extra mutex (even if possible)
> > 
> > We need to also take the synchronization between block queues of all devices
> > on the port and the serialized ports into account..  This is quite complex
> > and fragile code (vide cmd64x screaming IRQ issue ;)..
> > 
> > I would personally try going with 1) and avoid 2) at all costs..
> 
> FWIW, on Promise chipsets, SETFEATURES_XFER requires synchronization 
> across all ports on the controller, otherwise SETFEATURES_XFER on port M 
> can potentially cause data corruption on unrelated port N.
> 
> This has to do with the snooping of ATA commands performed by the 
> Promise PATA and SATA chips.  The chip sees SETFEATURES_XFER, and does a 
> bit of internal programming.
> 
> Silicon Image (siimage or sata_sil) also snoops ATA commands such as 
> SETFEATURES_XFER; ditto a few other chipsets.
> 
> SETFEATURES_XFER has always required very, very careful, often 
> chipset-specific handling.

Thanks for the reminder.

David, we should probably disallow user-space requested transfer mode
changes on some chipsets (especially Promise ones) in IDE until somebody
provides the needed synchronization infrastructure for handling such
special cases (libata avoids the issue by not allowing any user-space
requested transfer mode changes).  However since this is an independent
issue from IRQ handler vs user context races it would be best done in
the separate patch.
