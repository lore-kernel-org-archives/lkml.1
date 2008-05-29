Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYE2SSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYE2SSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYE2SRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:17:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45453 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755536AbYE2SRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:17:18 -0400
Date: Thu, 29 May 2008 19:02:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jeff@garzik.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529190235.258d304e@core>
In-Reply-To: <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why the *hell* doesn't it just fix "ata_sff_altstatus()" instead? Why does 
> it introduce a ludicrously named stupid "maybe" version of it that doesn't 
> oops?

Ok the problem is we have three cases to distinguish

- altstatus must be used - in which case we want to blow up anyway if we
touch it (the usual case)
- altstatus should be used if available - shared IRQ check
- altstatus being used for flushing - altstatus irrelevant, it just has
to flush somehow.

So the _maybe naming sucks, but the reasoning I think is sound. The other
way to do it would be to replace it and the bit of irq handler logic with
an ata_sff_busy() that did the status checks correctly for both ctl and
non-ctl capable devices.

> It may be that you meant to make it an "else if" case, ie if there was no 
> IO-read, then you do a ndelay(400) as a last desperate case, but that's 
> not how your ata_sdd_sync() is actually written.

The ndelay(400) is correct. The IO-read is Jeff being paranoid and
actually hurts us materially for the usual PIO case (bus PIO not disk
PIO) to the tune of about 1mS a command in many cases, but is needed for
MMIO (which we almost never do for any SFF hardware). That itself is a
different problem that can be fixed later (and not in -rc5). It wants
fixing as its a key reason that old IDE is still faster for PATA.

maybe_altstatus is crap naming but simply making ata_sff_altstatus fake a
reply in arbitary cases risks not catching mistakes and could mean we
don't catch corrupting mistakes which would be very bad indeed.

