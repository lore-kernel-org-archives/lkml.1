Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZETIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZETIfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZETIfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:35:36 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:41204 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbZETIfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:35:36 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Wed, 20 May 2009 10:35:23 +0200
User-Agent: KMail/1.9.10
Cc: "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905192149.07778.david-b@pacbell.net>
In-Reply-To: <200905192149.07778.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905201035.23964.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 20. Mai 2009 schrieb David Brownell:
> On Tuesday 19 May 2009, Matt Fleming wrote:
> > Hmm, always returning -EILSEQ is devious. What happens if we sent an
> > illegal command? The value of "value" is passed up to the callers via
> > cmd->error and so may eventually get printed in the pr_debug() call in
> > mmc_request_done(), line 86.
>
> True, but a pr_debug from mmc_spi could help that.  A patch doing
> that would need to be less aggressive about ripping out the current
> fault-parsing logic, but it could continue reporting -EILSEQ to
> cope with the possible response mangling.

what about the following proposal which is not so aggressive?

The current mapping in mmc_spi.c is:

R1_SPI_PARAMETER => EINVAL
R1_SPI_ADDRESS => EINVAL
R1_SPI_ILLEGAL_COMMAND => EINVAL
R1_SPI_COM_CRC => EILSEQ
R1_SPI_ERASE_SEQ => EIO
R1_SPI_ERASE_RESET => EIO

R1_SPI_COM_CRC is a transmission error - no doubt. Mapping to EILSEQ is OK.

R1_SPI_ERASE_SEQ and R1_SPI_ERASE_RESET are responses to a sector erase 
command. block.c is not sending such commands, so block.c can safely assume 
that each such response is a transmission error.

R1_SPI_PARAMETER and R1_SPI_ADDRESS are errors from the card controller
because a parameter or an address is out of range/invalid. It is mapped to 
EINVAL, and so the caller can not distinguish between errors from the host 
controller and driver or the card. This has to be changed to some other code,
maybe EFAULT /* Bad address */.

R1_SPI_ILLEGAL_COMMAND is mapped to EINVAL, and I suggest it to replace with
ENOSYS /* Function not implemented */.

A quick scan in the mmc directory for EINVAL reveals that there are no callers 
which need to be changed.

As block.c does not send a command, parameter or address which is invalid/out 
of range, these errors must be considered transmission errors in the command 
(if CRC is off) or in the response.

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
