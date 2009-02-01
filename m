Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbZBAHIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbZBAHIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 02:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZBAHIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 02:08:39 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:17872 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZBAHIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 02:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=mOH1Cafoi8ro1lFV8m19bGyL+6YNhoHjcCNrs7bLu3B+ZpgiLgcv6UKffIt+dYZ7s5
         VWvXVENcdaMawxAup9dXbwklLSmiIhkZVnOmvoRByzGnKjaI9NJtgsWru/eKyEmiFJqB
         jFNoWELrfCqAjyWyiWsxrSXj4uLNOdWRGYIWQ=
Message-ID: <49854A71.500@gmail.com>
Date: Sun, 01 Feb 2009 01:08:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Philippe De Muyter <phdm@macqel.be>
CC: linux-kernel@vger.kernel.org, abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [BUG] pnpbios breaks floppy support
References: <20090131212915.GA19276@frolo.macqel>
In-Reply-To: <20090131212915.GA19276@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> Hello linux experts,
> 
> Today I tried to upgrade a PC's kernel from 2.6.11 to 2.6.22, and
> I saw some strange messages when booting :
> 
> 	Floppy drive(s): fd0 is 1.44M
> 	floppy0: Floppy io-port 0x03f2 in use
> 
> Previously, I had :
> 
> 	Floppy drive(s): fd0 is 1.44M
> 	FDC 0 is a post-1991 82077
> 
> Needless to say, my floppy hardware works perfectly, and my floppy
> was usable with the old kernel, while the floppy is now inaccessible
> with the new kernel.  Even /dev/fd0 does not exist anymore.
> 
> Searching for a cause to that problem, I saw the following messages
> before the floppy probe in the new kernel :
> 
> 	PnPBIOS: Scanning system for PnP BIOS support...
> 	PnPBIOS: Found PnP BIOS installation structure at 0xc00fd5e0
> 	PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x5ba3, dseg 0xf0000
> 	PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
> 	[...]
> 	pnp: 00:07: ioport range 0x3f0-0x3f1 has been reserved
> 	pnp: 00:07: ioport range 0x3f3-0x3f3 has been reserved
> 	[...]
> 
> Searching the web and the outdated pnp kernel documentation, I
> finally found an option to add to my kernel parameters line :
> 
> 	pnpbios=off
> 
> Now my floppy works again, but I am not really satisfied.
> 
> What do I loose with the 'pnpbios=off' option ?
> 
> Isn't there a smoother option to allow pnpbios but avoiding to reserve
> floppy's io-ports ?
> 
> Should I modify rather /drivers/block/floppy.c or /drivers/pnp/*.c
> to make pnpbios and floppy driver coexist peacefully ? And is there
> an example of such modifications for other standard peripherals ?

Presumably the problem is that your BIOS marks the IO ports used by the 
floppy controller as reserved which prevents the floppy driver from 
binding to them. (2.6.11 probably was before we even processed PnP 
reserved regions.)

I think we now have handling for the case where the reservations overlap 
PCI devices, but I think it's the first I've heard of them overlapping 
the floppy IO ports..
