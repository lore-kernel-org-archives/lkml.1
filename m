Return-Path: <linux-kernel-owner+w=401wt.eu-S1763852AbXHACKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbXHACKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 22:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXHACKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 22:10:48 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:58758 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbXHACKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 22:10:48 -0400
Message-ID: <46AFEB3C.6020601@gentoo.org>
Date: Tue, 31 Jul 2007 22:09:00 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 14/16] Remove needless kmalloc casts in the zd1211rw drivers.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125446.578465000@hawkeye.stone.uk.eu.org> <46AF44C5.50102@gentoo.org> <46AFDDD8.8050903@s5r6.in-berlin.de>
In-Reply-To: <46AFDDD8.8050903@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>> NAK: this patch adds a sparse warning
>> zd_chip.c:116:15: warning: implicit cast to nocast type
> 
> What does this warning mean?  a16 is defined as zd_addr_t *.

zd_addr_t is defined as
typedef u16 __nocast zd_addr_t;

The __nocast annotation forces us to use explicit casts for values of 
this type. This is really useful as we have functions which take an 
address and a value (e.g. register writes). It's very easy to get them 
in the wrong order and have a non-obvious bug. With this mechanism, 
sparse helps us avoid this.

The case with pointers may be a little unintuitive, but it's a small 
price to pay for a bug that bit us hard once before...

The number of other places we have to cast is very small due to use of 
the preprocessor. For example we have:

#define ZD_ADDR(base, offset) \
	((zd_addr_t)(((base) & ADDR_BASE_MASK) | ((offset) & ADDR_OFFSET_MASK)))

#define CTL_REG(offset)  ZD_ADDR(CR_BASE, offset)	/* byte addressing */

Then we have a few hundred registers defined in terms of CTL_REG.

> Also, why is there this cast right before that?
> 
> 	zd_addr_t *a16 = (zd_addr_t *)NULL;

For similar reasons.

Daniel
