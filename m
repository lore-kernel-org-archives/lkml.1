Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYKPQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYKPQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYKPQXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:23:44 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59021 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753511AbYKPQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:23:42 -0500
Date: Sun, 16 Nov 2008 11:23:32 -0500
From: Theodore Tso <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
	order.
Message-ID: <20081116162332.GC6958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <20081113150308.3590.qmail@science.horizon.com> <20081114053042.11532.qmail@science.horizon.com> <20081114053314.12093.qmail@science.horizon.com> <20081114213449.14960.qmail@science.horizon.com> <20081114214711.3c1d1473@lxorguk.ukuu.org.uk> <20081115001013.GM25117@mit.edu> <20081116152352.20261.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116152352.20261.qmail@science.horizon.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 10:23:52AM -0500, George Spelvin wrote:
> Re: shared IRQs and PCI bus...
> In desktop hardware, yes.  But PC-104 equipment (for the benefit of
> confused bystandaers, that's classic ISA bus in a different form factor)
> is still going strong; I just added an 8-port serial card to a little
> embedded box.
> 
> But even PCI reads are slow, and the current code does not optimize the
> case when interrupts are level-sensitive.  (The optimization is trivial,
> but detecting whether the interrupt is edge- or level-sensitive looks
> messy.)

> The idea is that, if you have 4 ports sharing an interrupt, and the fourth
> is the one that's busy, you'll check every port twice.  If you could check
> the busy port first, you'd only need to to do 5 checks.

Um, but the ISA bus was edge sensitive.  So presumably PC-104 would be
as well.  So you *have* to scan all of the ports twice, because you
want to keep the race window as narrow as possible.  If you don't
service incoming characters for a previously idle port (because of the
thought that you only have to check currently busy ports as an
optimization), you'll never get an interrupt on that IRQ again, and
you'll have to wait for the serial timeout to save you (and in the
meantime, you'll likely be losing characters as the FIFO's overflow).

	  	 	   	  	     	- Ted
