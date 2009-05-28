Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZE1Jym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZE1Jym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZE1Jyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:54:35 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:4914 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbZE1Jye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:54:34 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer - 3rd try
Date: Thu, 28 May 2009 11:52:26 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <pierre@ossman.eu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090528091924.GB1860@console-pimps.org>
In-Reply-To: <20090528091924.GB1860@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905281152.26191.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Donnerstag, 28. Mai 2009 schrieb Matt Fleming:
> When I said "report the correct error" I was objecting to using EILSEQ
> as The One True Error Code based on the fact that a transmission error
> may, or may not, have occurred.

Yes, and we have discussed the problem of error code interpretion based on 
request types.

So, in block.c, if I get a -EIO (== erase error), I can handle this as 
transmission error inside the read/write data function.

If there will be a (future) erase request function in block.c, I will handle 
the same error code as erase error, not as transmission error. No big 
problems here.

To mimic the same behaviour inside the driver, inside mmc_spi_response_get,
I will have to code:

	if (cmd->resp[0] != 0) {
		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS)
				& cmd->resp[0])
// TODO: transmission error if parameter or address was not out of range.
			value = -EFAULT; /* Bad address */
		else if (R1_SPI_ILLEGAL_COMMAND & cmd->resp[0])
// TODO: transmission error if mandatory command
			value = -ENOSYS; /* Function not implemented */
		else if (R1_SPI_COM_CRC & cmd->resp[0])
			value = -EILSEQ; /* Illegal byte sequence */
		else if ((R1_SPI_ERASE_SEQ | R1_SPI_ERASE_RESET)
				& cmd->resp[0])
// START
			switch (cmd->opcode) {
			case xxx: /* erase commands */
			case yyy:
				value = -EIO;    /* I/O error */
				break;
			default: /* non-erase commands */
				value = -EILSEQ; /* Illegal byte sequence */
				break;
			}
// STOP
		/* else R1_SPI_IDLE, "it's resetting" */
	}

So somewhere I will need to have an error code filter based on the issued 
command (class). Should this be in the driver(s)? Or should it be at the 
location of the caller, in block.c?

The advantages of putting it in block.c is that
a) The command (class) is typically implicit given in the function, and no 
need for a switch() statement.
b) Only one handling for different drivers, not scattered through all(?) host 
drivers.

I must admit that I have difficulties to see a clear layering violation.
There is no clear definition of which error codes should be reported to the 
block layer. There is only a short list of codes with special meaning, but 
not a full list of all used codes.

And some drivers are reporting codes like ENOMEM etc...

I see that Pierre wants to have a more smaller interface between drivers and 
the upper layer, reporting only classes of errors, to have a more smaller and 
cleaner code in the upper layer. But I think that this is a patch of its own, 
and not in the context of the retry patch.

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
