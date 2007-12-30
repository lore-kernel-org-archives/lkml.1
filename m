Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXL3O43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXL3O43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXL3O4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:56:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38710 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756232AbXL3O4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:56:15 -0500
Date: Sun, 30 Dec 2007 14:47:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230144700.78f4605c@the-village.bc.nu>
In-Reply-To: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> slowdown entirely (obviously that is not for 2.6.24 either, though!), and 
> drivers that then are shown to really need it could use their *own* ports.

*No* - that is the one thing they cannot do. The _p cycles on ISA for 2MHz
parts on a standard ISA bus needs the delay to come off another device. 

For modern systems we should just use tsc delays, but we have to fix all
the drivers first as right now 0x80 causes posting and we have some PCI
users (I think probably all bogus), and we need to fix the tons of
locking errors that are mostly covered by the inb 0x80 being an
indivisible operation so not getting split by interrupts/SMP.

I've been going through the drivers that use it - the biggest mess
appears to be in the watchdog drivers all of which copied an original
lack of locking from the mid 1990s caused by umm.. me. I guess my past is
catching up with me ;)

Some of the ISA network users (like the scc driver) are going to be quite
foul to fix but most of it looks quite sane.

The X server also appears to touch 0x80 in some cases but we can hope
only on ancient hardware.

Alan
