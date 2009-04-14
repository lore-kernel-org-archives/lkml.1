Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZDNO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZDNO14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZDNO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:27:45 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:65153 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbZDNO1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:27:45 -0400
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
Date: Tue, 14 Apr 2009 16:27:26 +0200
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200904081155.53173.wolfgang.mues@auerswald.de> <20090411001030.56e247c4@mjolnir.ossman.eu>
In-Reply-To: <20090411001030.56e247c4@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904141627.26276.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pierre,

Am Samstag, 11. April 2009 schrieb Pierre Ossman:
> NAK. Writes cannot be retried safely as upper layers rely on the fact
> that writes fail in a linear manner (a stupid assumption IMO, but
> that's the way things are).

Hmmm.... so this patch has to be improved. I think the (original) code in 
mmc_blk_issue_rq() is somewhat questionable. As far as I understand the code, 
in the case of an error, brq.data.bytes_xfered is not examined, so the code 
starts over from the very first sector of the request, and rereads all 
sectors (one after the another).

So if there is a non-recoverable write error, this code must stop and do not 
continue to write, right?

But if there is a read error, it is OK and advisable to try to read the rest 
of the sectors?

If there is a write error in the middle of a request, is it OK to do
__blk_end_request(req, 0, brq.data.bytes_xfered);
and try to retry from this point, and stop if there is a non-recoverable write 
error?

> > +		/* Invalid response. This is most likely a transmission
> > +		 * error from card to host.
> > +		 */
> > +		case -EINVAL:
>
> EINVAL is actually "host controller driver/hardware does not support
> this type of request".

"Hardware" is including the hardware of the SD card. This should NEVER happen, 
because block.c issues only valid requests, which are translated to mandatory 
commands for the mmc/sd card.

So if there is an EINVAL result from the lower layers, it comes from 
transmission errors (card has not understand the command, or host has not 
understand the response).

If EINVAL is coming from the HOST CONTROLER, a retry will not harm anyone.

I have seen EINVAL results due to spikes on the SD lines.

Please correct me if I am wrong.

best regards
 
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
