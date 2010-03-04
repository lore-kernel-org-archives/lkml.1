Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0CDVSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:18:17 -0500
Received: from mr0122.hansenet.de ([85.183.254.190]:40368 "EHLO
	mr012.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932352Ab0CDVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:18:14 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 16:18:14 EST
From: Thomas Koeller <thomas@koeller.dyndns.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: DMA using data buffer vmapped in kernel space
Date: Thu, 4 Mar 2010 22:11:08 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32.5; KDE/4.4.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1468622.JnpH9mcp8j";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003042211.28569.thomas@koeller.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1468622.JnpH9mcp8j
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I am writing a driver that loads a firmware blob into its device. The driver
calls request_firmware() and gets a struct firmware * that contains a
data buffer pointer in its 'data' member. The buffer is then passed to a
SPI driver to send it to the device.

The SPI driver uses DMA and, in preparation for that, eventually calls
dma_cache_maint() (contained in arch/arm/mm/dma-mapping.c). At this
point, the whole thing goes bad because there is a check:

	BUG_ON(!virt_addr_valid(start) || !virt_addr_valid(start + size - 1));

and the address obtained via request_firmware() fails this check.

The request_firmware() function creates the data buffer by allocating a
number of single pages in a loop, places them in an array, and finally
creates a kernel mapping by calling vmap(). The vmap() result is the
buffer address passed to the DMA.

I do not understand the purpose of the failing check. The virt_addr_valid()
macro checks whether its argument is below high_memory. But why would the
virtual address of a DMA data buffer matter at all? After all, the pages
are resident, so I cannot see any problem here. Can anybody explain?

Thomas

--nextPart1468622.JnpH9mcp8j
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJLkCHtAAoJEFOuSbSntw2DoQQH/2jG7he5mvOKaDP8cDVPkG6t
/p6M/8jGQLX/dOE1kLXzI64Agur8QdlzaMwzgrBA92Z7eqkVBdwHY4+mkCr6Y+Yz
sK2/GCZlM06ALXJoIeb2q6KXlEw7jE7uRalSN2I0J4rsGV9NsucAze32p5KjlFGW
WiGH/SHwOmWBBkm5ubZJHTRzDFbEfdIuKcfyI1cAAZTOsDbuAO3em+pI7YYwtdSb
KnTeXAxeq75EdGD7KbJA6ez16WAnYPhVhuXiA6FF7oSPm74ArqTkXjyjBC5hfyzi
97+dQxfkjtmPGo6UmL2UEB63QrMiBgLLQOIRsIElwDGM4VfX/39wmqtIC9l32aw=
=ToFp
-----END PGP SIGNATURE-----

--nextPart1468622.JnpH9mcp8j--
