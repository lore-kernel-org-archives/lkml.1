Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZBKKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZBKKC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZBKKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:02:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36623 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754274AbZBKKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:02:19 -0500
Date: Wed, 11 Feb 2009 10:02:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver
Message-ID: <20090211100249.1ce0a170@lxorguk.ukuu.org.uk>
In-Reply-To: <1234312633.15410.546.camel@keith-laptop>
References: <1234312633.15410.546.camel@keith-laptop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (readb(rtl+RTL_STATE) != value) {
> +		if (value == 1)
> +			writeb(1, (rtl+RTL_CMD));
> +		else
> +			writeb(2, (rtl+RTL_CMD));

		writeb( 1 + value , ... ) ??

> +	rtl = ioremap(table_addr, RTL_TABLE_SIZE);
> +
> +	if (!rtl) {
> +		ret = -ENOMEM;
> +		goto err_out;

Would it be better to eliminate all the ioremap special test casing and
just remap it once at load time, or at least use a single function so the
tests/printks don't all get duplicated ? That would also eliminate the
fact you can get multiple mappings of the same thing if there are
multiple parallel users.

I note also there is no locking versus multiple accessors - eg when
writing the RTL_CMD registers


> +	/*get the address for the RTL table from the EBDA */
> +	ebda_addr = *(unsigned short *)phys_to_virt(0x40E);
> +	ebda_addr <<= 4;
> +	ebda_size = 64*1024;
> +
> +	data = ioremap(ebda_addr, ebda_size);

Careful - it is perfectly valid for a BIOS EBDA table to be zero
indicating no EBDA is present, and at this point you've not checked if
the driver is being loaded on a relevant IBM platform.

> +		unsigned int *tmp = (unsigned int *) data++;

Use u32 - it makea it obvious what is going on here.

> +/*needed to decode CmdPortAddress and CmdPortValue*/
> +#define bios_to_value(rtl, offset) (u32)((readb(rtl+(offset+1)) << 8) + \
> +							readb(rtl+offset))

What is wrong with readw() ?


Alan
