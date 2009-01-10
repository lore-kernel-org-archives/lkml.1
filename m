Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZAJOgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZAJOgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZAJOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:36:15 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44164 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbZAJOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:36:14 -0500
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
	ata_sff_hsm_move+0x45e/0x750()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090110122130.318cf168@lxorguk.ukuu.org.uk>
References: <200901091334.55823.borntraeger@de.ibm.com>
	 <200901101009.13699.borntraeger@de.ibm.com>
	 <20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	 <200901101242.05203.borntraeger@de.ibm.com>
	 <49688B63.5030105@ru.mvista.com>
	 <20090110122130.318cf168@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 08:36:10 -0600
Message-Id: <1231598170.3642.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 12:21 +0000, Alan Cox wrote:
> >    That's the typical REQUEST SENSE command with 18-byte data length.
> 
> Which means something has become horribly broken in the core libata stack.
> An 18 byte inquiry would have 18 bytes as the *last* sg element. That
> would therefore not trigger the WARN_ON. Someone has passed an sg list
> that isn't properly terminated perhaps ?
> 
> I wonder if the pad code broke this.

I don't think it's anything to do with padding or the block layer.

I think we sent out a request sense with 96 bytes of space for a reply,
which is bog standard for SCSI. The device sent back a payload of 18
bytes, which is perfectly legal ... request sense is a variable payload
command, the device doesn't have to fill the buffer we give it.

18, by the way, is the typical reply length for non descriptor sense
format with no additional information, so this is really expected
behaviour.

Your problem is that the *device* is wanting to transfer a set of bytes
not divisible by four.  If you want to use word based PIO, you'll have
to fall back to collecting bytes for the last two.  Alternatively, you
could just do byte PIO for all reply lengths like this ... they occur
all over the SCSI standard, but not usually in critical paths.

James


