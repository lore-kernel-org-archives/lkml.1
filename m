Return-Path: <linux-kernel-owner+w=401wt.eu-S1762738AbYBNSeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738AbYBNSeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYBNSeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:34:12 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:39788 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYBNSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:34:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=K28uGEZR8DF1LhBaroAv3nt1s6zNElRrOjDhs5Y06YaiNB0RZRsrAIXSILCQRSud3eySl92YRAj9fcPkm48Jvexy18jTLZpC3nXeSt1zoQPprkyuaKTpNFs78eWkz4SvKU2a9iI5UOGknj4TtH8CQSY4kUur1JdQXov307jmyKc=
Message-ID: <e9c3a7c20802141034t1b2994ebyf9b7df216536c6b2@mail.gmail.com>
Date: Thu, 14 Feb 2008 11:34:03 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC controllers
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080214093623.78d3baf3@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	 <e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
	 <20080213220646.081583d6@siona>
	 <e9c3a7c20802131555y5217f300pc94f82f192ffb60a@mail.gmail.com>
	 <20080214093623.78d3baf3@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 764952d44d9b963d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 1:36 AM, Haavard Skinnemoen
<hskinnemoen@atmel.com> wrote:
[..]
>
>  > 2/ Fall back to PIO for a few transfers
>
>  Which means killing performance for large transfers. Not really an
>  option.
>
>  It's ok to use PIO for small and/or odd transfers like "read 2 bytes
>  from this SDIO register", something that the mmc-block driver would
>  never ask us to do. Using PIO for huge block data transfers will really
>  hurt.
>

Except your testing has already shown that running out of descriptors
rarely, if ever happens.  It just becomes an exercise in tuning the
pool size, and letting this simple fall back mechanism be a safety net
for the corner cases.

>
>  > Descriptor availability is improved if the code interleaves allocation
>  > and submission.  Currently it looks like we wait until all descriptors
>  > for the scatterlist are allocated before we start submitting.
>
>  No, none of the descriptors will appear before the command has been
>  sent, the card has responded, and a full block of data has been
>  transferred. I suppose we could send the command earlier, but I don't
>  think it will help a lot and it will complicate error handling.
>
>  There may be room for improvement though. The current scheme of
>  splitting DMA preparation and submission was initially used because
>  older versions of the controller would instantly fail with an overrun
>  or underrun if the data wasn't available immediately when the command
>  had been sent. Sending the command earlier and doing interleaved
>  allocation and submission might improve performance a bit.
>
>  I think I'll try triggering the mmc tasklet from the DMA callback for
>  now. Scheduling a tasklet from another tasklet should work just fine,
>  right?
>

Yeah that should work because you are no longer under the channel lock.

--
Dan
