Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbYBNIgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbYBNIgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYBNIgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:36:36 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60557 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753645AbYBNIgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:36:32 -0500
Date: Thu, 14 Feb 2008 09:36:23 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080214093623.78d3baf3@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20802131555y5217f300pc94f82f192ffb60a@mail.gmail.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
	<20080213220646.081583d6@siona>
	<e9c3a7c20802131555y5217f300pc94f82f192ffb60a@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 16:55:54 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> Well, the other two possibilities are:
> 
> 1/ Spin/sleep until a descriptor shows up

Won't work since the transfer hasn't been started yet, so it will spin
indefinitely.

I guess we could return, send the command and use a waitqueue to wait
for the callback. But this will make error handling seriously yucky.


> 2/ Fall back to PIO for a few transfers

Which means killing performance for large transfers. Not really an
option.

It's ok to use PIO for small and/or odd transfers like "read 2 bytes
from this SDIO register", something that the mmc-block driver would
never ask us to do. Using PIO for huge block data transfers will really
hurt.

> Descriptor availability is improved if the code interleaves allocation
> and submission.  Currently it looks like we wait until all descriptors
> for the scatterlist are allocated before we start submitting.

No, none of the descriptors will appear before the command has been
sent, the card has responded, and a full block of data has been
transferred. I suppose we could send the command earlier, but I don't
think it will help a lot and it will complicate error handling.

There may be room for improvement though. The current scheme of
splitting DMA preparation and submission was initially used because
older versions of the controller would instantly fail with an overrun
or underrun if the data wasn't available immediately when the command
had been sent. Sending the command earlier and doing interleaved
allocation and submission might improve performance a bit.

I think I'll try triggering the mmc tasklet from the DMA callback for
now. Scheduling a tasklet from another tasklet should work just fine,
right?

Haavard
