Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYDUTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYDUTLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYDUTLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:11:04 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:29672 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754285AbYDUTLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:11:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DBAXi3ChRpF6yZH9dpyXnjIJHW6oYzxOqF6WLmc9Y4NrsJIOZWXoZlY6gfX3pz8pkKn9lCjOybo/iZsBb3BmfboJxwBnI3chpUHAHDOmTldmSBR/DpCMbWzdSqRr8qI5opWUnQ+UqrLuLGKxECKsQdvFHECm6xfs8+HVdoGTP3Q=  ;
X-YMail-OSG: 28ndh.YVM1lIhJF5QlRr0ynD8x6nFJT0dzIEgT5VHZCm2mFk98P1JxebCfua6Bgu5LOKOWIWfJx4nY1BONemVaI.civF_iJQDocsAg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC] MMC multiwrite capability removal
Date: Mon, 21 Apr 2008 12:05:09 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Victor <linux@maxim.org.za>, Pavel Pisa <ppisa@pikron.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <briglia.anderson@gmail.com>,
       "Syed Mohammed, Khasim" <x0khasim@ti.com>,
       Russell King <rmk@arm.linux.org.uk>, Alex Dubov <oakad@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080419095136.15a50cc9@mjolnir.drzeus.cx>
In-Reply-To: <20080419095136.15a50cc9@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211205.10060.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008, Pierre Ossman wrote:
> 1. Data starts moving from main memory to host memory (DMA or PIO)
> 2. Data finishes moving from main memory to host memory
> 3. A sector moves to the front of the device write queue
> 4. The sector starts being sent over the wire
> 5. The sector finishes being sent over the wire
> 6. The card acknowledges a successful transfer

The mmc_spi driver will report failure at this point, when
the card reports an error.


> 7. The card finishes busy signalling

The mmc_spi driver won't report that a sector has been
successfully written until the card stops BUSY signaling.

It's also possible to report an error at this point, such
as ETIMEDOUT if the card doesn't finish that signaling.


> 8. The sector moves to the front of the card write queue
> 9. The sector gets picked up by the FTL
> 10. The sector is written to media
> 
> In a perfect world we would report the number of sectors that made it
> to 10. Unfortunately we have limited insight into what the card is up
> to.
> 
> What your host drivers should report is sectors that have passed stage
> 6. If your controller doesn't give you enough information to determine
> that, then you must report 0 for all failed transfers.

Seems like mmc_spi does that.  Though having looked at this,
I wonder whether per-driver variations in fault reports on
these paths wouldn't make some trouble...

- Dave

