Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXLKA2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXLKA2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXLKA2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:28:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:45188 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXLKA17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:27:59 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071211000536.GA4067@linux-mips.org>
References: <1197193794.6572.52.camel@pasglop>
	 <20071209133812.2d305a02@the-village.bc.nu>
	 <1197230609.6563.6.camel@pasglop>
	 <20071209222335.70e52be3@the-village.bc.nu>
	 <1197260962.6563.46.camel@pasglop>
	 <20071210112050.0bd6ac28@the-village.bc.nu>
	 <20071210134056.GC12913@linux-mips.org>
	 <20071210150126.7cec9cbc@the-village.bc.nu>
	 <20071210154732.GB19384@linux-mips.org> <1197319383.8692.18.camel@pasglop>
	 <20071211000536.GA4067@linux-mips.org>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 11:27:24 +1100
Message-Id: <1197332844.9071.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The GT-64111 system controller doesn't provide any kind of mapping
> functionality that would help here.  So legacy port addressing can only
> work by exploiting aliases due to incomplete decoding of legacy ioport
> addreses by the VT82C586 - but direct addressing is impossible.

Ok, that explains how the "fix" that we reverted worked. It caused crap
to be added to the top bits of the address :-)

So here, what you really want to do is not a call to
pcibios_resource_to_bus(), but you actually want to use a different bus
address in the first place, that you know the HW will decode the same
way.

The best way to achieve that imho, is to do a header quirk that is run
just after the generic probe code, which offsets the fixed legacy
resources by 0x10000000 since that's really the bus address you are
going to emit.

Later on, your pcibios_fixup code should take that remove 0x10000000
from all IO resources, since your 0xd0000000 mapping already maps
0x10000000 as you probably already do.

The trick is, you don't want to convert a "resource" into a "bus
address" here, but really issue a different bus address.

Cheers,
Ben.


