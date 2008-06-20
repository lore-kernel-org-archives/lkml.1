Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYFTRlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYFTRlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYFTRlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:41:32 -0400
Received: from server.drzeus.cx ([85.8.24.28]:34545 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752477AbYFTRlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:41:32 -0400
Date: Fri, 20 Jun 2008 19:41:28 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MMC test driver - help with output
Message-ID: <20080620194128.2720cc51@mjolnir.drzeus.cx>
In-Reply-To: <20080620111553.GC21835@fluff.org.uk>
References: <20080620111553.GC21835@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 12:15:53 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> I'm testing the s3c24xx sd/mmc driver and can't find any
> documentation for each of the tests the mmc_test driver is
> doing.
> 
> The following is output from a recent linux-next+driver:
> 
> mmc0: Test case 8. Power of two block reads...
> s3c2440-sdi s3c2440-sdi: unfinished read - pio_count:[0] pio_words:[0]
> mmc0: Result: UNSUPPORTED (by host)
> 
> => probably the wrong error being returned, but what would be
> the general problem with this causing a finish before the driver
> has decided that there should have been data to read?
> 

I'm not sure what's going on here. The purpose of the test (and most of
them) is to test that the driver supports all block sizes. The reason
there are so many tests is because there are a lot of different bugs in
different drivers. This particular one is for the PXA controller
(IIRC), where only power of two sizes are valid.

This test starts with a block size of 1 byte, then doubles it until it
reaches 512 bytes.

> mmc0: Test case 10. Weird sized block reads...
> s3c2440-sdi s3c2440-sdi: unfinished read - pio_count:[0] pio_words:[0]
> mmc0: Result: UNSUPPORTED (by host)

This test starts with 3 bytes and adds 7 bytes to the size until it
reaches 512 bytes. It is primarily meant to test size alignment issues.

> mmc0: Test case 15. Correct xfer_size at write (start failure)...
> s3c2440-sdi s3c2440-sdi: bad data crc (incoming)
> 
> => is this sort of error what was exepected?
> 

Not really, no. The test tells the driver to write a block, but sends a
non-data command to the card. The idea is to simulate a failed write
and see that the driver handles the error properly.

The validation of the test is making sure the driver doesn't report
more data written than was actually transferred and to check that the
error code is -ETIMEDOUT, which is what is expected as the card should
not acknowledge the data block.

> mmc0: Result: ERROR (-84)
> mmc0: Test case 16. Correct xfer_size at read (start failure)...
> s3c2440-sdi s3c2440-sdi: data timeout
> mmc0: Result: OK
> 
> => is this the expected response?
> 

This follows the same reasoning, but for reads. You shouldn't have a
driver that prints out such errors though. A timeout might be a valid
condition.

> mmc0: Test case 17. Correct xfer_size at write (midway failure)...
> s3c2440-sdi s3c2440-sdi: bad data crc (incoming)
> mmc0: Result: ERROR (-84)

This is similar to the above tests. The test tells the controller the
request has two blocks, but tells the card it's only one. The purpose
is to simulate a write error half way through a transaction.

> mmc0: Test case 18. Correct xfer_size at read (midway failure)...
> s3c2440-sdi s3c2440-sdi: data timeout
> mmc0: Result: OK

Same for reads.

> 
> Also, any indications of how the "busy state" warnings could be
> debugged?
> 

I'm not familiar with this controller, so no. The warning is about the
driver returning early when it should be waiting for the card to stop
its busy signalling first. The idea here is that that upper layers can
only do this by polling, whereas the driver might be able to do it
using interrupts (i.e. much cheaper). Not a high priority though. Most
drivers get this wrong (including my own).

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.
