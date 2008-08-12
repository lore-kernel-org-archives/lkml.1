Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYHLH42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYHLH42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYHLH4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:56:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51331 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466AbYHLH4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:56:18 -0400
Date: Tue, 12 Aug 2008 08:39:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] fastboot: Add a module parameter to skip probing of
 specific ports
Message-ID: <20080812083903.6d402c2e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080811153641.706726ec@infradead.org>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153641.706726ec@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 15:36:41 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> 
> From: Kristen Accardi <kristen.c.accardi@intel.com>
> Subject: [PATCH] libata: Add a module parameter to skip probing of specific ports
> 
> Port probing by libata can easily take 10% or more of the kernel boot
> time (2%+ of total). For cases where one knows there is nothing
> connected to certain ports (for example on netbooks) this is a waste
> of boot time.
> 
> This patch adds a module parameter that allows the admin to specify
> to skip ports (specified by a bitmask) and recoup this boot time.
> This capability is potentially also useful to get systems to boot
> for cases where port-probing on a certain ports causes crashes.
> 
> A follow-on patch will add the capability to use DMI identification
> to automate this for certain known systems.

What happens if I plug in an additional libata using device ? What
defines the probe order here particularly as people are pushing for
parallel probing of multiple devices.

This doesn't appear to make any rational sense as the mask isn't tied to
the actual bus device identifier to keep it on the same port. It might
kidn of work for an EEEPC (until you see what people retrofit into the
corners of them) but it isn't a valid general solution.

Also the EEE problem seems to be a controller specific screwup - they
didn't apparently manage the enablebits on the ATA controller correctly,
so it belongs in that driver. That also lets you tie it to the right
system, pci id, bus id so it'll always hit the right device.

(Plus double check the enables code in case you are papering over the
real bug)

Second problem is you've changed the API. Several drivers do things on
the port 0 register they know they will receive and will simply crash and
burn if you change this.

NAK this patch for now: right theory, wrong implementation. Please post a
version which uses DMI in the relevant driver and checks the PCI DEVFN
matches.

