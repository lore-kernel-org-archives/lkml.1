Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXLIW3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXLIW3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXLIW3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:29:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52988 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbXLIW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:29:13 -0500
Date: Sun, 9 Dec 2007 22:23:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071209222335.70e52be3@the-village.bc.nu>
In-Reply-To: <1197230609.6563.6.camel@pasglop>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	<1196899818.7033.11.camel@pasglop>
	<200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	<1196917447.7033.17.camel@pasglop>
	<200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	<1196922262.7033.33.camel@pasglop>
	<20071209021231.GA13729@linux-mips.org>
	<1197185091.6572.38.camel@pasglop>
	<1197193794.6572.52.camel@pasglop>
	<20071209133812.2d305a02@the-village.bc.nu>
	<1197230609.6563.6.camel@pasglop>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quite possibly, though as I said in practice, what we did so far
> happened to "just work" on pretty much everything we were faced with
> (which iirc is basically winbond and VIA controllers, possibly a few
> others).
> 
> Anyway, I'll scrub around. Again, I'm not saying the approach is wrong
> in the generic code.

I think the generic code is right, up to the MIPS stuff. What the MIPS
stuff is doing wants looking at further. If it simply can't address
legacy ports them it should set

CONFIG_NO_ATA_LEGACY

and be robust to such resource mappings. The CONFIG option tells libata
to skip over controllers in legacy mode.

For switching quirks you should be fixing the class code in an early
fixup. The early fixups are run before we do the BAR processing. You must
however remember to update dev->class as well as the PCI register if you
do so.

See quirk_svwkrs_csb5ide() for a correct worked example going in the
other direction. If you follow that for the PPC quirks but going native
then you will get desired results, although you want to check/know the BAR
resources are sane, or clear them as part of the process.

So in summary:
	- MIPS resource/bar bit may be wrong - if so lets revert that
	- Rest of the logic is just fine, but you may need to move your
quirks to be 'early' ones.

Alan
