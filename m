Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXK1Nf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXK1Nf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXK1Nfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:35:46 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:29788 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbXK1Nfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=llPNEaA8CX1zuvUGjkA0MRvWdZWPwTneREfxq+TKbVpjZtTXkf/vlUqe1H/FOIppomEdf2+4dWVm5BhJ88nOJRJJBM/eKiWDVRWVX91KycoE3U0DZ5dnnMfltgv3drz1wtnsoX1RXMkU37kfg25dl3npBAAaGYWLBCeFdS422Xk=
Message-ID: <474D6EA7.2000506@gmail.com>
Date: Wed, 28 Nov 2007 22:35:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kjartan Maraas <kmaraas@broadpark.no>
CC: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com> <1196253340.2884.1.camel@localhost.localdomain>
In-Reply-To: <1196253340.2884.1.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing libata people]

Hello,

Kjartan Maraas wrote:
> Here you go. It shows the error two times and then it gets it right and
> continues to boot. No other problems arise from this that I can see.

Cool, it proves even my code works from time to time if the moon and
stars are perfectly aligned.

> ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)

Your BIOS wants to issue DEVICE CONFIGURATION FREEZE LOCK but the device
NACKs it probably because the drive doesn't support DCO feature set.

> ata1: failed to recover some devices, retrying in 5 secs
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
> ata1.00: ACPI on devcfg failed the second time, disabling (errno=-5)

libata EH gives ACPI one more chance but it fails again, so ACPI is
turned off.

> ata1.00: revalidation failed (errno=1)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/100

Device is now configured properly.

Your BIOS is probably trying to issue DCO freeze lock to all drives.  I
don't have the faintest idea why it does but it does.  I think there are
several choices here.

1. Ignore device errors for _GTF commands.  Report the failure with
KERN_DEBUG priority and just keep processing.  ISTR there was a patch to
do this.  Anyone knows what happened to it.

2. Filter out certain commands from ACPI.  I definitely don't like BIOS
locking up random features via _GTF commands.  It makes debugging difficult.

3. Look at opcode on failure and ignore error for certain operations.

My favorite is #2 but #1 should be fine too.  Any thoughts?

Thanks.

-- 
tejun
