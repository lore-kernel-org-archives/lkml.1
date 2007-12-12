Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbXLLQTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbXLLQTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXLLQTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:19:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33904 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbXLLQTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:19:39 -0500
Date: Wed, 12 Dec 2007 16:12:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rene Herman" <rene.herman@keyaccess.nl>, "Paul Rolland" <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, <rol@witbe.net>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071212161245.3f388229@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<20071211143224.15900995@tux.DEF.witbe.net>
	<475E9B9B.2050709@keyaccess.nl>
	<475EACB8.7080608@keyaccess.nl>
	<20071211163706.2dc82275@tux.DEF.witbe.net>
	<475EB263.2050405@keyaccess.nl>
	<475EC1C0.2040000@reed.com>
	<20071211173231.2b87a81f@the-village.bc.nu>
	<475EE2CA.6020601@reed.com>
	<Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
	<475F23BD.3040903@reed.com>
	<Pine.LNX.4.61.0712120802300.4443@chaos.analogic.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is another reason we can't just do a dumb changeover - two actually

#1: Some drivers are using inb_p/outb_p in PCI cases which are going to
cause PCI posting changes. Most are probably just wrong in the first
place but they need hand checking

#2: We've got SMP cases that only 'work' because the odds of splitting
the outb and the following port 0x80 cycle, which locks the bus, are tiny.

That is we've got

		CPU1			CPU2
		main path		irq path
		outb
					outb

		inb 0x80
					inb 0x80

races in one or two spots.
