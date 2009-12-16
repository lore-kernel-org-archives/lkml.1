Return-Path: <linux-kernel-owner+w=401wt.eu-S934205AbZLPAB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbZLPAB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934117AbZLPAB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:01:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50373 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934110AbZLPAB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:01:27 -0500
Date: Wed, 16 Dec 2009 00:02:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
Message-ID: <20091216000258.4c294d90@lxorguk.ukuu.org.uk>
In-Reply-To: <1260907788.6521.10.camel@keith-laptop>
References: <1260907788.6521.10.camel@keith-laptop>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.32/drivers/misc/ibmrtl/ibm_rtl.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/ibm_rtl.c	2009-12-14 16:37:19.000000000 -0800

Probably belongs in drivers/firmware as its not a misc_* interface user.

> +	/* Get the address for the Extende Biso Data Area */
> +	ebda_addr = *(u16 *) phys_to_virt(EDBA_ADDR);
> +	ebda_addr <<= 4;
> +	edba_map = ioremap(ebda_addr, 4);
> +	if (!edba_map)
> +		return -ENOMEM;

This is wrong. I wish we had a single proper EBDA handling function
because this keeps coming up.

The rules for the EBDA on PC class hardware as that the EBDA address
provides a real segment offset for the EBDA *if one is present*. Lots of
machines including quite a few suprisingly modern boxes (eg AMD76x
systems without a PS/2 mouse plugged in) don't have an EBDA so you need
to check if the word you read is zero before doing an ioremap.

> +	for (table = (u32 *) edba_map ; \
> +			table < (u32 *) edba_map + ebda_size/4; table++)

You need to check the table is valid and has a correct signature. Not
doing so is completely unsafe.

The rest of the code looks pretty sane to me.

Alan
