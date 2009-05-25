Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZEYO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZEYO7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZEYO7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:59:36 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:5525 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751940AbZEYO7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:59:35 -0400
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Mon, 25 May 2009 16:59:17 +0200
User-Agent: KMail/1.9.10
Cc: "David Brownell" <david-b@pacbell.net>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905250243.46984.david-b@pacbell.net> <200905251218.18262.wolfgang.mues@auerswald.de> <20090525135012.13be624c@mjolnir.ossman.eu>
In-Reply-To: <20090525135012.13be624c@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905251659.17396.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre,

Am Montag, 25. Mai 2009 schrieb Pierre Ossman:
> I don't remember why
> mmc_spi is looking at responses to begin with.

Because responses are very different.

First of all, responses in SD mode and SPI mode are different.

Second, responses in SD mode are CRC-7 protected, so that it is easy to check 
for transmission errors.

SPI mode responses (R1...) are without any CRC.

Third, if you have SD mode, you use a hardware host controller which manages 
all command/data/response actions, and what you typically get is the content 
of the status register of the host controller (which is different from the
error code of the SD card).

So it is very natural that every host controller driver mapps the responses 
from the host controller to a common representation (== error code). The 
error codes with special meanings for MMC/SD are summed up in mmc/core.h .

The SPI host driver is a recent addition to the linux kernel, and the fact 
that SPI responses are not CRC-protected was not accounted for in the code.

As it makes no sense to code the retry logic in every driver, the prefered way 
is to code the retry logic in block.c. The non-SPI-mode-drivers will profit 
from this logic, because they are getting retries for EILSEQ (CRC error) and
ETIMEDOUT (card has not understand the command).

The biggest problem in the error codes is that EINVAL is used by the SPI 
driver both for recoverable and for non-recoverable errors, which has to be 
splitted IMHO.

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
