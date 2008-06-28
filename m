Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYF1MnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYF1MnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYF1MnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:43:16 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49486 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYF1MnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:43:15 -0400
Date: Sat, 28 Jun 2008 14:43:13 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080628144313.353bbf18@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080627215627.5d75639c@mjolnir.drzeus.cx>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
	<20080627211014.0e80db04@siona.local>
	<20080627215627.5d75639c@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 12:43:01.0559 (UTC) FILETIME=[80578470:01C8D91C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> I am a bit concerned about the problems with mmc_test you mentioned
> though. Have you sent any info about those previously?

No, I don't think I have.

Here are the results from one of my cards:

sh-3.2# echo > /sys/class/mmc_host/mmc0/mmc0\:b368/test 
mmc0: Starting tests of card mmc0:b368...
mmc0: Test case 1. Basic write (no data verification)...
mmc0: Result: OK
mmc0: Test case 2. Basic read (no data verification)...
mmc0: Result: OK
mmc0: Test case 3. Basic write (with data verification)...
mmc0: Result: OK
mmc0: Test case 4. Basic read (with data verification)...
mmc0: Result: OK
mmc0: Test case 5. Multi-block write...
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Result: OK
mmc0: Test case 6. Multi-block read...
mmc0: Result: OK
mmc0: Test case 7. Power of two block writes...
mmc0: Result: UNSUPPORTED (by card)
mmc0: Test case 8. Power of two block reads...
mmc0: Result: OK
mmc0: Test case 9. Weird sized block writes...
mmc0: Result: UNSUPPORTED (by card)
mmc0: Test case 10. Weird sized block reads...
mmc0: Result: OK
mmc0: Test case 11. Badly aligned write...
mmc0: Result: OK
mmc0: Test case 12. Badly aligned read...
mmc0: Result: OK
mmc0: Test case 13. Badly aligned multi-block write...
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Result: OK
mmc0: Test case 14. Badly aligned multi-block read...
mmc0: Result: OK
mmc0: Test case 15. Correct xfer_size at write (start failure)...
mmc0: Result: ERROR (-84)
mmc0: Test case 16. Correct xfer_size at read (start failure)...
mmc0: Result: OK
mmc0: Test case 17. Correct xfer_size at write (midway failure)...
mmc0: Result: ERROR (-84)
mmc0: Test case 18. Correct xfer_size at read (midway failure)...
mmc0: Result: OK
mmc0: Tests completed.

Tests 7 and 9 are not supported by the card, so I can't do much about
it except go through all the cards I have available and see if one of
them supports this test.

Tests 15 and 17 return -EILSEQ instead of -ETIMEDOUT. The at91_mci
driver has the same problem, and I think it's a hardware issue -- the
controller wrongly flags a CRC error instead of a data timeout error
if the card doesn't respond with any CRC status after a write. I don't
know how to work around that problem.

Of course, I could cheat and return -ETIMEDOUT on CRC errors. That
would make the driver pass the tests, right? ;-)

The test results are the same regardless of whether DMA is used or not,
but short and/or difficult transfers are always done in PIO mode.

Haavard
