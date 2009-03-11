Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZCKOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZCKOzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZCKOz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:55:26 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2421 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751623AbZCKOz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:55:26 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Date: Wed, 11 Mar 2009 15:55:00 +0100
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090311140219.GA1475@console-pimps.org>
In-Reply-To: <20090311140219.GA1475@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903111555.00982.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Mittwoch, 11. März 2009 schrieb Matt Fleming:
> I am correct in thinking that this patch, in conjuction with your other
> patch, "[PATCH 6/7] mmc_spi: convert timeout handling to jiffies and avoid
> busy waiting", will now penalize my working card and mandate a timeout
> of 1 second?
>
> Without your patch 6 at least mmc_spi_skip() would busy-wait for the
> response, and if my card completed in less than 1 second then it'd just
> return quicker.
>
> It seems you've introduced a performance hit on all MMC over SPI cards.

No.

A timeout is a maximum time to wait, not a minimum time.
Waiting is terminated by a response or by the timeout, whichever comes sooner.

My patch 6 in mmc_spi_skip() is doing a busy-wait for a short while ( less 
than 1 jiffie), and starts to call schedule() inside the loop if the card is 
slower.

My goal was to avoid the long-lasting busy waiting. I have measured times up 
to 900ms! With my patch, the longest busy waiting will be 1 jiffie. 

And yes, if the SD card is sending its response after 5 jiffies, it is 
recognized only after the scheduler schedules this process, which will incure 
a delay to the data transfer. The amount of delay is determined by the number 
of running processes and the number of HZ.

The typical case for this is a series of data block writes to the SD card. 
Until the internal card buffers are full, such writes will be acknowledged by 
a fast response. But if the card buffers are full, you will get one long 
delay until the card controller has written most of the pending data to 
flash.

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
