Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbXKALJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbXKALJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXKALJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:09:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41275 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbXKALJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:09:41 -0400
Message-ID: <4729B3EA.6040707@garzik.org>
Date: Thu, 01 Nov 2007 07:09:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jens Axboe <jens.axboe@oracle.com>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org> <20071101105335.1f20bab3@the-village.bc.nu>
In-Reply-To: <20071101105335.1f20bab3@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> demonstrated by (a) Alan's patch did not change DMA lbam/lbah 
>> programming and (b) Daniel's report of the message "ata2.00: 66 bytes 
> 
> (a) did. Well the original did, dunno about your version.

We are both half-right.  I reverted my version of that completely, 
applied your version verbatim, and pushed it upstream.  The result: 
atapi_xlat _did_ start programming lbam/lbah for DMA (another behavior 
change), but request-sense DMA path was not changed to program lba[mh] 
for DMA.


>> I am not drawing any conclusions yet, but I'm thinking that blimit=8k 
>> may be a better choice for SATA ATAPI.
> 
> Only if your transfer is actually 8K or more.

No, that's precisely the problem cause for what Daniel is reporting.  We 
are setting blimit=xfer_len(==10), when the device wants to return more 
than 10 bytes.  When set to the old limit (8k), the problem didn't occur.

Prior to this change, __atapi_pio_bytes() happily discarded trailing 
data, so the software already knows how to eat trailing data left to us 
by the ATAPI device.  The printk (and lack of problem) indicated that 
this code was active and working fine.

	Jeff




