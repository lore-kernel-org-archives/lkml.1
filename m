Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZDUOPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZDUOPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZDUOPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:15:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50756 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbZDUOPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:15:18 -0400
From: "Kumar, Purushotam" <purushotam@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Apr 2009 19:44:57 +0530
Subject: RE: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for
 DaVinci family.
Thread-Topic: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for
 DaVinci family.
Thread-Index: Acm/lBYWUPEAh+drRcukdH0zK7kowgC9m+/w
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301CCA99738@dbde02.ent.ti.com>
References: <1238666196-29979-1-git-send-email-purushotam@ti.com>
 <20090410214143.4aa4045e@mjolnir.ossman.eu>
 <B85A65D85D7EB246BE421B3FB0FBB59301CCA0190F@dbde02.ent.ti.com>
 <200904171238.15077.david-b@pacbell.net>
In-Reply-To: <200904171238.15077.david-b@pacbell.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > This required by SD controller as suggested by IP designer. Please
> > look at SD controller spec at http://www.ti.com/litv/pdf/sprue30d .
> > Please check section 3.2/3.6 and point no 11/10 in the controller spec.
> 
> In this case the spec says in a note in 2.7.2 that priming
> the fifo is needed for "write transactions" ... since no
> "fifo became empty" IRQ is generated.  It does not limit it
> to the WRITE_BLOCK and WRITE_MULTIPLE_BLOCK commands.
> 
> Those examples are for writing single and multiple blocks; there
> are no SDIO write operations shown, for example, or password
> passing operations.  Those would also suffer from the lack of
> a "fifo became empty" IRQ.
> 

It seems you are right that FIFO is required to be primed before any write transaction. 

> > It does not talk about priming by 32 bytes for any other command.
> Said diffferently, *every* PIO write transaction shown primes
> the fifo ... but there are no examples of non-block writes.

We need to prime the FIFO beforehand with whatever data we intend to transfer. We looked into SDIO driver on DM6446 and observed that it requires priming.


> > This restriction is from SD controller.
> 
> Could you confirm that interpretation with the folk who have
> provided that silicon block?
> 
> If your reading is correct, and it's really a restriction to
> those two commands, the documentation should change to say
> that "single and multiple block write commands" require FIFO
> priming ... not all "write transactions" as now written.

Apart from above there was a doubt for:
	if (!host->do_dma && (host->data_dir == DAVINCI_MMC_DATADIR_WRITE))
		davinci_fifo_data_trans(host, 32);
We will also remove check for CMD25 and CMD24 before priming and so it will allow priming for all commands.

Although there does seem to be a bug there ... it should never fill the
fifo with more data than is being sent.

The second parameter is rightly justified as it is the length of fifo. If
you see inside the davinci_fifo_data_trans() the FIFO is only primed based
upon the data size during that transfer. So in a way we are not filling the
fifo with more data.

We will re-submit patch tomorrow. Please let us know if you have any further concerns.
Regards,
Purushotam
