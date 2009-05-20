Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZETKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZETKcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZETKcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:32:07 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:41421 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754072AbZETKcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:32:06 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Wed, 20 May 2009 12:31:53 +0200
User-Agent: KMail/1.9.10
Cc: "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905200220.46569.david-b@pacbell.net>
In-Reply-To: <200905200220.46569.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905201231.53873.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Mittwoch, 20. Mai 2009 schrieb David Brownell:
> > R1_SPI_ERASE_SEQ and R1_SPI_ERASE_RESET are responses to a sector erase
> > command. block.c is not sending such commands, so block.c can safely
> > assume that each such response is a transmission error.
>
> Hmm, would hope that's not a long-term plan.  Remember that the
> firmware in the card can leverage "that's erased" knowledge for
> things like wear leveling.  SSDs and other storage devices would
> likewise benefit from such knowledge.  I'm quite certain there's
> been discussion about adding support for that in the block layer.

But if the block layer IS sending such erase commands in the future, it CAN 
treat these error codes different:

if (read or write block command)
   erase errors must be transmission errors
else
   accept erase errors;

As it is not neccessary to change the handling of these errors in mmc_spi.c, 
no information is lost.

> And the key issue is -- correct me if I'm wrong -- that returning
> EINVAL makes trouble

Yes, because EINVAL is used for TWO different purposes:
- reporting an error of the driver or host controller
  (which is by nature non-recoverable, a retry is harmless,
   but makes no sense).
- reporting an error from the SD card (in mmc_spi).
  (which might be a transmission error and retries make
   sense).

> so you need to change those three codes.  

Yepp.

> The others don't much matter, right?

Yes. I can simple treat them as transmission errors in block.c

regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
