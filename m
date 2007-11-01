Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXKAOP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXKAOP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXKAOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:15:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42837 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753044AbXKAOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:15:15 -0400
Date: Thu, 1 Nov 2007 14:15:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071101141501.3746cec2@the-village.bc.nu>
In-Reply-To: <4729B3EA.6040707@garzik.org>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
	<20071031114958.210bd7cc@the-village.bc.nu>
	<20071031115754.GK5059@kernel.dk>
	<4729A0DF.20800@garzik.org>
	<20071101105335.1f20bab3@the-village.bc.nu>
	<4729B3EA.6040707@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We are both half-right.  I reverted my version of that completely, 
> applied your version verbatim, and pushed it upstream.  The result: 
> atapi_xlat _did_ start programming lbam/lbah for DMA (another behavior 
> change), but request-sense DMA path was not changed to program lba[mh] 
> for DMA.

I didn't realise we ever issued reques sense by DMA ?

> > Only if your transfer is actually 8K or more.
> 
> No, that's precisely the problem cause for what Daniel is reporting.  We 
> are setting blimit=xfer_len(==10), when the device wants to return more 
> than 10 bytes.  When set to the old limit (8k), the problem didn't occur.

Lots of *other* problems occur instead. Daniel is reporting that if he
makes a stupid request to a buggy drive he gets a reset and the system
continues happily. Even that reset being a reset not a new command issue
is actually us being excessively paranoid.

Prior to these changes people were reporting things like "I cannot
use my CD-ROM".

So given we have ten years of experience of the method I put in taken
from the old IDE layer versus a good way to make one buggy request work
and break everything else - I *know* which I consider to be the right
path.

And PIO drains of DMA controllers do not work for most controllers, some
will simply hang solid if you touch the data register as part of a DMA
sequence (eg promise 2026x)

Alan
