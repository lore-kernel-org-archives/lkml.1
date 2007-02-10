Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXBJX4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXBJX4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 18:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXBJX4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 18:56:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXBJX4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 18:56:03 -0500
Date: Sat, 10 Feb 2007 23:55:53 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
Message-ID: <20070210235553.GP10050@ftp.linux.org.uk>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com> <45CE43B5.2020806@gmail.com> <Pine.LNX.4.64.0702101425230.8424@woody.linux-foundation.org> <20070210225033.GO10050@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210225033.GO10050@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 10:50:33PM +0000, Al Viro wrote:
> We don't even require ioremap().  What the hell could it possibly mean on
> e.g. UML?  The same goes for DMA.  And yes, of course it means that a lot
> of drivers are not buildable on it - hardly a surprise, that...

FWIW, the current picture wrt io-related stuff looks so:

alpha frv i386 ia64 mips parisc powerpc sparc64 x86_64: full set
s390: no ioport_map, no ioread*/iowrite*, no port IO except for (in|out)b(_p|)
sparc: insl() and friends are not there unless we have PCI, ioremap() is
not exported unless on PCI.
um: odd stubs for inb()/outb(), no other port IO; no ioremap(), no
memcpy_..io(), for some reason read[bwlq]()/write[bwlq]() are there,
but never used.  No ioread*/iowrite*.
arm: depends on subarchitecture.  E.g. 32bit port access might be a sham
(causes fun problems with e.g. modular ide-core on some subarchitectures -
it doesn't _use_ insl(), but the reference is there no matter what, so the
lack of export => missing symbol).
m68k: as if.  No ioread/iowrite, ioremap() only for hp300, availability of
any IO accessor depends on config in rather weird ways.
m32r: no ioread/iowrite/ioport_map
the rest of embedded stuff: no idea, never played with those targets.
