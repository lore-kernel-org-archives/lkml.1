Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZFXWoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZFXWoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZFXWoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:44:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49779 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753986AbZFXWoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:44:02 -0400
Date: Wed, 24 Jun 2009 23:45:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David =?ISO-8859-14?B?SORyZGVtYW4=?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com, terry@beam.ltd.uk
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP
 id WEC1022)
Message-ID: <20090624234501.3d35642f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090624213645.GA18843@hardeman.nu>
References: <20090624213645.GA18843@hardeman.nu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lots of drivers support one or more logical devices provided by 
> different SuperI/O chips, but there seems to be no synchronisation 
> between the different drivers? Since my driver gets all info from ACPI, 
> it's no real problem here, but I'm curious...shouldn't there be some 
> kind of synchronisation between SuperI/O drivers which might all be 
> changing global registers, such as the logical device select register?

I'm looking at a similar case (clash between super I/O config for serial
and watchdog) at the moment that affects a proposed driver for some
serial port save/restore config stuff. We can request_region to avoid
collisions but there is no wait mechanism for super I/O devices which
probably wants fixing with a simple list of super I/O ports and a helper
lib. I was thinking something like

	handle = superio_request(name, dev, start, len);

	EBUSY - someone else has the I/O space registered other than
	super I/O. The super I/O lib would then request the I/O space and
	hog it.

	superio_claim(handle, block)

	Claim the super I/O providing another person isn't using it,
	optionally wait if so

	superio_release(handle);

	Give back the claim

	superio_free(handle)

	Free allocation


>    2) Location of driver
> 
> Where should this driver go in the tree? drivers/platform/x86/?

Not if the device is not x86 specific - eg a generic super I/O device

>    6) Reclaiming the serial port
> 
> The serial port which the WPCD376I uses for IR TX/RX is only useful for 
> Consumer IR, but it looks enough like a "normal" uart for the serial 
> driver to claim the port. I currently have to boot with 
> "8250.nr_uarts=1" to stop the serial driver from using the IR uart 
> (there is one "real" serial port in the chip). However, that's not a 
> very elegant or user-friendly option. Is there a way to blacklist the 
> port in the serial driver and/or to reclaim the port from the serial 
> driver when the CIR driver is loaded?

How similar is it to a normal UART and if it looks like a normal UART why
not drive it as one ?

>    7) kmalloc and spinlocks
> 
> In wbcir_setkeycode the driver might need to kmalloc memory for a new 
> keytable entry, but kmalloc isn't allowed with rwlocks held so I've 
> currently written the driver to do a kmalloc before taking the rwlock 
> and then to kfree it later if it wasn't necessary, which feels quite 
> inelegant to me. Any suggestions on a better approach

Thats actually a common way to do it and usually cleaner than the
alternatives.
