Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZCKQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZCKQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZCKQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:14:39 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2551 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbZCKQOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:14:39 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Date: Wed, 11 Mar 2009 17:14:15 +0100
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090311154605.GD1475@console-pimps.org>
In-Reply-To: <20090311154605.GD1475@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903111714.15911.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Mittwoch, 11. März 2009 schrieb Matt Fleming:
> OK, but if my machine runs at 100 HZ then a jiffie is 10ms.

Yes.

> Previously (without your patch) we waited for 300ms in the write case 
> and 100ms in the read case.

It depends... There was a change between somewhere between 2.6.26 (300+100ms) 
and 2.6.29 (timeouts calculated from the card parameters).

> So, it's not unreasonable to think that a response is 
> going to take more than 10ms.

Mosts responses (data read and data write with empty buffers in the card) are 
immediately, mostly below 1 ms.

> With your patch we're almost always going 
> to schedule()

No. See above.

> I agree that busy-waiting for 900ms would be a bit mad.

Yes, but this was the previous reality!

> Is there a reason that you didn't implement this with msleep()
> as was noted in the comment above the timeout?

Yes. msleep() is a busy waiting. It is implemented in terms of usleep(), which 
is also busy waiting. The old comment is wrong.

> Do you know approximately how long it
> is before we return from the schedule() under various workloads?

The Linux scheduler tend to prefer processes which call schedule() often, so 
there is a high chance that this process will return from the schedule() at 
the very next tick.

So my timing is:

- busy waiting for 1-2 jiffies
- non-busy-waiting with a delay of 0-1 jiffies afterwards.

I have done some speed measurements for SD card reads and writes, and the 
non-busy waiting has not incured a notable speed decrease.
 
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
