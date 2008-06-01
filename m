Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbYFAUgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbYFAUgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYFAUg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:36:28 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37459 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753201AbYFAUg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:36:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MjM1mACjyByO5lfEJ/U5Pybu/HOOR935wfdut/GY8W382UxQk/PegQ28w40dCWvFbR6S9pJ2dF+pnee1R0NBhq7pb2lShPZsY6np4Om2XhXqgBuRFUPmedZG4rZT+RL0tuC3MZLkMM4HjMO3mfbU+Bku7fFnKmkk8fe0w3qJ3ec=  ;
X-YMail-OSG: xZCHl0kVM1kGiC.frbdcOh7jNoyegZQTM1M74Euy3bMEU1fELw100J5AY9AALtAtA6EMxM9XZ1eprqgQqYP38nS_9ZOLiyhZ2uQmSNQp9Zm6MFTXDWeWHMN9qCJnNW33.98-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] MTD DataFlash: fix bug - ATMEL AT45DF321D spi flash card fails to be copied to
Date: Sun, 1 Jun 2008 13:28:58 -0700
User-Agent: KMail/1.9.9
Cc: linux@maxim.org.za, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <1212230324-22201-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1212230324-22201-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011328.58594.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
>  - Add support for binary page size DataFlashes.
>  - The driver now prints out pagesize and erasesize.
>    Printout valuable information for creating flash filesystems.

I like the idea, but I'm afraid this approach isn't sufficient.

Thing is, the LSB of the status register is explicitly
undefined for earlier chip revisions (e.g. see datasheets
for AT45DB321B and AT45DB321C vs AT45DB321D), so you should
use a different chip discovery algorithm.  Perhaps:

 * Try the original scheme (read status register);

 * If it indicates a chip that has new versions with
   binary page size options, use the 0x9F command to
   read the JEDEC id (and chip revision);

 * If it's a sufficently new revision, *then* you can
   interpret that LSB as indicating the page size

Example, on the AT45DB321x chips, that JEDEC instruction was
added for the 'C' revision (according to my copies of the
datasheets) and wasn't there for the 'B' revision ... while
it was the 'D' revision which introduced the binary page size.

Maybe the JEDEC code from the m25p80 driver can be reused.

Also, I'd like to see a pre-existing typo fixed (in case anyone
uses a flash that small) ... see below.

- Dave


> @@ -546,29 +551,44 @@ static int __devinit dataflash_probe(struct spi_device *spi)
>  	 * board setup should have set spi->max_speed_max to
>  	 * match f(car) for continuous reads, mode 0 or 3.
>  	 */
> -	switch (status & 0x3c) {
> +	switch (status & 0x3d) {
>  	case 0x0c:	/* 0 0 1 1 x x */
> +	case 0x0d:
>  		status = add_dataflash(spi, "AT45DB011B", 512, 264, 9);
>  		break;
>  	case 0x14:	/* 0 1 0 1 x x */
> +	case 0x15:
>  		status = add_dataflash(spi, "AT45DB021B", 1025, 264, 9);

1024 pages (of 264 bytes), not 1025.  :)


>  		break;
>  	case 0x1c:	/* 0 1 1 1 x x */
> +	case 0x1d:
>		...
